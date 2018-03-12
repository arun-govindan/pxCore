/*

pxCore Copyright 2005-2018 John Robinson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

// pxCore CopyRight 2007-2009 John Robinson
// Portable Framebuffer and Windowing Library
// pxTimerNative.cpp

#include <windows.h>
#include <stdint.h>

static bool gFreqInitialized = false;
static LARGE_INTEGER gFreq;

double pxSeconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart / (double)gFreq.QuadPart);
}

double pxMilliseconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart * 1000) / (double)gFreq.QuadPart;
}

double pxMicroseconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart * 1000000) / (double)gFreq.QuadPart;
}

void pxSleepMS(uint32_t sleepMS)
{
    Sleep(sleepMS);
}