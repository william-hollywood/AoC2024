#!/bin/bash -ex

# Needs `./run.sh <proj> debug` in order to host gdb server

ARGS=(
	-ex "set architecture riscv"
	-ex "target remote localhost:1234"
	-ex "layout asm"
	-ex "set confirm off"
	-ex "file $(cat ./.running)"
	-ex "set confirm on"
)

gdb-multiarch -q --nh "${ARGS[@]}"