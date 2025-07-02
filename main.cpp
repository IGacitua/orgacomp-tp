#include <iostream>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

extern "C" void iterateImage(uchar *, long, long, long);

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
    int ***matriz = new int **[filas];

    iterateImage(imagen.data, filas, columnas, canales);

    namedWindow("Grayscale", WINDOW_AUTOSIZE);
    imshow("Grayscale", imagen);
    waitKey(0);

    return 0;
}
