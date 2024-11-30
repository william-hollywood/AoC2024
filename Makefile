TARGET=$(firstword $(MAKECMDGOALS))

prog: $(TARGET)/src.o baremetal.ld
	@echo "---------LINKING---------"
	riscv64-unknown-elf-gcc -T baremetal.ld -march=rv32i -mabi=ilp32 -nostdlib -static -o $(TARGET)/$(TARGET).bin $(TARGET)/src.o

$(TARGET)/src.o: $(TARGET)/src.s
	@echo "---------ASSEMBING-------"
	riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 $(TARGET)/src.s -o $(TARGET)/src.o

run: prog
	@echo "Ctrl-A X for QEMU console"
	@echo "---------RUNNING---------"
	qemu-system-riscv32 -nographic -serial mon:stdio -machine virt -bios $(TARGET)/$(TARGET).bin
	@echo "Done"
