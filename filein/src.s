# Set UART_BASE for sending characters out
.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000

# Input data of the puzzle
.section .data
startstr: .string "\n-----\nStart.\n-----\n"
endstr: .string "\n-----\nFin.\n-----\n"

# Program main
.section .text
	la a0, startstr
	li a1, UART_BASE
	call puts
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call puts
	li a0, FILE_BUFFER
	call stoi
	la a0, endstr
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop
