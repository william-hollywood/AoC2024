.equ PUTS_LOC, 0x86000000
.equ UART_BASE, 0x10000000
.equ STACK_POS, 0x88000000

.section .data
test1name: .string ""
test1data: .string ""

# Program main
.section .text
	call start

# Print end
	call end
