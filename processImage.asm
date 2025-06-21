extern processPixel
extern printf

section .data
    ; Current position in iteration
    ; Used to save rcx value when looping trough matrix

    rowCounter dq 0 ; Iteration number for rows loop
    colCounter dq 0 ; Iteration number for columns loop
    position   dq 0 ; To get the current position

    mensaje db "%08x ", 0
    space db ' ', 0
    newline db "", 10, 0

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
                mov rbx, [matrix]
                add rbx, [colCounter]

                mov rax, [rowCounter]
                imul rax, [cols]
                imul rax, [chan]

                add rbx, rax
                mov [pixel], rbx

            callProcessor:
                mov rdi, [pixel]
                sub rsp, 8
                call processPixel
                add rsp, 8

            add qword[colCounter], 3
            mov rax, qword[cols]
            imul rax, qword[chan]
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