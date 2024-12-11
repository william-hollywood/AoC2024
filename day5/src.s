.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000

.section .data

# Program main
.section .text
	call start
	li a0, FILE_BUFFER
	li a1, UART_BASE
	call gets

	li a0, FILE_BUFFER
	call print
	call end
