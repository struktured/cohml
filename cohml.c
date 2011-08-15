extern "C" {
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/callback.h>
#include <caml/fail.h>
} //extern C

#include "coherence/lang.ns"
#include "coherence/net/CacheFactory.hpp"
#include "coherence/net/NamedCache.hpp"
#include "coherence/lang/Exception.hpp"
#include "coherence/util/MapListener.hpp"
#include "coherence/util/MapEvent.hpp"
#include <iostream>
#include <sstream>
#include "cohml.h"

using namespace coherence::lang;
using coherence::net::CacheFactory;
using coherence::net::NamedCache;
using std::endl;
using std::cerr;
using std::ostringstream;
using coherence::util::MapListener;
using coherence::util::MapEvent;

#define DEBUG
#pragma GCC diagnostic ignored "-Wwrite-strings"

// Using C to interact with OCaml
extern "C" {
  /* write a timestamped log message {C} for C code */
  void debug(const char* msg) {
    char datebuf[32];
    time_t t = time(NULL);
    strftime((char*)&datebuf, 31, "%a %b %e %T %Y", (gmtime(&t)));
    cerr << datebuf << ": " << msg << endl;
  }
  
  /* kick an error back into OCaml-land */
  void raise_caml_exception(Exception::View ce) {
    CAMLlocal1(e);
    e = caml_alloc_tuple(2);
    Store_field(e, 0, caml_copy_string((ce->getName())->getCString()));
    Store_field(e, 1, caml_copy_string((ce->getMessage())->getCString()));
    caml_raise_with_arg(*caml_named_value("Coh_exception"), e);
  }

  // operations for the OCaml GC
  static struct custom_operations coh_custom_ops = {"coh_custom_ops", NULL, NULL, NULL, NULL, NULL};

  // connect to Coherence and open a named cache
  value caml_coh_getcache(value cn) {
    CAMLparam1(cn);
    char* cache_name = String_val(cn);
    Cohml* c;
    try {
      c = new Cohml(cache_name);
    } catch (Exception::View ce) {
      raise_caml_exception(ce);
    }
    value v = caml_alloc_custom(&coh_custom_ops, sizeof(Cohml*), 0, 1);
    Cohml_val(v) = c;
    CAMLreturn(v);
  }

  // disconnect entirely - will need a method to do this for a single cache at a time
  value caml_coh_shutdown(value co) {
    CAMLparam1(co);
    Cohml* c = Cohml_val(co);
    delete (c);
    CAMLreturn(Val_unit);
  }

  // put a key-value pair into the cache, strings only for now
  value caml_coh_put(value co, value k, value v) {
    CAMLparam3(co, k, v);
    Cohml* c = Cohml_val(co);
    char* key = String_val(k);
    char* val = String_val(v);

    c->put(key, val);

    CAMLreturn(Val_unit);
  }

  // delete a pair with a string key from the cache
  value caml_coh_remove(value co, value k) {
    CAMLparam2(co, k);
    Cohml* c = Cohml_val(co);
    char* key = String_val(k);
    
    c->remove(key);

    CAMLreturn(Val_unit);
  }

  // register a maplistener (well, the maplistener, for now)
  value caml_coh_addfilterlistener(value co) {
    CAMLparam1(co);
    Cohml* c = Cohml_val(co);

    // check that all the callback functions are defined!
    value* cbf_i = caml_named_value("cbf_coh_insert");
    value* cbf_u = caml_named_value("cbf_coh_update");
    value* cbf_d = caml_named_value("cbf_coh_delete");
    if ( (cbf_i == NULL) || (cbf_u == NULL) || (cbf_d == NULL)) {
      caml_raise_with_arg(*caml_named_value("Cohml_exception"), caml_copy_string("Cannot listen: callbacks not defined!"));
    } else {
      c->addFilterListener(cbf_i, cbf_u, cbf_d);
    }

    CAMLreturn(Val_unit);
  }

  // get a string key-value pair from the cache - raises NullPointerException if the key does not exist
  value caml_coh_get(value co, value k) {
    CAMLparam2(co, k);
    Cohml* c = Cohml_val(co);
    char* key = String_val(k);
    
    try {
      const char* val = c->getCString(key);
      CAMLreturn(caml_copy_string(val));
    } catch (Exception::View ce) {
      raise_caml_exception(ce);
    }
    CAMLreturn(caml_copy_string("")); //should never get here
  }
} // extern C

// Using C++ to interact with Coherence
Cohml::Cohml(char* cn) {
  String::View vsCacheName = cn;
  hCache = CacheFactory::getCache(vsCacheName);
}

void Cohml::put(char* k, char* v) {
  String::View vsKey = k; String::View vsVal = v;
  hCache->put(vsKey, vsVal);
#ifdef DEBUG
  msg << __func__ << ": Put key=" << vsKey << " value=" << vsVal;
  debug(msg.str().c_str());
#endif
}
  
void Cohml::remove(char* k) {
  String::View vsKey = k; 
  hCache->remove(vsKey);
#ifdef DEBUG
  msg << __func__ << ": Removed key=" << vsKey;
  debug(msg.str().c_str());
#endif
}

const char* Cohml::getCString(char* k) {
  String::View vsKey = k;
  vsRet = cast<String::View>(hCache->get(vsKey));
#ifdef DEBUG
  msg << __func__ << ": Get key=" << vsKey << " value=" << vsRet;
  debug(msg.str().c_str());
#endif
  return vsRet->getCString();
}

void Cohml::addFilterListener(value* cbf_i, value* cbf_u, value* cbf_d) {
  TypedHandle<CohmlMapListener> cml = CohmlMapListener::create();
  cml->cbf_insert = cbf_i; cml->cbf_update = cbf_u; cml->cbf_delete = cbf_d;

  hCache->addFilterListener(cml);
#ifdef DEBUG
  msg << __func__ << ": listening";
  debug(msg.str().c_str());
#endif
}

Cohml::~Cohml() {
#ifdef DEBUG
  msg << __func__ << ": Disconnecting from Coherence";
  debug(msg.str().c_str());
#endif  
  CacheFactory::shutdown();
}

// call the OCaml function cbf_coh_insert with a new key-value pair
void CohmlMapListener::entryInserted(MapEvent::View vEvent) {
  caml_callback2(*cbf_insert,
		 caml_copy_string(cast<String::View>(vEvent->getKey())->getCString()), 
		 caml_copy_string(cast<String::View>(vEvent->getNewValue())->getCString()));
}

// call the OCaml function cbf_coh_update with the key, the previous value and the new value
void CohmlMapListener::entryUpdated(MapEvent::View vEvent) {
  caml_callback3(*cbf_update,
		 caml_copy_string(cast<String::View>(vEvent->getKey())->getCString()),  
		 caml_copy_string(cast<String::View>(vEvent->getOldValue())->getCString()), 
		 caml_copy_string(cast<String::View>(vEvent->getNewValue())->getCString()));
}

// call the OCaml function cb_coh_delete with the key just removed from the cache
void CohmlMapListener::entryDeleted(MapEvent::View vEvent) {
  caml_callback(*cbf_delete,
		caml_copy_string(cast<String::View>(vEvent->getKey())->getCString()));
}

// store an object of type Message in the grid
void Cohml::put_message(Message& m) {
  Managed<Message>::View vMessage = Managed<Message>::create(m);
  Integer32::View vKey = Integer32::create(m.getId());
  hCache->put(vKey, vMessage);
#ifdef DEBUG
  msg << __func__ << ": Put message key=" << vKey;
  debug(msg.str().c_str());
#endif
}

// retrieve a message keyed by its ID - or throws NullPointerException if not found
const Message* Cohml::get_message(int k) {
  Integer32::View vKey = Integer32::create(k);
  Managed<Message>::View vm = cast<Managed<Message>::View>(hCache->get(vKey));
  Message* m = new Message(vm->getId(), vm->getPriority(), vm->getSubject(), vm->getBody());
  return m;
}

// End of file
