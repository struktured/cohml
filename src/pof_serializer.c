// Pof Writer C interface

#include "cohml.h"

using namespace coherence::io::pof;

extern "C" {

void serialize(PofWriter::Handle hOut, const int index, int value) {
  hOut->writeInt32(index, value);
  // TODO
}

void * deserialize(PofWriter::Handle hOut, const int index, char * value) {
  hOut->writeString(index, value);
  // TODO
}

}


