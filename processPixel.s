section .data

section .bss
    ; Pixel
    ; Size of Double -> 8 Bytes
        pixelPointer resq 1
    ; Original
        originalBlueValue  resq 1
        originalGreenValue resq 1
        originalRedValue   resq 1

    ; Linear

        linearBlueValue  resq 1
        linearGreenValue resq 1
        linearRedValue   resq 1

    ; Combined Pixel

        linearIlluminance  resq 1
        inverseIlluminance resq 1

section .text

    ; Realiza todos los calculos necesarios al pixel
    ; Recibe la posición en la matriz del pixel
    ; Devuelve Yrgb
    global processPixel
    processPixel:

    ; Separa el pixel en R G B
    ; Divide por 255 (ver TODO)
    separatePixel:

    ; Calculo CLinear
    convertToLinear:

    ; Suma los 3 valores para obtener la iluminación
    getIlluminance:

    ; Invierte la iluminación a Yrgb
    invertIlluminance: