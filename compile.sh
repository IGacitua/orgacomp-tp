# Hay q cambiarlo a un MAKEFILE cuando usemos opencv

nasm processImage.s -f elf64
nasm processPixel.s -f elf64
g++ -c debug.cpp
g++ -o debug.exe debug.o processImage.o processPixel.o -no-pie

rm processImage.o
rm processPixel.o
rm debug.o

./debug.exe

rm debug.exe