section .data

section .bss
    ; Pixel
    ; Size of Double -> 8 Bytes
        pixelPointer resq 1
        pixelValue resd 1
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
    ; NO devuelve, convierte el valor dentro del puntero a lo deseado
    global processPixel
    processPixel:
        ; Get parameters
        mov qword[pixelPointer], rdi
        
        ; Get the content of the pixel
        brea:
        mov rsi, qword[pixelPointer] ; Pointer to the pixel
        mov edi, dword[rsi]
        ret
        
        ; Processing!
        add dword[pixelValue], 1
        
        ; Return the content of the pixel
        lea rsi, pixelValue
        mov rdi, qword[pixelPointer]
        mov rcx, 4 ; sizeof(int)
        movsb

        ret

    ; Separa el pixel en R G B
    ; Divide por 255 (ver TODO)
    separatePixel:

    ; Calculo CLinear
    convertToLinear:

    ; Suma los 3 valores para obtener la iluminación
    getIlluminance:

    ; Invierte la iluminación a Yrgb
    invertIlluminance: