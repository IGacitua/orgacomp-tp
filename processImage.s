section .data
    ; Current position in iteration
    ; Used to save rcx value when looping trough matrix
    currentPos db 0

section .bss

section .text
    
    ; Itera por la matriz y llama metodos de processPixel.asm
    global iterateImage
    iterateImage:
        ret