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
	la a0, endstr
	li a1, UART_BASE
	call puts

# Loop forever after main execution
loop: j loop

# gets - load the file from stdin into ram
# a0 file buffer location
# a1 UART_BASE address
gets:
1: 
	lb t0, 0(a1)
	beq zero, t0, 2f
	sb t0, (a0)
	addi a0, a0, 1
	j 1b
2:
	ret

# puts - Output a string to the UART
# a0 string address
# a1 UART_BASE address
puts:
1:
	lb t0, 0(a0)
	beq zero, t0, 2f
	sb t0, (a1)
	addi a0, a0, 1
	j 1b
2:
	ret
