%include "io64.inc"

section .data
    num dq 0
    sum dq 0
    temp dq 0
    digit dq 0
    quotient dq 0
    remainder dq 0
    msg db "Enter a positive number: ", 0
    err db "Error: Invalid input", 0
    neg db "Error: Negative number input", 0
    harshad db "Harshad Number: Yes", 0
    not_harshad db "Harshad Number: No", 0
    cont db "Do you want to continue (Y/N)? ", 0
    answer db 0

section .text
global main
main:
start:
    ; Input a number
    PRINT_STRING msg
    GET_DEC 8, num

    ; Check for negative input
    cmp num, 0
    jl negative_input

    ; Calculate the sum of the digits
    mov [sum], 0
    mov rax, [num]
    mov [temp], rax
sum_digits:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add [sum], rdx
    cmp rax, 0
    jne sum_digits

    ; Check if the number is a Harshad number
    xor rdx, rdx
    mov rax, [num]
    div [sum]
    mov [quotient], rax
    mov [remainder], rdx
    cmp rdx, 0
    je is_harshad

not_harshad:
    PRINT_STRING not_harshad
    jmp end

is_harshad:
    PRINT_STRING harshad
    jmp end

negative_input:
    PRINT_STRING neg
    jmp start

invalid_input:
    PRINT_STRING err
    jmp start

end:
    PRINT_STRING cont
    GET_CHAR answer
    cmp byte [answer], 'Y'
    je start

    ; Exit
    mov eax, 0x60
    xor edi, edi
    syscall
