// Pof Writer C interface

#include "cohml.h"

using namespace coherence::io::pof;

extern "C" {

void write_int32(PofWriter::Handle hOut, const int index, const int value) {
  hOut->writeInt32(index, value);
}

void write_string(PofWriter::Handle hOut, const int index, const char * value) {
  hOut->writeString(index, std::string(value));
}

}

// End of file
