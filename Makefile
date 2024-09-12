test:
	zig test src/tests.zig 2>&1 | cat

%.exe: %.cpp
	zig build-exe $? -femit-bin=$@ --library c++