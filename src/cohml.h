#ifndef COHML_H
#define COHML_H

extern "C" {
#include <caml/mlvalues.h>
}

#include "coherence/lang.ns"
#include "coherence/net/CacheFactory.hpp"
#include "coherence/net/NamedCache.hpp"
#include "coherence/util/MapListener.hpp"
#include "coherence/util/MapEvent.hpp"
#include "coherence/net/cache/ContinuousQueryCache.hpp"
#include "coherence/util/Filter.hpp"
#include "coherence/util/MapListenerSupport.hpp"

#include <iostream>
#include <vector>

using namespace coherence::lang;
using coherence::net::CacheFactory;
using coherence::net::NamedCache;
using coherence::util::MapListener;
using coherence::util::MapEvent;
using coherence::net::cache::ContinuousQueryCache;
using coherence::util::Filter;
using coherence::util::MapListenerSupport;

// note - to use debugging DEBUG must be set *before* #including this file
#ifdef DEBUG
#define DEBUG_MSG(x) msg << __FILE__ << ":" << __LINE__ << " in " << __func__ <<"(): "<< x; debug(msg.str().c_str()); msg.str(""); 
#else
#define DEBUG_MSG(x) //x
#endif 

#define Cohml_val(v)   (*((Cohml**)       Data_custom_val(v)))

extern "C" {
  // log a debugging message to stderr/cerr
  void debug(const char* msg);
  // return an exception from Coherence to OCaml
  void raise_caml_exception(Exception::View ce);
}

#endif
// End of file
