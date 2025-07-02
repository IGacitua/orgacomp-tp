extern processPixel
extern printf

section .data
    ; Current position in iteration
    ; Used to save rcx value when looping trough matrix

    rowCounter dq 0 ; Iteration number for rows loop
    colCounter dq 0 ; Iteration number for columns loop

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

        mov qword[rowCounter], 0
        mov qword[colCounter], 0

        iteratePixels:
            ; Get Position
            getPixel:
                mov rdi, [matrix]       ; Pointer to matrix
                add rdi, [colCounter]   ; Move to desired column

                mov rax, [rowCounter]   ; Desired Row
                imul rax, [cols]        ; Multiplied by the column count
                imul rax, [chan]        ; Multiplied by the channel count
                add rdi, rax            ; Pointer to desired position

            callProcessor:
                sub rsp, 8
                call processPixel       ; Does all changes required to the pixel and replaces it
                add rsp, 8

            mov rax, [chan]
            add qword[colCounter], rax  ; Moves the column counter CHANNELS positions, to get to the next pixel
            mov rax, qword[cols]    
            imul rax, qword[chan]
            cmp qword[colCounter], rax  ; Compares the column position with the last column in row
            je  increaseRows            ; If it's equal, then we need to go to the next row, first column
            jmp iteratePixels           ; Otherwise, loop

            increaseRows:
                mov qword[colCounter], 0 ; Reset column counter
                add qword[rowCounter], 1 ; Increase row counter by one
                mov rax, qword[rows]
                cmp qword[rowCounter], rax  ; If row counter past the last row, then we finished.
                je return
                jmp iteratePixels   ; Otherwise, loop

                return:
                    ret