# Copyright (c) 2016 Gang Liao <gangliao@umd.edu> All Rights Reserve.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

INCLUDE(ExternalProject)

SET(GLOG_SOURCES_DIR ${BAZEL_THIRD_PARTY_DIR}/glog)
SET(GLOG_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/third_party/glog)
SET(GLOG_INCLUDE_DIR "${GLOG_INSTALL_DIR}/include" CACHE PATH "glog include directory." FORCE)

IF(WIN32)
    SET(GLOG_LIBRARIES "${GLOG_INSTALL_DIR}/lib/glog.lib" CACHE FILEPATH "glog library." FORCE)
ELSE(WIN32)
    SET(GLOG_LIBRARIES "${GLOG_INSTALL_DIR}/lib/libglog.a" CACHE FILEPATH "glog library." FORCE)
ENDIF(WIN32)

INCLUDE_DIRECTORIES(${GLOG_INCLUDE_DIR})

ExternalProject_Add(
    extern_glog
    ${EXTERNAL_PROJECT_LOG_ARGS}
    DEPENDS gflags
    SOURCE_DIR       ${GLOG_SOURCES_DIR}
    UPDATE_COMMAND   ""
    DOWNLOAD_COMMAND ""
    ${EXTERNAL_PROJECT_CMAKE_ARGS}
    CMAKE_ARGS       -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    CMAKE_ARGS       -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    CMAKE_ARGS       -DCMAKE_AR=${CMAKE_AR}
    CMAKE_ARGS       -DCMAKE_RANLIB=${CMAKE_RANLIB}
    CMAKE_ARGS       -DCMAKE_INSTALL_PREFIX=${GLOG_INSTALL_DIR}
    CMAKE_ARGS       -DCMAKE_INSTALL_LIBDIR=${GLOG_INSTALL_DIR}/lib
    CMAKE_ARGS       -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    CMAKE_ARGS       -DWITH_GFLAGS=ON
    CMAKE_ARGS       -Dgflags_DIR=${GFLAGS_INSTALL_DIR}/lib/cmake/gflags
    CMAKE_ARGS       -DBUILD_TESTING=OFF
    CMAKE_ARGS       -DCMAKE_BUILD_TYPE=Release
    CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${GLOG_INSTALL_DIR}
                     -DCMAKE_INSTALL_LIBDIR:PATH=${GLOG_INSTALL_DIR}/lib
                     -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
                     -DCMAKE_BUILD_TYPE:STRING=Release
)

ADD_LIBRARY(glog STATIC IMPORTED GLOBAL)
SET_PROPERTY(TARGET glog PROPERTY IMPORTED_LOCATION ${GLOG_LIBRARIES})
SET_PROPERTY(TARGET glog PROPERTY INTERFACE_LINK_LIBRARIES gflags)
ADD_DEPENDENCIES(glog extern_glog gflags)
