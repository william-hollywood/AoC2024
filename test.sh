#!/bin/bash -ex

ACTION=$1

# Ubuntu 20.04 binaries from the github only had 32 bit
if lsb_release -d | grep 20.04;
then
	RV="riscv32"
else
	RV="riscv64"
fi

echo "---------ASSEMBLING-------"
"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 lib.s -o lib.o
"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 libtest.s -o libtest.o

echo "---------LINKING---------"
RUN_BIN="libtest.bin"
"${RV}"-unknown-elf-gcc -g -T baremetal.ld -march=rv32im -mabi=ilp32 -nostdlib -static -o "${RUN_BIN}" lib.o libtest.o

echo "---------RUNNING---------"
RUNNING_FILE_FILE="./.running"

ARGS=()
if [ "${ACTION}" == "debug" ];
then
	ARGS+=( -s -S )
	echo "${RUN_BIN}" > "${RUNNING_FILE_FILE}"
fi

qemu-system-riscv32 -nographic "${ARGS[@]}" -serial mon:stdio -machine virt -bios "${RUN_BIN}"

if [ "${ACTION}" == "debug" ];
then
	rm "${RUNNING_FILE_FILE}"
fi
echo "Done"
