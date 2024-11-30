#!/bin/bash -ex

TARGET=$1
ACTION=$2

echo "---------ASSEMBING-------"
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 "${TARGET}/src.s" -o "${TARGET}/src.o"

echo "---------LINKING---------"
riscv64-unknown-elf-gcc -ggdb -T baremetal.ld -march=rv32i -mabi=ilp32 -nostdlib -static -o "${TARGET}/${TARGET}.bin" "${TARGET}/src.o"

echo "---------RUNNING---------"

FILE_CONTENT=""
if [ -f "${TARGET}/input.txt" ];
then
	FILE_CONTENT=$(cat "${TARGET}/input.txt")
fi

ARGS=()
if [ "${ACTION}" == "debug" ];
then
	ARGS+=( -s -S )
fi

printf "%s\0" "${FILE_CONTENT}" | qemu-system-riscv32 -nographic "${ARGS[@]}" -serial mon:stdio -machine virt -bios "${TARGET}/${TARGET}.bin"
echo "Done"
