%include "io64.inc"

section .data
    ;Numeric Variables
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

section .bss
    inputBuffer resb 256      ; Store the number of digits extracted

section .text
global main

main:
    mov rbp, rsp; for correct debugging

start:

    PRINT_STRING "Input Number: "
    GET_STRING inputBuffer, 256     ; Read input into buffer, max 256 characters
    mov eax, 0                      ; EAX will hold the final integer
    mov esi, inputBuffer            ; ESI points to the start of the buffer
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

    sub bl, '0'          
    imul eax, eax, 10    
    add eax, ebx         
    xor ebx, ebx         

    inc esi              
    jmp ascii_to_int_loop     

end_read:
    ; Terminate the string with a null terminator
    mov byte [esi], 0
validate_input:
    ;PRINT_DEC 8, RAX     
    ;NEWLINE
    cmp eax, 0         ; Check if the result is zero
    jz invalid_input              ; If the result is zero, it means the input was empty

    cmp rax, 0          
    jl negative_input
    xor rbx, rbx                
    
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
    jmp end

invalid_input:
    ;NEWLINE
    PRINT_STRING err
    jmp end  
    
not_harshad:
    NEWLINE
    PRINT_STRING not_harshad_msg
    jmp end

is_harshad:
    NEWLINE
    PRINT_STRING harshad_msg
    jmp end
    
end:
    NEWLINE
    PRINT_STRING cont
    GET_STRING inputBuffer, 256   ; Read response for continuing the loop
    NEWLINE

    ; Check if the response is 'Y' or 'y' to continue the loop
    cmp byte [inputBuffer], 'Y'
    je start
    cmp byte [inputBuffer], 'y'
    je start

        ; If the response is neither 'Y' nor 'y', print an error message
    jmp invalid_input
    
    xor edi, edi            
    ret