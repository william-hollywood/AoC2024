# Set UART_BASE for sending characters out
.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ STACK_POS, 0x88000000

.section .data
startstr: .string "\n-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"

# Program main
.section .text
	la a0, startstr
	li a1, UART_BASE
	call puts
	li sp, STACK_POS
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call puts
	la a0, endstr
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop
