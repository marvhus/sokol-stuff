# JMP
Jai Music Player

## Disclaimer
This is a work in progress tool, and I'm not sure if it'll ever be finnished.  
If you encounter anny issues please check the existing issues in the GitHub repository, and if it isn't there add it, and I'll take a look at it.  

# Latest Jai version it has been tested with
```console
$ jai -version
Version: beta 0.1.074b, built on 26 August 2023.
```

# Clone with submodules
```console
$ git clone --recurse-submodules -j8 git@github.com:marvhus/jmp.git
```

# Manually get/update submodules
```console
$ git submodule init # If you haven't initialized it yet
$ git submodule update
```

# Build
You can build the project using:
```console
$ jai -import_dir modules first.jai
```

If you are on Linux you can use the `build_and_run.sh` script to build and run the project.
```console
$ ./build_and_run.sh
```
