#include <stddef.h>
#include <i386/_types.h>
#include <sys/_types/_ssize_t.h>
#include "pony.h"
#include "shootout.h"
#include <iostream>

using namespace std;

int main(int argc, char** argv) {
  /* Initialize the pony runtime */
  pony_init(argc, argv);
  pony_start(true, true);

  /* Create an empty renderer */
  Renderer* renderer = Renderer_Alloc();

  /* Unschedule the renderer an make the main thread become it */
  pony_register_thread();
  pony_ctx_t* context = pony_ctx();
  pony_unschedule(context, (pony_actor_t*)renderer);
  pony_become(context, (pony_actor_t*)renderer);

  /* Send the first message to the renderer - create */
  Renderer_tag_create_o__send(renderer);

  /* Start the actual application */
  AmbientAuth* auth = AmbientAuth_Alloc();
  RealMain* main = RealMain_Alloc();
  RealMain_tag_create_ooo__send(main, auth, renderer);

  /* Handle messages arriving to the renderer */
  while (!Renderer_box_dead_b(renderer)) {
    pony_poll(context);
  }
}
