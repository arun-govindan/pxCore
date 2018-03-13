// pxOffscreenNative.h

#ifndef PX_OFFSCREEN_NATIVE_H
#define PX_OFFSCREEN_NATIVE_H

#include "../pxCore.h"
#include "../pxBuffer.h"

class pxOffscreenNative: public pxBuffer
{
public:
    pxOffscreenNative(): data(NULL) {}
    virtual ~pxOffscreenNative() {}

    pxError term();

    void swizzleTo(rtPixelFmt /*fmt*/) {};

protected:
    char* data;
};

#endif
