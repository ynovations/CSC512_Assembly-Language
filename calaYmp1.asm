;Calamiong, Yno Andrei | Santiago, Charl Joseph | CSC512C
;Harshad Number

%include "io64.inc"

section .data
    ;Numeric Variables
    input dq 0
    number dq 0
    sum_result dq 0         
    division_result dq 0    
    remainder_result dq 0   

    ;String Variables
    err db "Error: Invalid input", 0
    nega db "Error: Negative number input", 0
    harshad_msg db "Harshad Number: Yes", 0
    not_harshad_msg db "Harshad Number: No", 0
    cont db "Do you want to continue (Y/N)? ", 0

section .text
global main

main:
    mov rbp, rsp; for correct debugging

start:
    PRINT_STRING "Input Number: "
    GET_STRING input, 256     
    mov eax, 0                      
    mov esi, input

ascii_to_int_loop:
    mov bl, [esi]        
    cmp bl, 0            
    je validate_input
    cmp bl, 10
    je end_read
    cmp bl, 32
    je end_read
    cmp bl, '0'
    jl invalid_input
    cmp bl, '9'
    jg invalid_input

;Conversion from ASCII to DEC
    sub bl, '0'          
    imul eax, eax, 10    
    add eax, ebx         
    xor ebx, ebx         
    inc esi              
    jmp ascii_to_int_loop     

end_read:
    mov byte [esi], 0

validate_input:
    cmp eax, 0         
    jz invalid_input              

    cmp rax, 0          
    jl negative_input
    xor rbx, rbx                
    mov [number], rax
    PRINT_STRING "Digits: "
    
digit_extract:
    xor rdx, rdx                
    mov rcx, 10                 
    div rcx                     
    add rbx, rdx                
    PRINT_DEC 8, rdx
    cmp rax, 0                 
    je calculation
    PRINT_STRING ","
    jne digit_extract            

calculation:
    mov [sum_result], rbx       
    NEWLINE
    PRINT_STRING "Sum of digits: "
    PRINT_DEC 8, sum_result

    mov rax, [number]           
    mov rbx, [sum_result]       
    xor rdx, rdx                
    div rbx                     

    mov [division_result], rax  
    NEWLINE
    PRINT_STRING "Quotient: "
    PRINT_DEC 8, division_result

    mov [remainder_result], rdx 
    NEWLINE
    PRINT_STRING "Remainder: "
    PRINT_DEC 8, remainder_result

    cmp rdx, 0
    je is_harshad
    jmp not_harshad    

negative_input:
    PRINT_STRING nega
    jmp yes_no_loop

invalid_input:
    PRINT_STRING err
    jmp yes_no_loop  
    
not_harshad:
    NEWLINE
    PRINT_STRING not_harshad_msg
    jmp yes_no_loop

is_harshad:
    NEWLINE
    PRINT_STRING harshad_msg
    jmp yes_no_loop
    
yes_no_loop:
    NEWLINE
    PRINT_STRING cont
    GET_STRING input, 256
    NEWLINE

    cmp byte [input], 'Y'
    je start
    cmp byte [input], 'y'
    je start
    cmp byte [input], 'N'
    je end
    cmp byte [input], 'n'
    je end
    jmp invalid_input

end:    
    xor edi, edi            
    ret
