extern processPixel

section .data
    ; Current position in iteration
    ; Used to save rcx value when looping trough matrix

    rowCounter dq 0 ; Iteration number for rows loop
    colCounter dq 0 ; Iteration number for columns loop
    position   dq 0 ; To get the current position

section .bss

    rows   resq 1 ; Rows in matrix.    
    cols   resq 1 ; Columns in matrix. 
    chan   resq 1 ; Channels in matriz.

    matrix resq 1 ; Pointer to a rows*cols*chan sized matrix.
    pixel  resq 1 ; Pointer to the pixel we're working with.


section .text
    
    ; Itera por la matriz y llama metodos de processPixel.asm
    global iterateImage
    iterateImage:
        ; Recieve parameters
        mov qword[matrix], rdi
        mov qword[rows],    rsi
        mov qword[cols],    rdx
        mov qword[chan],    rcx

        mov byte[rowCounter], 0
        mov byte[colCounter], 0

        iteratePixels:
            ; Get Position
            mov rax, rowCounter
            imul rax, qword[cols]
            add rax, colCounter
            add rax, qword[matrix] ; Should have matrix + position -> The pixel we want!

            mov qword[pixel], rax

            sub rsp, 8
            mov rdi, qword[pixel] 
            mov rsi, qword[chan]
            ;call processPixel
            add rsp, 8

            add qword[colCounter], 1
            mov rax, qword[cols]
            cmp qword[colCounter], rax
            je  increaseRows
            jmp iteratePixels

            increaseRows:
                mov qword[colCounter], 0
                add qword[rowCounter], 1
                mov rax, qword[rows]
                cmp qword[rowCounter], rax
                je return
                jmp iteratePixels

                return:
                    ret