## Writing a Web Crawler

### Getting Started
There are two requirements before getting started on this project: a C++11 compiler (likely the case for any computer < 5 years old) and [CMake](https://cmake.org/download/) (3.0 or greater). Follow the instructions on the website to install CMake. Afterwards, when opening a new terminal, typing cmake should prompt you with a usage message.

Due to using linux socket library, **this code will likely not compile on Windows.** Please use a lab machine, or VM in your windows machine. You may also try to get (https://docs.microsoft.com/en-us/windows/wsl/)[Windows Subsystem for Linux] working, but I make not guarentees it will work. The code should work fine on Mac OSX.

After installing these prerequisites, you should be able to compile the code provided in this repositoy. First, you need to clone this to your machine:

```
git clone git@github.com:BradMcDanel/cps376-assignments.git
cd cps376-assignments/01-webcrawler/
```

Now, we need to set up a `build/` directory for CMake:

```
mkdir build
cd build
```

Inside the build directory we can run CMake to generate a Makefile for the project.
```
cmake ..
```

Now, we can run make as usual to generate our executable (`serial` or `threaded` in this case). Afterwards, we can run both executables from inside the build directory.
```
make
./serial -u articles/s/o/u/Sourdough.html -d 1 -o ../data/sourdough.txt
./threaded -u articles/s/o/u/Sourdough.html -d 1 -o ../data/sourdough.txt -t 4
```
Note that neither of these executables actually do very much - that is your job!

### Next Steps
* Click around my [2008 Wikipedia](http://139.162.185.240/) mirror to get a sense of what the content you will be crawling looks like
* Carefully read through the assignment (and ask me questions as they come up!)
* Get the serial version working 100% before starting the threaded version
* After finishing the threaded version, make sure that the output matches the serial version for several pages
