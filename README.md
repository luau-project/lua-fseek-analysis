# Overview

Through GitHub Actions, this (*temporary*) repository performs an analysis on the state of `fseek` support on Lua 5.5.0 (beta) announced at [https://groups.google.com/g/lua-l/c/N1MMWqG4Ad0/m/2CIoXFJyAwAJ](https://groups.google.com/g/lua-l/c/N1MMWqG4Ad0/m/2CIoXFJyAwAJ), in the hope that the proposed changes get incorporated on Lua 5.5.0 official release.

Almost one decade ago, the `fseek` problem on Windows was reported at [http://lua-users.org/lists/lua-l/2015-05/msg00315.html](http://lua-users.org/lists/lua-l/2015-05/msg00315.html). Later, Roberto provided an answer to the problem at [http://lua-users.org/lists/lua-l/2015-05/msg00370.html](http://lua-users.org/lists/lua-l/2015-05/msg00370.html), often used by the community as a work around with MinGW / MinGW-w64.

For the analysis, this repository downloads a huge file (Debian 12.11 iso [https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.11.0-amd64-DVD-1.iso](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.11.0-amd64-DVD-1.iso)) and performs simple `fseek` tests ([main.lua](main.lua)) on different C toolchains on Windows:

* MinGW-w64 provided by [MSYS2 (http://msys2.org/)](http://msys2.org/) using GCC 15.1.0. Also includes environments using `clang` 20.1.7 from [llvm-mingw (https://github.com/mstorsjo/llvm-mingw) ](https://github.com/mstorsjo/llvm-mingw)
* MinGW-w64 already installed on GitHub machines (*not sure*, but probably comes from [https://github.com/niXman/mingw-builds-binaries](https://github.com/niXman/mingw-builds-binaries)) using GCC 12.2.0;
* MinGW (32-bit) using GCC 4.8.1 and GCC 6.3.0, considered a defunct project, which is only available at [https://sourceforge.net/projects/mingw/](https://sourceforge.net/projects/mingw/). However, it is still relevant due a high number of weekly downloads;
* MSVC (19.44.35209) from Visual Studio 2022;
* `clang-cl` (19.1.5), which is `clang` MSVC-compatible.

At the moment, three kind of tests are run:

1. **roberto**: this test employs a patch provided by Roberto placed at [roberto-fseek.patch](roberto-fseek.patch);
2. **custom**: the patch provided by myself at [custom-fseek.patch](custom-fseek.patch);
3. **none**: no patch at all for the `fseek` limitation.

> [!TIP]
> 
> Login to GitHub and browse the latest runs of the actions.

## Conclusion

Through CI, it can be seen that:

* All the kind of tests work correctly on MSVC and `clang-cl` (*roberto*, *custom*, *none*);
* Without any `fseek` patches (condition represented by *none*), `fseek` tests fail for MinGW and MinGW-w64;
* With the patch provided by Roberto (condition *roberto*), `fseek` tests pass for MinGW-w64 providers (MSYS2 and GitHub), MSVC and `clang-cl`, but fail for the defunct MinGW (32-bit) from `sourceforge`;
* With the patch provided by myself (condition *custom*), `fseek` tests pass on all mentioned toolchains.

> [!IMPORTANT]
> 
> This is an interesting opportunity to fix `fseek` for relevant MinGW / MinGW-w64 providers on Windows before the final Lua 5.5.0 release.