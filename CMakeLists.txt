cmake_minimum_required(VERSION 3.28)
enable_language(C ASM_NASM)
set ( SOURCES
	processPixel.asm
	processImage.asm
	main.cpp
)
set (LD_NOEXECSTACK_FLAG "-z noexecstack")
set (ASM_NASM_OPTIONS "-x assembler-with-cpp -lm")
set (CMAKE_BUILD_TYPE Debug)
project( Main )
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable( Main ${SOURCES} )
target_link_libraries( Main ${OpenCV_LIBS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -no-pie")
set(CMAKE_ASM_NASM_FLAGS "${CFLAGS} ${ASM_OPTIONS} -f elf64")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${LD_NOEXECSTACK_FLAG} ")


