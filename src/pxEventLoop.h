

// pxEventLoop.h

#ifndef PX_EVENTLOOP_H
#define PX_EVENTLOOP_H

// Prototype for the portable entry point for applications using the
// pxCore framework
int pxMain(int argc, char* argv[]);

// Class used to manage an application's main event loop
class pxEventLoop
{
public:
  void run();
  void exit();

  void runOnce();
};

#endif

