# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build

# Include any dependencies generated for this target.
include CMakeFiles/rand.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/rand.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/rand.dir/flags.make

CMakeFiles/rand.dir/src/rand.cu.o: CMakeFiles/rand.dir/flags.make
CMakeFiles/rand.dir/src/rand.cu.o: ../src/rand.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CUDA object CMakeFiles/rand.dir/src/rand.cu.o"
	/usr/local/cuda-11.4/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/src/rand.cu -o CMakeFiles/rand.dir/src/rand.cu.o

CMakeFiles/rand.dir/src/rand.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/rand.dir/src/rand.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/rand.dir/src/rand.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/rand.dir/src/rand.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

# Object files for target rand
rand_OBJECTS = \
"CMakeFiles/rand.dir/src/rand.cu.o"

# External object files for target rand
rand_EXTERNAL_OBJECTS =

rand: CMakeFiles/rand.dir/src/rand.cu.o
rand: CMakeFiles/rand.dir/build.make
rand: CMakeFiles/rand.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CUDA executable rand"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/rand.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/rand.dir/build: rand

.PHONY : CMakeFiles/rand.dir/build

CMakeFiles/rand.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/rand.dir/cmake_clean.cmake
.PHONY : CMakeFiles/rand.dir/clean

CMakeFiles/rand.dir/depend:
	cd /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build /cps/home/ibrown/Desktop/cps376/HW/376HW/03-hillclimb/build/CMakeFiles/rand.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/rand.dir/depend

