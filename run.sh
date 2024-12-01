#!/bin/bash -ex

TARGET=$1
ACTION=$2

echo "---------ASSEMBING-------"
riscv64-unknown-elf-as -march=rv32im -mabi=ilp32 "${TARGET}/src.s" -o "${TARGET}/src.o"
riscv64-unknown-elf-as -march=rv32im -mabi=ilp32 lib.s -o lib.o

echo "---------LINKING---------"
RUN_BIN="${TARGET}/${TARGET}.bin"
riscv64-unknown-elf-gcc -g -T baremetal.ld -march=rv32im -mabi=ilp32 -nostdlib -static -o "${RUN_BIN}" lib.o "${TARGET}/src.o"

echo "---------RUNNING---------"

FILE_CONTENT=""
if [ -f "${TARGET}/input.txt" ];
then
	FILE_CONTENT=$(cat "${TARGET}/input.txt")
fi

RUNNING_FILE_FILE="./.running"

ARGS=()
if [ "${ACTION}" == "debug" ];
then
	ARGS+=( -s -S )
	echo "${RUN_BIN}" > "${RUNNING_FILE_FILE}"
fi

printf "%s\0" "${FILE_CONTENT}" | qemu-system-riscv32 -nographic "${ARGS[@]}" -serial mon:stdio -machine virt -bios "${RUN_BIN}"

rm "${RUNNING_FILE_FILE}"
echo "Done"
