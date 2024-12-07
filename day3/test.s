.section .data
test1name: .string ""
test1data: .string ""

# Program main
.section .text
	call start
	addi sp, sp, -16

	addi sp, sp, 16
# Print end
	call end
