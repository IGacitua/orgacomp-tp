rm -rf build

mkdir -p build
cd build

cmake ..
cmake --build .
mv Main ../main.exe
cd ..
./main.exe test.jpg

rm main.exe