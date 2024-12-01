.equ UART_BASE, 0x10000000

.section .data
helloworld: .string "Hello World\n"

.section .text
	la a0, helloworld
	li a1, UART_BASE
	call puts

loop: j loop
