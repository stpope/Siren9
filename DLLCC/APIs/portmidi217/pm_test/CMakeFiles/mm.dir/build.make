# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

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
CMAKE_COMMAND = /opt/local/bin/cmake

# The command to remove a file.
RM = /opt/local/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Content/Code/Audio/IO/portmidi217

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Content/Code/Audio/IO/portmidi217

# Include any dependencies generated for this target.
include pm_test/CMakeFiles/mm.dir/depend.make

# Include the progress variables for this target.
include pm_test/CMakeFiles/mm.dir/progress.make

# Include the compile flags for this target's objects.
include pm_test/CMakeFiles/mm.dir/flags.make

pm_test/CMakeFiles/mm.dir/mm.c.o: pm_test/CMakeFiles/mm.dir/flags.make
pm_test/CMakeFiles/mm.dir/mm.c.o: pm_test/mm.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Content/Code/Audio/IO/portmidi217/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object pm_test/CMakeFiles/mm.dir/mm.c.o"
	cd /Content/Code/Audio/IO/portmidi217/pm_test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/mm.dir/mm.c.o   -c /Content/Code/Audio/IO/portmidi217/pm_test/mm.c

pm_test/CMakeFiles/mm.dir/mm.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mm.dir/mm.c.i"
	cd /Content/Code/Audio/IO/portmidi217/pm_test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Content/Code/Audio/IO/portmidi217/pm_test/mm.c > CMakeFiles/mm.dir/mm.c.i

pm_test/CMakeFiles/mm.dir/mm.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mm.dir/mm.c.s"
	cd /Content/Code/Audio/IO/portmidi217/pm_test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Content/Code/Audio/IO/portmidi217/pm_test/mm.c -o CMakeFiles/mm.dir/mm.c.s

# Object files for target mm
mm_OBJECTS = \
"CMakeFiles/mm.dir/mm.c.o"

# External object files for target mm
mm_EXTERNAL_OBJECTS =

mm: pm_test/CMakeFiles/mm.dir/mm.c.o
mm: pm_test/CMakeFiles/mm.dir/build.make
mm: libportmidi_s.a
mm: pm_test/CMakeFiles/mm.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Content/Code/Audio/IO/portmidi217/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ../mm"
	cd /Content/Code/Audio/IO/portmidi217/pm_test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/mm.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
pm_test/CMakeFiles/mm.dir/build: mm

.PHONY : pm_test/CMakeFiles/mm.dir/build

pm_test/CMakeFiles/mm.dir/clean:
	cd /Content/Code/Audio/IO/portmidi217/pm_test && $(CMAKE_COMMAND) -P CMakeFiles/mm.dir/cmake_clean.cmake
.PHONY : pm_test/CMakeFiles/mm.dir/clean

pm_test/CMakeFiles/mm.dir/depend:
	cd /Content/Code/Audio/IO/portmidi217 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Content/Code/Audio/IO/portmidi217 /Content/Code/Audio/IO/portmidi217/pm_test /Content/Code/Audio/IO/portmidi217 /Content/Code/Audio/IO/portmidi217/pm_test /Content/Code/Audio/IO/portmidi217/pm_test/CMakeFiles/mm.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : pm_test/CMakeFiles/mm.dir/depend
