// // IterateImage() iterates trough all the pixels in the 3D array 'Matrix', changing them according to processPixel()
// // It does not return anything, it changes 'Matrix' directly.
// // Uses LONG because it needs to be operable as qword for pointers.

// int main(int argc, char **argv)
// {
//     int size = 2;

//     int **matrix = new int *[size];
//     for (int i = 0; i < size; i++)
//     {
//         matrix[i] = new int[size];
//     };
//     int counter = 0;
//     for (int i = 0; i < size; i++)
//     {
//         for (int j = 0; j < size; j++)
//         {
//             matrix[i][j] = counter;
//             counter++;
//         }
//     }
//     cout << "Pointer to matrix: ";
//     cout << matrix;
//     cout << '\n';

//     iterateImage(matrix, size, size, 1);
//     cout << '\n';

//     for (int i = 0; i < size; i++)
//     {
//         for (int j = 0; j < size; j++)
//         {
//             cout << *(*(matrix + i) + j);
//             cout << ' ';
//         }
//     }
//     cout << '\n';
//     return 0;
// }

#include <iostream>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

extern "C" void iterateImage(int ***, long, long, long);

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Uso: ./main <imagen>\n");
        return -1;
    }

    Mat imagen = imread(argv[1], IMREAD_COLOR);

    if (!imagen.data)
    {
        printf("Error: no se pudo cargar la imagen.\n");
        return -1;
    }

    CV_Assert(imagen.depth() == CV_8U);
    namedWindow("Original", WINDOW_AUTOSIZE);
    imshow("Original", imagen);

    int filas = imagen.rows;
    int columnas = imagen.cols;
    int canales = imagen.channels();
    int*** matriz = new int**[filas];

    for (int i = 0; i < filas; i++) {
        matriz[i] = new int*[columnas];

        for (int j = 0; j < columnas; j++) {
            matriz[i][j] = reinterpret_cast<int*>(imagen.data + (i * imagen.step) + (j * canales));
        }
    }


    iterateImage(matriz, filas, columnas, canales);

    namedWindow("Grayscale", WINDOW_AUTOSIZE);
    imshow("Grayscale", imagen);
    waitKey(0);

    for (int i = 0; i < filas; i++) {
        delete[] matriz[i];
    }

    delete[] matriz;

    return 0;
}
