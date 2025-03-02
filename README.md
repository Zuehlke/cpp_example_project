# cpp_example_project

Ongoing project of the Zühlke Germany **Modern C++ Topic Group**.

With this project, we want to provide an example and starting point for C++ projects (embedded and otherwise), especially regarding tooling.

The project has initially been forked/copied from [Jason Turner's cpp_starter_project](https://github.com/lefticus/cpp_starter_project) and is customised by Zühlke members and adapted to [Jason Turner's cmake_conan_boilerplate_template](https://github.com/cpp-best-practices/cmake_conan_boilerplate_template).
It also uses CMake structure from [Jason Turner's cmake_template](https://github.com/cpp-best-practices/cmake_template) repository.

## Build Status

![CMake](https://github.com/Zuehlke/cpp_example_project/workflows/CMake/badge.svg)

## Getting Started

### Use the Github template

First, click the green `Use this template` button near the top of this page.
This will take you to Github's ['Generate Repository'](https://github.com/Zuehlke/cpp_example_project/generate) page.
Fill in a repository name and short description, and click 'Create repository from template'.
This will allow you to create a new repository in your Github account,
prepopulated with the contents of this project.
Now you can clone the project locally and get to work!

    $ git clone https://github.com/<user>/<your_new_repo>.git

### Necessary Dependencies

A C++ compiler that supports at least C++17.
See [cppreference.com](https://en.cppreference.com/w/cpp/compiler_support)
to see which features are supported by each compiler.
The following compilers should work:

  * [gcc 10+](https://gcc.gnu.org/)
    <details>
    <summary>Install command</summary>

    - Debian/Ubuntu:

            sudo apt install build-essential

    - Windows:

            choco install mingw -y

    - MacOS:

            brew install gcc
    </details>

  * [clang 12+](https://clang.llvm.org/)
    <details>
    <summary>Install command</summary>

    - Debian/Ubuntu:

            bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

    - Windows:

        Visual Studio 2019 ships with LLVM (see the Visual Studio section). However, to install LLVM separately:

            choco install llvm -y

        llvm-utils for using external LLVM with Visual Studio generator:

            git clone https://github.com/zufuliu/llvm-utils.git
            cd llvm-utils/VS2017
            .\install.bat

    - MacOS:

            brew install llvm
    </details>

  * [Visual Studio 2019 or higher](https://visualstudio.microsoft.com/)
    <details>
    <summary>Install command + Environment setup</summary>

    On Windows, you need to install Visual Studio 2019 because of the SDK and libraries that ship with it.

      Visual Studio IDE - 2019 Community (installs Clang too):

            choco install -y visualstudio2019community --package-parameters "add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --includeOptional --passive --locale en-US"

    Put MSVC compiler, Clang compiler, and vcvarsall.bat on the path:

            choco install vswhere -y
            refreshenv

            # change to x86 for 32bit
            $clpath = vswhere -products * -latest -prerelease -find **/Hostx64/x64/*
            $clangpath = vswhere -products * -latest -prerelease -find **/Llvm/bin/*
            $vcvarsallpath =  vswhere -products * -latest -prerelease -find **/Auxiliary/Build/*

            $path = [System.Environment]::GetEnvironmentVariable("PATH", "User")
            [Environment]::SetEnvironmentVariable("Path", $path + ";$clpath" + ";$clangpath" + ";$vcvarsallpath", "User")
            refreshenv

    </details>

  * [Conan](https://conan.io/)
    <details>
    <summary>Install Command</summary>

    - Via pip - https://docs.conan.io/en/latest/installation.html#install-with-pip-recommended

            pip install --user conan

    - Windows:

            choco install conan -y

    - MacOS:

            brew install conan

    </details>

  * [CMake 3.21+](https://cmake.org/) 
   
    This repository uses [CMakePresets](https://cmake.org/cmake/help/latest/guide/user-interaction/index.html#presets).
    <details>
    <summary>Install Command</summary>

    - Debian/Ubuntu:

            sudo apt-get install cmake

    - Windows:

            choco install cmake -y

    - MacOS:

            brew install cmake

    </details>

### Optional Dependencies
#### C++ Tools
  * [Doxygen](http://doxygen.nl/)
    <details>
    <summary>Install Command</summary>

    - Debian/Ubuntu:

            sudo apt-get install doxygen
            sudo apt-get install graphviz

    - Windows:

            choco install doxygen.install -y
            choco install graphviz -y

    - MacOS:

            brew install doxygen
            brew install graphviz

    </details>


  * [ccache](https://ccache.dev/)
    <details>
    <summary>Install Command</summary>

    - Debian/Ubuntu:

            sudo apt-get install ccache

    - Windows:

            choco install ccache -y

    - MacOS:

            brew install ccache

    </details>


  * [Cppcheck](http://cppcheck.sourceforge.net/)
    <details>
    <summary>Install Command</summary>

    - Debian/Ubuntu:

            sudo apt-get install cppcheck

    - Windows:

            choco install cppcheck -y

    - MacOS:

            brew install cppcheck

    </details>


  * [include-what-you-use](https://include-what-you-use.org/)
    <details>
    <summary>Install Command</summary>

    Follow instructions here:
    https://github.com/include-what-you-use/include-what-you-use#how-to-install
    </details>

## Build Instructions

All defined presets have the following scheme:

| Preset stage  | scheme                    | description                                                              |
|---------------|---------------------------|--------------------------------------------------------------------------|
| build         | **build-**\<PRESET_NAME\> | This stage is used for compiling the project                             |
| configuration | \<PRESET_NAME\>           | This stage is used for configure the project with defined compiler setup |
| test          | **test-**\<PRESET_NAME\>  | This stage is used to run all test registered for ctest                  |

### Configure your build

To configure the project and write makefiles, you could use `cmake` with a bunch of command line options.
The easier option is to run cmake interactively:

#### **Configure via cmake preset**:

Check the preset which can be applied to your build system by typing:

    cmake --list-presets

The output looks like this:

    Available configure presets:

    "unixlike-gcc-10-debug"       - GCC 10 Debug
    "unixlike-gcc-10-release"     - GCC 10 Release
    "unixlike-gcc-11-debug"       - GCC 11 Debug
    "unixlike-gcc-11-release"     - GCC 11 Release
    "unixlike-gcc-12-debug"       - GCC 12 Debug
    "unixlike-gcc-12-release"     - GCC 12 Release
    "unixlike-gcc-13-debug"       - GCC 13 Debug
    "unixlike-gcc-13-release"     - GCC 13 Release
    "unixlike-gcc-14-debug"       - GCC 14 Debug
    "unixlike-gcc-14-release"     - GCC 14 Release
    "unixlike-clang-12-debug"     - Clang 12 Debug
    "unixlike-clang-12-release"   - Clang 12 Release
    "unixlike-clang-13-debug"     - Clang 13 Debug
    "unixlike-clang-13-release"   - Clang 13 Release
    "unixlike-clang-14-debug"     - Clang 14 Debug
    "unixlike-clang-14-release"   - Clang 14 Release
    "unixlike-clang-15-debug"     - Clang 15 Debug
    "unixlike-clang-15-release"   - Clang 15 Release
    "unixlike-clang-16-debug"     - Clang 16 Debug
    "unixlike-clang-16-release"   - Clang 16 Release
    "unixlike-clang-17-debug"     - Clang 17 Debug
    "unixlike-clang-17-release"   - Clang 17 Release
    "unixlike-clang-18-debug"     - Clang 18 Debug
    "unixlike-clang-18-release"   - Clang 18 Release
    "unixlike-clang-19-debug"     - Clang 19 Debug
    "unixlike-clang-19-release"   - Clang 19 Release

Choose a configuration which is suitable and use following command for example.

    cmake --preset unixlike-clang-15-debug

### Build
Once you have selected all the options you would like to use, you can build the
project (all targets):

    cmake --preset <PRESET_NAME>

For example:
    
    cmake --preset build-unixlike-clang-15-debug

### Test
Run all test using preset and ctest:

    cmake --preset <PRESET_NAME>

For example:

    cmake --preset test-unixlike-clang-15-debug


## Possible option

| Option  | Comment | Default |
| ------- | -------- | -------- |
| ENABLE_PCH | Enable Precompiled Headers | OFF |
| _**Static analyzers**_ |
| ENABLE_CPPCHECK | Enable static analysis with cppcheck | OFF |
| ENABLE_CLANG_TIDY | Enable static analysis with clang-tidy | OFF |
| ENABLE_INCLUDE_WHAT_YOU_USE | Enable static analysis with include-what-you-use | OFF |
| _**Tooling**_ |
| ENABLE_CACHE | Enable cache if available | ON |
| ENABLE_DOXYGEN | Enable doxygen doc builds of source | OFF |
| _**Sanitizers**_ |
| ENABLE_SANITIZER_UNDEFINED_BEHAVIOR | Enable undefined behavior sanitizer | OFF |
| ENABLE_SANITIZER_THREAD | Enable thread sanitizer | OFF |
| ENABLE_SANITIZER_MEMORY | Enable memory sanitizer | OFF |
| ENABLE_SANITIZER_ADDRESS | Enable address sanitizer | OFF |
| ENABLE_SANITIZER_LEAK | Enable leak sanitizer | OFF |
| _**Others**_ |
| ENABLE_COVERAGE | Enable coverage reporting for gcc/clang | OFF |
| ENABLE_IPO | Enable Interprocedural Optimization, aka Link Time Optimization (LTO) | OFF |
| WARNINGS_AS_ERRORS | Treat compiler warnings as errors | ON |
| BUILD_SHARED_LIBS | Enable compilation of shared libraries | OFF |
| ENABLE_TESTING | Enable Test Builds | ON |
| ENABLE_FUZZING | Enable Fuzzing Builds | OFF |
| _**Examples**_ |
| CPP_STARTER_USE_SML | Enable compilation of SML sample | OFF |
| CPP_STARTER_USE_BOOST_BEAST | Enable compilation of boost beast sample | OFF |
| CPP_STARTER_USE_CROW | Enable compilation of crow sample | OFF |
| CPP_STARTER_USE_CPPZMQ_PROTO | Enable compilation of protobuf and cppzmq sample | OFF |
| CPP_STARTER_USE_EMBEDDED_TOOLCHAIN | Enable compilation of an example cortex m4 project | OFF |
| CPP_STARTER_USE_QT | Enable compilation of an example QT project | | OFF |
| _**Test frameworks**_ |
| CPP_STARTER_USE_CATCH2 | Enable compilation of an example test project using catch2 | ON |
| CPP_STARTER_USE_GTEST | Enable compilation of an example test project using googletest | ON |


## Troubleshooting

### Update Conan
Many problems that users have can be resolved by updating Conan, so if you are
having any trouble with this project, you should start by doing that.

To update conan:

    $ pip install --user --upgrade conan

You may need to use `pip3` instead of `pip` in this command, depending on your
platform.

### Clear Conan cache
If you continue to have trouble with your Conan dependencies, you can try
clearing your Conan cache:

    $ conan remove -f '*'

The next time you run `cmake`, your Conan dependencies will
be rebuilt.

### Identifying misconfiguration of Conan dependencies

If you have a dependency 'A' that requires a specific version of another
dependency 'B', and your project is trying to use the wrong version of
dependency 'B', Conan will produce warnings about this configuration error
when you run CMake. These warnings can easily get lost between a couple
hundred or a thousand lines of output, depending on the size of your project.

If your project has a Conan configuration error, you can use `conan info` to
find it. `conan info` displays information about the dependency graph of your
project, with colorized output in some terminals.

    $ cd build
    $ conan info .

In my terminal, the first couple lines of `conan info`'s output show all the
project's configuration warnings in a bright yellow font.

For example, the package `spdlog/1.5.0` depends on the package `fmt/6.1.2`.
If you were to modify the file `cmake/Conan.cmake` so that it requires an
earlier version of `fmt`, such as `fmt/6.0.0`, and then run:

    $ conan remove -f '*'       # clear Conan cache
    $ rm -rf build              # clear previous CMake build
    $ mkdir build && cd build
    $ cmake ..                  # rebuild Conan dependencies
    $ conan info .

...the first line of output would be a warning that `spdlog` needs a more recent
version of `fmt`.

## Testing

- See [Catch2 tutorial](https://github.com/catchorg/Catch2/blob/master/docs/tutorial.md)
- See [Googletest tutorial](http://google.github.io/googletest/)

## Fuzz testing

- See [libFuzzer Tutorial](https://github.com/google/fuzzing/blob/master/tutorial/libFuzzerTutorial.md)
