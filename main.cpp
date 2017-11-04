#include <stddef.h>
#include <i386/_types.h>
#include <sys/_types/_ssize_t.h>
#include "pony.h"
#include "shootout.h"
#include <iostream>

using namespace std;

int main(int argc, char** argv) {
  pony_init(argc, argv);

  AmbientAuth* auth = AmbientAuth_Alloc();
  RealMain* main = RealMain_Alloc();
  RealMain_tag_create_oo__send(main, auth);

  pony_start(false, true);

  return 0;
}
