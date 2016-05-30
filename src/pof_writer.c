// Pof Writer C interface

#include "cohml.h"

using namespace coherence::io::pof;

extern "C" {

void write_int32(PofWriter::Handle hOut, const int index, int value) {
  hOut->readInt32(index);
  // TODO
}

void write_string(PofWriter::Handle hOut, const int index, char * value) {
  hOut->readString(index);
  // TODO
}

}

// End of file
