/*

 rtCore Copyright 2005-2018 John Robinson

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

// rtCore.h

#ifndef RT_CORE_H
#define RT_CORE_H

#include "rtConfig.h"

// Assumed platform headers
#include <stdint.h>
#include "rtError.h"

#if defined(RT_PLATFORM_LINUX)
#include "unix/rtConfigNative.h"
#elif defined (RT_PLATFORM_WINDOWS)
#include "win/rtConfigNative.h"
#else
#error "PX_PLATFORM NOT HANDLED"
#endif

#ifndef UNUSED_PARAM
#define UNUSED_PARAM(x) (void (x))
#endif

#ifndef finline
#define finline inline
#endif

#endif
