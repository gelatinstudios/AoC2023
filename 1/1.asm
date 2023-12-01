format ELF64 executable
input_size dq 0
seen_digit db 0
first_digit dq 0
last_digit  dq 0
sum dq 0
doing_part2 dq 0
entry $
   mov rax, 0
   mov rdi, 0
   mov rsi, input
   mov rdx, input_capacity
   syscall
   mov [input_size], rax
  solve:
   mov [seen_digit], 0
   mov [sum], 0
   mov rcx, 0
  solve_loop:
   cmp rcx, [input_size]
   je end_solve
   xor rax, rax
   mov al, [input+rcx]
   inc rcx
   cmp al, 10
   je at_newline
   cmp [doing_part2], 0
   je cont_part1
   jmp part2
  cont_part1:
   cmp al, '0'
   jl solve_loop
   cmp al, '9'
   jg solve_loop
   sub rax, '0'
  at_digit:
   cmp [seen_digit], 0
   jne do_last_digit
   mov [seen_digit], 1
   mov [first_digit], rax
   mov [last_digit], rax
   jmp solve_loop
  do_last_digit:
   mov [last_digit], rax
   jmp solve_loop
  at_newline:
   mov [seen_digit], 0
   mov rdx, 0
   mov rax, 10
   mul [first_digit]
   add rax, [last_digit]
   add [sum], rax
   mov [first_digit], 0
   mov [last_digit], 0
   jmp solve_loop
  end_solve:
   mov rax, [sum]
   call print_int
   cmp [doing_part2], 0
   jne exit
   mov [doing_part2], 1
   jmp solve
  exit:
   mov rax, 60
   mov rdi, 0
   syscall
   ret
part2:
   mov rbx, 0
  part2_loop:
   cmp rbx, 9
   je cont_part1
   mov r8, [strs+rbx*8]
   mov r9, rcx
   dec r9
   inc rbx
  part2_str_loop:
   cmp byte [r8], 0
   je part2_ok
   mov r10b, [input+r9]
   cmp r10b, [r8]
   jne part2_loop
   inc r9
   inc r8
   jmp part2_str_loop
  part2_ok:
   mov rax, rbx
   jmp at_digit
value dq 0
remains dq 0
digit dq 0
divisor dq 0
divisor_init dq 10000000000000000000
ten dq 10
print_int:
   mov [value], rax
   mov [remains], rax
   mov rax, [divisor_init]
   mov [divisor], rax
 print_int_loop:
   cmp rax, 0
   je end_print_int
   mov rax, [remains]
   mov rdx, 0
   div [divisor]
   mov [digit], rax
   mov rdx, 0
   mul [divisor]
   sub [remains], rax
   cmp [digit], 0
   jne do_print
   mov rax, [value]
   cmp rax, [remains]
   jne do_print
   cmp [divisor], 1
   jne print_int_loop_it
 do_print:
   mov rax, [digit]
   add rax, '0'
   call print_char
 print_int_loop_it:
   mov rdx, 0
   mov rax, [divisor]
   div [ten]
   mov [divisor], rax
   jmp print_int_loop
 end_print_int:
   mov rax, 10
   call print_char
   ret
char db 0
print_char:
   mov [char], al
   mov rax, 1
   mov rdi, 1
   mov rsi, char
   mov rdx, 1
   syscall
   ret
segment readable
a1 db 'one',   0
a2 db 'two',   0
a3 db 'three', 0
a4 db 'four',  0
a5 db 'five',  0
a6 db 'six',   0
a7 db 'seven', 0
a8 db 'eight', 0
a9 db 'nine',  0
strs dq a1,a2,a3,a4,a5,a6,a7,a8,a9
segment readable writeable
input rb 32*1024
input_capacity=$-input
