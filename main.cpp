// IterateImage() iterates trough all the pixels in the 3D array 'Matrix', changing them according to processPixel()
// It does not return anything, it changes 'Matrix' directly.
// Uses LONG because it needs to be operable as qword for pointers.

#include <iostream>
using namespace std;
extern "C" void iterateImage(int **, long, long, long);

int main(int argc, char **argv)
{
    int size = 2;

    int **matrix = new int *[size];
    for (int i = 0; i < size; i++)
    {
        matrix[i] = new int[size];
    };
    int counter = 0;
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            matrix[i][j] = counter;
            counter++;
        }
    }
    cout << "Pointer to matrix: ";
    cout << matrix;
    cout << '\n';

    iterateImage(matrix, size, size, 1);
    cout << '\n';

    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            cout << *(*(matrix + i) + j);
            cout << ' ';
        }
    }
    cout << '\n';
    return 0;
}
