// OCaml <-> C++ <-> Coherence binding

#include <iostream>
#include <sstream>


// OCaml includes
extern "C" {
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/callback.h>
#include <caml/fail.h>
} //extern C

// basic includes
#include "coherence/lang.ns"
#include "coherence/net/CacheFactory.hpp"
#include "coherence/net/NamedCache.hpp"
#include "coherence/lang/Exception.hpp"

// includes for MapListener
#include "coherence/util/MapListener.hpp"
#include "coherence/util/MapEvent.hpp"

// includes for queries
#include "coherence/util/extractor/PofExtractor.hpp"
#include "coherence/util/ValueExtractor.hpp"
#include "coherence/util/Filter.hpp"
#include "coherence/util/filter/LessEqualsFilter.hpp"
#include "coherence/util/Iterator.hpp"

// NOTE: if DEBUG is required, it must be #defined *before* cohml.h is #included
//#define DEBUG
#include "cohml.h"

using std::endl;
using std::cerr;
using std::ostringstream;
using std::vector;

using namespace coherence::lang;
using coherence::net::CacheFactory;
using coherence::net::NamedCache;
using coherence::util::MapListener;
using coherence::util::MapEvent;
using coherence::util::ValueExtractor;
using coherence::util::Filter;
using coherence::util::filter::LessEqualsFilter;
using coherence::util::extractor::PofExtractor;
using coherence::util::Iterator;

#pragma GCC diagnostic ignored "-Wwrite-strings"

// Using C to interact with OCaml
extern "C" {
  /* write a timestamped log message tagged {C} for originating in C code */
  void debug(const char* msg) {
    char datebuf[32];
    time_t t = time(NULL);
    strftime((char*)&datebuf, 31, "%a %b %e %T %Y", (gmtime(&t)));
    cerr << datebuf << ": " << msg << " {C}" << endl;
  }

  /* kick an error back into OCaml-land */
  void raise_caml_exception(Exception::View ce) {
    CAMLlocal1(e);
    e = caml_alloc_tuple(2);
    Store_field(e, 0, caml_copy_string((ce->getName())->getCString()));
    Store_field(e, 1, caml_copy_string((ce->getMessage())->getCString()));
    caml_raise_with_arg(*caml_named_value("Coh_exception"), e);
  }
}



