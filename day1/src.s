# Set UART_BASE for sending characters out
.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ STACK_POS, 0x88000000

.section .data
helloworld: .string "Hello World\n"

# Program main
.section .text
	li sp, STACK_POS
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets
bp:
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop
