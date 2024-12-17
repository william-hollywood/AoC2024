.equ STACK_POS, 0x88000000
.equ UART_BASE, 0x10000000

.section .data
startstr: .string "-----\nStart.\n-----\n"
endstr: .string "-----\nFin.\n-----\n"

.section .lib

# This is a template
.global template
template:
	addi sp, sp, -16
	sw ra, 0(sp)
	# Function here
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# start - print out a start message and initialize the stack pointer
.global start
start:
	li sp, STACK_POS
	addi sp, sp, -16
	sw ra, 0(sp)
	la a0, startstr
	call print
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# end - print out an end message
.global end
end:
	addi sp, sp, -16
	sw ra, 0(sp)
	la a0, endstr
	call print
	lw ra, 0(sp)
	addi sp, sp, 16
	# fall through

.global shutdown
shutdown:
	li t0, 0x100000
	li t1, 0x5555
	sw t1, 0(t0)
	j shutdown

# print - print a message to the UART out
# a0 - address of string to print
.global print
print:
	addi sp, sp, -16
	sw ra, 0(sp)
	li a1, UART_BASE
	call puts
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# memcmp - Compare two memory region with length a2
# a0 - mem address 1
# a1 - mem address 2
# a2 - length of memory to compare
# returns
# a0 - number of bytes different
.global memcmp
memcmp:
	addi sp, sp, -16
	sw ra, 0(sp)
	li t0, 0
	mv t1, a2
.L_memcmp_compare_byte:
	beqz t1, .L_memcmp_exit
	lb t2, (a0)
	lb t3, (a1)
	beq t2, t3, .L_memcmp_inc
	addi t0, t0, 1
.L_memcmp_inc:
	addi a0, a0, 1
	addi a1, a1, 1
	addi t1, t1, -1
	j .L_memcmp_compare_byte
.L_memcmp_exit:
	mv a0, t0
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# memcpy - Copy memory region a0 to a1 for a2 bytes
# a0 - mem address 1
# a1 - mem address 2
# a2 - length of memory to copy
.global memcpy
memcpy:
	addi sp, sp, -16
	sw ra, 0(sp)
	mv t0, a2
.L_memcpy_copy_byte:
	beqz t0, .L_memcpy_exit
	lb t1, (a0)
	sb t1, (a1)
	addi a0, a0, 1
	addi a1, a1, 1
	addi t0, t0, -1
	j .L_memcpy_copy_byte
.L_memcpy_exit:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

# gets - load the file from stdin into ram
# a0 - file buffer location
# a1 - READ location
.global gets
gets:
	lb t0, 0(a1)
	sb t0, (a0)
	addi a0, a0, 1
	beqz t0, .L_gets_exit
.L_gets_check_LCR:
	lb t1, 5(a1)
	andi t1, t1, 1
	bnez t1, gets
	j .L_gets_check_LCR
.L_gets_exit:
	li t0, 0
	sb t0, (a0)
	ret

# puts - Output a string to an address
# a0 - string address
# a1 - WRITE location
.global puts
puts:
	lb t0, 0(a0)
	beqz t0, .L_puts_exit
	sb t0, (a1)
	addi a0, a0, 1
	j puts
.L_puts_exit:
	ret

# seek_num - seek the cursor a0 forward to the next number
# a0 - cursor
.global seek_num
seek_num:
	j .L_seek_num_check_cursor
.L_seek_num_inc:
	addi a0, a0, 1
.L_seek_num_check_cursor:
	lb t0, 0(a0)
	li t1, '9'
	bgt t0, t1, .L_seek_num_inc
	li t1, '0'
	blt t0, t1, .L_seek_num_inc
	ret

# stoi - parse a string as an int, read until first non-int character
# a0 - string address
# returns
# a0 - int
# a1 - cursor pos
.global stoi
stoi:
	li t1, 0
.L_stoi_convert_current_char:
	lb t0, 0(a0)
	addi t0, t0, -'0'
	li t3, 9
	bgt t0, t3, .L_stoi_exit
	bltz t0, .L_stoi_exit
	li t3, 10
	mul t1, t1, t3
	add t1, t0, t1
	addi a0, a0, 1
	j .L_stoi_convert_current_char
.L_stoi_exit:
	mv a1, a0
	mv a0, t1
	ret

# itos - turn an integer into a string and store it at the given address
# a0 - integer
# a1 - Store string location
.global itos
itos:
	addi sp, sp, -16
	mv t0, sp
	li t1, 0
	li t6, 0 # is zero flag
	sb t1, (t0)
	bnez a0, .L_itos_check_negative
	li t1, '0' # is zero, so add a zero
	addi t0, t0, 1
	sb t1, (t0)
	j .L_itos_output_str
.L_itos_check_negative: # non zero number, check if negative, set t6 if is
	bgez a0, .L_itos_parse_char # If non-negative jump to 2
	li t6, 1
	neg a0, a0
.L_itos_parse_char:
	li t5, 10
	rem t1, a0, t5
	div a0, a0, t5
	addi t1, t1, '0'
	addi t0, t0, 1
	sb t1, (t0)
	bnez a0, .L_itos_parse_char # If not zero repeat
	beqz t6, .L_itos_output_str # If t6 zero repeat, dont add '-'
	li t1, '-' # is zero, so add a zero
	addi t0, t0, 1
	sb t1, (t0)
.L_itos_output_str: # spit the string made into pointer a1
	blt t0, sp, .L_itos_exit
	lb t1, (t0)
	sb t1, (a1)
	addi a1, a1, 1
	addi t0, t0, -1
	j .L_itos_output_str
.L_itos_exit:
	addi sp, sp, 16
	ret

# sort_list - sort the list at a0 from smallest to largest (in place)
# a0 - list location
# a1 - list len
.global sort_list
sort_list:
	addi sp, sp, -16
	sw ra, 0(sp)

	mv t6, a0
	mv t0, t6
	mv t1, t6
1:
	# t0 = current start
	# t1 = cursor
	# t2 = cursor num
	# t3 = smallest num
	# t4 = smallest addr
	# t5 = tmp
	# t6 = initial start

	# Check if next number after cursor is end of list
	sub t5, t1, t6
	beq t5, a1, 4f # leave if end of list
	lw t3, 0(t0)
	mv t4, t0

	# Find addr of smallest
2:
	# if cursor is smaller than current smallest, swap
	lw t2, 0(t1)
	bgt t2, t3, 3f
	mv t3, t2
	mv t4, t1
3:
	addi t1, t1, 4
	#Check if end of list
	sub t5, t1, t6
	bne t5, a1, 2b # repeat if not end

	lw t5, 0(t0)
	sw t3, 0(t0)
	sw t5, 0(t4)

	# Inc start, restart cursor, repeat
	addi t0, t0, 4
	mv t1, t0
	j 1b
4:
	lw ra, 0(sp)
	addi sp, sp, 16
	ret

