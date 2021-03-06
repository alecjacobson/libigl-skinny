cmake_minimum_required(VERSION 2.8.12)
project(pyigl)

# Force a specific python version
# set(PYTHON_LIBRARIES "D:/Python34/libs/python34.lib")
# set(PYTHON_INCLUDE_DIR "D:/Python34/include")

# Force a specific python version
# set(PYTHON_LIBRARIES "/usr/local/Cellar/python3/3.5.0/Frameworks/Python.framework/Versions/3.5/lib/libpython3.5m.dylib")
# set(PYTHON_INCLUDE_DIR "/usr/local/Cellar/python3/3.5.0/Frameworks/Python.framework/Versions/3.5/include/python3.5m")

set(Python_ADDITIONAL_VERSIONS 3.4 3.5 3.6)
find_package(PythonLibs REQUIRED)
find_package(PythonInterp REQUIRED)

string(TOUPPER "${CMAKE_BUILD_TYPE}" U_CMAKE_BUILD_TYPE)
if(UNIX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fPIC")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
  if(NOT ${U_CMAKE_BUILD_TYPE} MATCHES DEBUG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -flto")
  endif()
endif()

## include pybind
set(PYBIND11_DIR ${PROJECT_SOURCE_DIR}/../external/pybind11 CACHE PATH "Path to pybind11")
igl_download_pybind11()
add_subdirectory(${PYBIND11_DIR} pybind11)

## include libigl
option(LIBIGL_USE_STATIC_LIBRARY "Use LibIGL as static library" OFF)
option(LIBIGL_WITH_OPENGL            "Use viewer"         ON)
option(LIBIGL_WITH_OPENGL_GLFW       "Use GLFW"           ON)
option(LIBIGL_WITH_OPENGL_GLFW_IMGUI "Use ImGui"          OFF)
option(LIBIGL_WITH_CGAL              "Use CGAL"           OFF)
option(LIBIGL_WITH_BOOLEAN           "Use Cork boolean"   OFF)
option(LIBIGL_WITH_COMISO            "Use CoMiso"         ON)
option(LIBIGL_WITH_EMBREE            "Use Embree"         ON)
option(LIBIGL_WITH_LIM               "Use LIM"            ON)
option(LIBIGL_WITH_MATLAB            "Use Matlab"         OFF)
option(LIBIGL_WITH_MOSEK             "Use MOSEK"          OFF)
option(LIBIGL_WITH_PNG               "Use PNG"            ON)
option(LIBIGL_WITH_TETGEN            "Use Tetgen"         ON)
option(LIBIGL_WITH_TRIANGLE          "Use Triangle"       ON)
option(LIBIGL_WITH_XML               "Use XML"            ON)
option(LIBIGL_WITH_PYTHON            "Use Python"         ON)
option(LIBIGL_WITH_COPYLEFT          "Use Copyleft"       ON)

## libigl
if(NOT TARGET igl::core)
  list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/../shared/cmake")
  include(libigl)
endif()

## Prepare the python library
pybind11_add_module(pyigl
  python_shared.cpp
  modules/py_vector.cpp
  py_igl.cpp
  py_doc.cpp
)

## Add dependencies
target_include_directories(pyigl PUBLIC igl::core)

## Optional modules
if(LIBIGL_WITH_OPENGL_GLFW)
  target_sources(pyigl PRIVATE "modules/py_igl_opengl_glfw.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_GLFW)
  target_link_libraries(pyigl PUBLIC igl::opengl igl::opengl_glfw)
endif()

if(LIBIGL_WITH_COMISO)
  target_sources(pyigl PRIVATE "modules/copyleft/py_igl_comiso.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_COMISO)
  target_link_libraries(pyigl PUBLIC igl::comiso)
endif()

if(LIBIGL_WITH_TETGEN)
  target_sources(pyigl PRIVATE "modules/copyleft/py_igl_tetgen.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_TETGEN)
  target_link_libraries(pyigl PUBLIC igl::tetgen)
endif()

if(LIBIGL_WITH_EMBREE)
  target_sources(pyigl PRIVATE "modules/py_igl_embree.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_EMBREE)
  target_link_libraries(pyigl PUBLIC igl::embree)
endif()

if(LIBIGL_WITH_TRIANGLE)
  target_sources(pyigl PRIVATE "modules/py_igl_triangle.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_TRIANGLE)
  target_link_libraries(pyigl PUBLIC igl::triangle)
endif()

if(LIBIGL_WITH_CGAL)
  target_sources(pyigl PRIVATE "modules/copyleft/py_igl_cgal.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_CGAL)
  target_link_libraries(pyigl PUBLIC igl::cgal)
endif()

if(LIBIGL_WITH_COPYLEFT)
  target_sources(pyigl PRIVATE "modules/copyleft/py_igl_copyleft.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_COPYLEFT)
endif()

if(LIBIGL_WITH_PNG)
  target_sources(pyigl PRIVATE "modules/py_igl_png.cpp")
  target_compile_definitions(pyigl PUBLIC -DPY_PNG)
  target_link_libraries(pyigl PUBLIC igl::png)
endif()

set_target_properties(pyigl PROPERTIES PREFIX "")
set_target_properties(pyigl PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR})

if(WIN32)
  if(MSVC)
    # Enforce size-based optimization and link time code generation on MSVC (~30% smaller binaries in experiments)
    set_target_properties(pyigl PROPERTIES COMPILE_FLAGS "/Os /GL")
    set_target_properties(pyigl PROPERTIES LINK_FLAGS "/LTCG")
  endif()

  # .PYD file extension on Windows
  set_target_properties(pyigl PROPERTIES SUFFIX ".pyd")

  # Link against the Python shared library
  # message(FATAL_ERROR ${PYTHON_LIBRARY})
  # target_link_libraries(igl ${PYTHON_LIBRARY})
  target_link_libraries(pyigl PRIVATE ${PYTHON_LIBRARIES})

elseif(UNIX)
  # It's quite common to have multiple copies of the same Python version
  # installed on one's system. E.g.: one copy from the OS and another copy
  # that's statically linked into an application like Blender or Maya.
  # If we link our plugin library against the OS Python here and import it
  # into Blender or Maya later on, this will cause segfaults when multiple
  # conflicting Python instances are active at the same time.

  # Windows does not seem to be affected by this issue. The solution for Linux
  # and Mac OS is simple: we just don't link against the Python library. The
  # resulting shared library will have missing symbols, but that's perfectly
  # fine -- they will be resolved at import time.

  # .SO file extension on Linux/Mac OS
  set_target_properties(pyigl PROPERTIES SUFFIX ".so")

  #Enable flag if undefined symbols appear on pyigl module import to get notified about the missing symbols at link time
  option(CHECK_UNDEFINED        "Check for undefined symbols"    OFF)

  # Strip unnecessary sections of the binary on Linux/Mac OS
  if(APPLE)
    set_target_properties(pyigl PROPERTIES MACOSX_RPATH ".")

    if(NOT CHECK_UNDEFINED)
      set_target_properties(pyigl PROPERTIES LINK_FLAGS "-undefined dynamic_lookup -dead_strip")
    endif()

    if(NOT ${U_CMAKE_BUILD_TYPE} MATCHES DEBUG)
      add_custom_command(TARGET pyigl POST_BUILD COMMAND strip -u -r ${PROJECT_SOURCE_DIR}/pyigl.so)
    endif()
  else()

    if(CHECK_UNDEFINED)
      target_link_libraries(pyigl PRIVATE ${PYTHON_LIBRARIES})
      set_target_properties(pyigl PROPERTIES LINK_FLAGS "-Wl,--no-undefined")
    endif()

    if(NOT ${U_CMAKE_BUILD_TYPE} MATCHES DEBUG)
      add_custom_command(TARGET pyigl POST_BUILD COMMAND strip ${PROJECT_SOURCE_DIR}/pyigl.so)
    endif()
  endif()
endif()

