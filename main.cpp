// IterateImage() iterates trough all the pixels in the 3D array 'Matrix', changing them according to processPixel()
// It does not return anything, it changes 'Matrix' directly.
// Uses LONG because it needs to be operable as qword for pointers.

#include <iostream>
using namespace std;
extern "C" void iterateImage(int **matrix, long rows, long columns, long channels);

int main(int argc, char **argv)
{
    int **matrix = new int *[3];
    for (int i = 0; i < 3; i++)
    {
        matrix[i] = new int[3];
    };
    int counter = 0;
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            matrix[i][j] = counter;
            counter++;
        }
    }
    iterateImage(matrix, 3, 3, 1);

    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            cout << matrix[i][j];
            cout << ' ';
        }
        cout << '\n';
    }
    return 0;
}
