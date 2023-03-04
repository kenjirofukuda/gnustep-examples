set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE string "clang compiler" FORCE)
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE string "clang++ compiler" FORCE)
set(CMAKE_LINKER "ld.gold")
set(CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=/usr/bin/ld.gold")
