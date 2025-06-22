extern pow

section .data

    ;Valor con el cual se compara contra en Clinear
    CsrgbComparador dq 0.04045

    ;Mismo para Ylinear
    YsrgbComparador dq 0.0031308

    ;Constantes de suma, resta, division, multiplicacion y potencia
    const_12_920 dq 12.92
    const_01_055 dq 1.055
    const_00_055 dq 0.055 
    const_02_400 dq 2.4
    const_255 dq 255.00

    ;valor ayuda para potencia inversa
    const_one dq 1.00

    ;Constantes de multiplicacion para cada canal
    const_R:      dq 0.2126
    const_G:      dq 0.7152
    const_B:      dq 0.0722


section .bss
    ; Pixel
    ; Size of Double -> 8 Bytes
        pixelPointer resq 1
        pixelValue resd 1                        ; no se usa
    ; Original
        originalBlueValue  resq 1
        originalGreenValue resq 1
        originalRedValue   resq 1

    ; Linear

        linearBlueValue  resq 1
        linearGreenValue resq 1
        linearRedValue   resq 1

    ; Combined Pixel

        linearIlluminance  resq 1                 ; no se usa
        inverseIlluminance resq 1                   ;no se usa

section .text

    ; Realiza todos los calculos necesarios al pixel
    ; Recibe la posición en la matriz del pixel
    ; NO devuelve, convierte el valor dentro del puntero a lo deseado

    global processPixel

    processPixel:
        ; Get parameters
        mov qword[pixelPointer], rdi
        
        ;Extraigo cada valor del byte(canal)
        mov rax, [pixelPointer]     

        movzx rbx, byte [rax]       ; B
        mov [originalBlueValue], rbx

        movzx rbx, byte [rax + 1]   ; G
        mov [originalGreenValue], rbx

        movzx rbx, byte [rax + 2]   ; R
        mov [originalRedValue], rbx


        ;Lo convierto a precision doble; ieee754 doble para poder aplicar operaciones
        cvtsi2sd xmm0, [originalBlueValue]; B 
        cvtsi2sd xmm14, [originalGreenValue]; G      xmm1 esta reservado para el exponente en pow de C
        cvtsi2sd xmm15, [originalRedValue]; R


        ;ejecuto funcion obtener c linear en cada valor
        call obtenerCLinear ; xmm0 = B
        movsd [linearBlueValue], xmm0    

        movsd xmm0, xmm14
        call obtenerCLinear; xmm0 = G
        movsd [linearGreenValue], xmm0    

        movsd xmm0, xmm15
        call obtenerCLinear; xmm0 = R
        movsd [linearRedValue], xmm0    


        ;devuelvo los valores a sus respectivos, arbitrarios, xmm-
        movsd xmm0, [linearBlueValue]    
        movsd xmm14, [linearGreenValue]    
        movsd xmm15, [linearRedValue]


        ;llamo funcion para obtener y lineal
        call obtenerYLinear ; valor queda en xmm0


        ;llamo funcion para obtener la luminancia comprimida a partir del y lineal
        call obtenerLuminanciaComprimida


        ;agarro el valor y lo "devuelvo" al rango de 1byte [0,255]
        mulsd xmm0, [const_255]


        ;lo convierto a int y copio dentro de cada canal
        cvtsd2si rax, xmm0          

        mov rbx, [pixelPointer]
        mov byte[rbx], al ; B
        mov byte[rbx + 1], al ; G
        mov byte[rbx + 2], al ; R
        

        ret


    ;obtiene C linear por 'x' canal
    obtenerCLinear:

        ;divido por 255 para tener el valor entre 0 y 1
        divsd xmm0, [const_255]

        ;comparo para ver que operaciones aplicar
        ucomisd xmm0, [CsrgbComparador]

        jae cLinearMayor
        jb  cLinearMenor

        ret

    ;Si es mayor a CsrgbComparador se le aplican estas operaciones
    cLinearMayor:
        addsd xmm0, [const_00_055]
        divsd xmm0, [const_01_055]

        ;Paso a xmm1 el valor de la potencia
        movsd xmm1, [const_02_400]

        sub rsp, 8
        call pow
        add rsp, 8

        ret


    ;Caso opuesto a mayor
    cLinearMenor:
        divsd xmm0, [const_12_920]

        ret

    
    obtenerYLinear:
        mulsd xmm0, [const_B]
        mulsd xmm14, [const_G]
        mulsd xmm15, [const_R]

        addsd xmm0, xmm14
        addsd xmm0, xmm15

        ret

    obtenerLuminanciaComprimida:
        ucomisd xmm0, [YsrgbComparador]

        jae yLinealMayor
        jb  yLinealMenor

        ret

    ;misma funcion pero inversa que su contraparte cLinearMayor
    yLinealMayor:

        ;Paso a xmm1 el valor de la potencia nueva
        movsd xmm1, [const_one]
        divsd xmm1, [const_02_400]

        sub rsp, 8
        call pow
        add rsp, 8

        mulsd xmm0, [const_01_055]
        subsd xmm0, [const_00_055]

        ret
    
    ;mismo que arriba
    yLinealMenor:
        mulsd xmm0, [const_12_920]

        ret