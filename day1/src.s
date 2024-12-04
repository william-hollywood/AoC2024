.equ UART_BASE, 0x10000000
.equ FILE_BUFFER, 0x84000000
.equ LIST1, 0x87000000
.equ LIST2, 0x87002000

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

# Loop forever after main execution
loop: j loop

