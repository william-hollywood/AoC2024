#!/bin/bash -e

# Ubuntu 20.04 binaries from the github only had 32 bit
if lsb_release -d | grep 20.04;
then
	RV="riscv32"
else
	RV="riscv64"
fi

printhelp () {
	printf "script usage: %s [-d] [-t] target\n	-d	debug\n	-t	test\n	-f	input-file\n" "$(basename "$0")" >&2
}

TARGET="$1"
shift

while getopts 'vdtf:' OPTION; do
	case "$OPTION" in
	d)
		DEBUG="y"
		;;
	v)
		set -x
		;;
	t)
		TEST="y"
		;;
	f)
		FILE="$OPTARG"
		;;
	?)
		printhelp
		exit 1
		;;
  esac
done
shift "$((OPTIND -1))"


if [ "$TARGET" = "" ];
then
	printhelp
	exit 1;
fi

if [ "$FILE" != "" ];
then
	FILE_CONTENT=""
	if [ -f "${FILE}" ];
	then
		FILE_CONTENT=$(cat "${FILE}")
	else
		echo "File specified does not exist, exiting"
		exit 1
	fi
fi

echo "---------ASSEMBLING-------"
OBJ_FILES=("lib/lib.o" "lib/libvec.o")

if [ "${TEST}" == "y" ];
then
	OBJ_FILES+=("${TARGET}/test.o" "lib/libtest.o" "lib/testlibvec.o")
	LIBVEC_FILES=("lib/testlibvec.s" "lib/testlibvec_at.s" "lib/testlibvec_push.s" "lib/testlibvec_insert.s" "lib/testlibvec_remove.s" "lib/testlibvec_find.s")
	"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "${TARGET}/test.s" -o "${TARGET}/test.o"
	"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "lib/libtest.s" -o "lib/libtest.o"
	"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "${LIBVEC_FILES[@]}" -o "lib/testlibvec.o"
fi

if [ ! "$TARGET" = "lib" ];
then
	if [ "${TEST}" != "y" ];
	then
		OBJ_FILES+=("${TARGET}/src.o")
		"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "${TARGET}/src.s" -o "${TARGET}/src.o"
	fi
	"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "${TARGET}/lib.s" -o "${TARGET}/lib.o"
	OBJ_FILES+=("${TARGET}/lib.o")
fi

"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "lib/lib.s" -o "lib/lib.o"
"${RV}"-unknown-elf-as -march=rv32im -mabi=ilp32 "lib/libvec.s" -o "lib/libvec.o"

echo "---------LINKING---------"
RUN_BIN="${TARGET}/${TARGET}.bin"
"${RV}"-unknown-elf-gcc -g -T baremetal.ld -march=rv32im -mabi=ilp32 -nostdlib -static -o "${RUN_BIN}" "${OBJ_FILES[@]}"

echo "---------RUNNING---------"

RUNNING_FILE_FILE="./.running"

ARGS=()
if [ "${DEBUG}" == "y" ];
then
	ARGS+=( -s -S )
	echo "${RUN_BIN}" > "${RUNNING_FILE_FILE}"
fi

if [ "${FILE_CONTENT}" != "" ];
then
	printf "%s\0" "${FILE_CONTENT}" | qemu-system-riscv32 -nographic "${ARGS[@]}" -serial mon:stdio -machine virt -bios "${RUN_BIN}"
else
	qemu-system-riscv32 -nographic "${ARGS[@]}" -serial mon:stdio -machine virt -bios "${RUN_BIN}"
fi

if [ "${DEBUG}" == "y" ];
then
	rm "${RUNNING_FILE_FILE}"
fi
