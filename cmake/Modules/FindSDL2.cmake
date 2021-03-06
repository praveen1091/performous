# - Try to find SDL2
# Once done, this will define
#
#  SDL2_FOUND - system has SDL2
#  SDL2_INCLUDE_DIRS - the SDL2 include directories
#  SDL2_LIBRARIES - link these to use SDL2
#  SDL2_SDL_LIBRARY - only libSDL2
#  SDL2_SDLmain_LIBRARY - only libSDL2main
#  SDL2_SOURCES - add this in the source file list of your target (hack for OSX)
#
# See documentation on how to write CMake scripts at
# http://www.cmake.org/Wiki/CMake:How_To_Find_Libraries

include(LibFindMacros)

libfind_pkg_check_modules(SDL2_PKGCONF sdl2)

find_path(SDL2_INCLUDE_DIR
  NAMES SDL.h
  PATH_SUFFIXES SDL2
  HINTS ${SDL2_PKGCONF_INCLUDE_DIRS}
)

find_library(SDL2_SDL_LIBRARY
  NAMES SDL2
  HINTS ${SDL2_PKGCONF_LIBRARY_DIRS}
)

# Process others than OSX with native SDL normally
if(NOT "${SDL2_SDL_LIBRARY}" MATCHES "framework")
  if(MINGW)
    set(MINGW32_LIBRARY mingw32)
    set(SDL2_PROCESS_LIBS ${SDL2_PROCESS_LIBS} MINGW32_LIBRARY)
  endif()
  find_library(SDL2_SDLmain_LIBRARY
    NAMES libSDL2main.a SDL2main
    HINTS ${SDL2_PKGCONF_LIBRARY_DIRS}
  )
  if (SDL2_SDLmain_LIBRARY)
    set(SDL2_PROCESS_LIBS ${SDL2_PROCESS_LIBS} SDL2_SDLmain_LIBRARY)
  endif()
  set(SDL2_PROCESS_LIBS ${SDL2_PROCESS_LIBS} SDL2_SDL_LIBRARY)
endif()

set(SDL2_PROCESS_INCLUDES SDL2_INCLUDE_DIR)
libfind_process(SDL2)

# Special processing for OSX native SDL
if("${SDL2_SDL_LIBRARY}" MATCHES "SDL.framework")
  set(SDL2_SOURCES "osx/SDLmain.m")
  set(SDL2_LIBRARIES "-framework SDL2")
endif()

# All OSX versions need Cocoa
if(APPLE)
  set(SDL2_LIBRARIES ${SDL2_LIBRARIES} "-framework Cocoa")
endif(APPLE)

