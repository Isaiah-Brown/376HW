# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.24

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.24.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.24.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build

# Include any dependencies generated for this target.
include CMakeFiles/blur.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/blur.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/blur.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/blur.dir/flags.make

CMakeFiles/blur.dir/src/blur.cpp.o: CMakeFiles/blur.dir/flags.make
CMakeFiles/blur.dir/src/blur.cpp.o: /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/src/blur.cpp
CMakeFiles/blur.dir/src/blur.cpp.o: CMakeFiles/blur.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/blur.dir/src/blur.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/blur.dir/src/blur.cpp.o -MF CMakeFiles/blur.dir/src/blur.cpp.o.d -o CMakeFiles/blur.dir/src/blur.cpp.o -c /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/src/blur.cpp

CMakeFiles/blur.dir/src/blur.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/blur.dir/src/blur.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/src/blur.cpp > CMakeFiles/blur.dir/src/blur.cpp.i

CMakeFiles/blur.dir/src/blur.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/blur.dir/src/blur.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/src/blur.cpp -o CMakeFiles/blur.dir/src/blur.cpp.s

# Object files for target blur
blur_OBJECTS = \
"CMakeFiles/blur.dir/src/blur.cpp.o"

# External object files for target blur
blur_EXTERNAL_OBJECTS =

blur: CMakeFiles/blur.dir/src/blur.cpp.o
blur: CMakeFiles/blur.dir/build.make
blur: /usr/local/lib/libomp.dylib
blur: CMakeFiles/blur.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable blur"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/blur.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/blur.dir/build: blur
.PHONY : CMakeFiles/blur.dir/build

CMakeFiles/blur.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/blur.dir/cmake_clean.cmake
.PHONY : CMakeFiles/blur.dir/clean

CMakeFiles/blur.dir/depend:
	cd /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build /Users/isaiahbrown/Desktop/CPS376/code/HW/376HW/02-image-processing/build/CMakeFiles/blur.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/blur.dir/depend
