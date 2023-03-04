rm -R _build 2>/dev/null
mkdir -p _build
cd _build
cmake .. -G Ninja \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_SKIP_RPATH=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DINSTALL_PRIVATE_HEADERS=YES \
	-DENABLE_TESTING=OFF \
	-DUSE_GOLD_LINKER=YES
