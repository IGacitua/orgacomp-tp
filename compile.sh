# Hay q cambiarlo a un MAKEFILE cuando usemos opencv

nasm processImage.s -f elf64
nasm processPixel.s -f elf64
g++ -c main.cpp
g++ -o main.exe main.o processImage.o processPixel.o -no-pie

rm processImage.o
rm processPixel.o
rm main.o

./main.exe

rm main.exe