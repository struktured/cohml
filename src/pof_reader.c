// Pof Writer C interface

#include "cohml.h"

using namespace coherence::io::pof;

extern "C" {

void read_int32(PofReader::Handle hIn, const int index) {
  hIn->readInt32(index);
  // TODO
}

void read_string(PofReader::Handle hIn, const int index) {
  hIn->readString(index);
  // TODO
}

}

// End of file
