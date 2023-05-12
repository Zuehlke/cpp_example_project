#include <stdint.h>
#include <stddef.h>


// example comes from here: https://github.com/google/fuzzing/blob/master/tutorial/libFuzzer/fuzz_me.cc
// Documentation can be found here: https://llvm.org/docs/LibFuzzer.html
bool FuzzMe(const uint8_t *Data, size_t DataSize) {
    return DataSize >= 3 &&
           Data[0] == 'F' &&
           Data[1] == 'U' &&
           Data[2] == 'Z' &&
           Data[3] == 'Z';  // :‑<
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    FuzzMe(Data, Size);
    return 0;
}
