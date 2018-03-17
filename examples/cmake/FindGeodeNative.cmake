# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#.rst:
# FindGeodeNative
# ---------
#
# Find the Geode Native headers and library.
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``GeodeNative::cpp``
# ``GeodeNative:dotnet``
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project:
#
# ``GeodeNative_FOUND``
#   true if the Geode Native headers and libraries were found.
#
# ``GeodeNative_DOTNET_LIBRARY``
#   Path to .NET assembly file.
#

set(_GEODE_NATIVE_ROOT "")
if(GeodeNative_ROOT AND IS_DIRECTORY "${GeodeNative_ROOT}")
    set(_GEODE_NATIVE_ROOT "${GeodeNative_ROOT}")
    set(_GEODE_NATIVE_ROOT_EXPLICIT 1)
else()
    set(_ENV_GEODE_NATIVE_ROOT "")
    if(DEFINED ENV{GFCPP})
        file(TO_CMAKE_PATH "$ENV{GFCPP}" _ENV_GEODE_NATIVE_ROOT)
    endif()
    if(_ENV_GEODE_NATIVE_ROOT AND IS_DIRECTORY "${_ENV_GEODE_NATIVE_ROOT}")
        set(_GEODE_NATIVE_ROOT "${_ENV_GEODE_NATIVE_ROOT}")
        set(_GEODE_NATIVE_ROOT_EXPLICIT 0)
    endif()
    unset(_ENV_GEODE_NATIVE_ROOT)
endif()

set(_GEODE_NATIVE_HINTS)
set(_GEODE_NATIVE_PATHS)

if(_GEODE_NATIVE_ROOT)
    set(_GEODE_NATIVE_HINTS ${_GEODE_NATIVE_ROOT})
    set(_GEODE_NATIVE_HINTS ${_GEODE_NATIVE_ROOT})
else()
    set(_GEODE_NATIVE_PATHS (
        "/opt/local"
        "/usr/local"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../../"
        "C:/program files" ))
endif()

# Begin - component "cpp"
set(_GEODE_NATIVE_CPP_NAMES apache-geode)

find_library(GeodeNative_CPP_LIBRARY
    NAMES ${_GEODE_NATIVE_CPP_NAMES}
    HINTS ${_GEODE_NATIVE_HINTS}
    PATHS ${_GEODE_NATIVE_PATHS}
    PATH_SUFFIXES geode-native/lib lib 
)

# Look for the header file.
find_path(GeodeNative_CPP_INCLUDE_DIR NAMES geode/CacheFactory.hpp
    HINTS ${_GEODE_NATIVE_HINTS}
    PATHS ${_GEODE_NATIVE_PATHS}
    PATH_SUFFIXES geode-native/include include
)
# End - component "cpp"

# Begin - component "dotnet"
set(_GEODE_NATIVE_DOTNET_NAMES Apache.Geode.dll)

find_file(GeodeNative_DOTNET_LIBRARY
  NAMES ${_GEODE_NATIVE_DOTNET_NAMES}
  HINTS ${_GEODE_NATIVE_HINTS}
  PATHS ${_GEODE_NATIVE_PATHS}
  PATH_SUFFIXES geode-native/bin bin 
)
# End - component "dotnet"

# TODO find version
set(GEODE_NATIVE_VERSION_STRING 1.0)

if (GeodeNative_FIND_COMPONENTS)
  set(_GEODE_NATIVE_REQUIRED_VARS)
  foreach (component ${GeodeNative_FIND_COMPONENTS})
    if (component STREQUAL "cpp")
      list(APPEND _GEODE_NATIVE_REQUIRED_VARS GeodeNative_CPP_LIBRARY GeodeNative_CPP_INCLUDE_DIR)
    endif()
    if (component STREQUAL "dotnet")
      list(APPEND _GEODE_NATIVE_REQUIRED_VARS GeodeNative_DOTNET_LIBRARY)
    endif()
  endforeach()
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GeodeNative
                                  REQUIRED_VARS ${_GEODE_NATIVE_REQUIRED_VARS}
                                  VERSION_VAR GEODE_NATIVE_VERSION_STRING)

# Copy the results to the output variables and target.
if(GeodeNative_FOUND)
  if(NOT TARGET ${GEODE_NATIVE_CPP_TARGET})
    set(GEODE_NATIVE_CPP_TARGET "GeodeNative::cpp")
    add_library(${GEODE_NATIVE_CPP_TARGET} UNKNOWN IMPORTED)
    set_target_properties(${GEODE_NATIVE_CPP_TARGET} PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
      IMPORTED_LOCATION "${GeodeNative_CPP_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${GeodeNative_CPP_INCLUDE_DIR}")
  endif()
  if(NOT TARGET ${GEODE_NATIVE_DOTNET_TARGET})
    set(GEODE_NATIVE_DOTNET_TARGET "GeodeNative::dotnet")
    add_library(${GEODE_NATIVE_DOTNET_TARGET} UNKNOWN IMPORTED)
    set_target_properties(${GEODE_NATIVE_DOTNET_TARGET} PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "CSharp"
      IMPORTED_LOCATION "${GeodeNative_DOTNET_LIBRARY}")
  endif()
else()
  message(STATUS "FOUND var not set")
endif()

mark_as_advanced(GeodeNative_CPP_INCLUDE_DIR GeodeNative_CPP_LIBRARY GeodeNative_DOTNET_LIBRARY)