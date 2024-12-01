# Advent of Code 2024

More self inflicted suffering ahead. Looks like I'm starting off with riscv this year. Who knows how far we'll go.

Used this [handy video](https://www.youtube.com/watch?v=qLzD33xVcRE) as a starting point.

## How to do this:

### Pre-reqs:
- qemu
- riscv-gnu-toolchain
- gdb-multiarch

### Building/running/debugging a project
```bash
# To build and run the project
./run.sh <project-name> <"debug">(optional)

# If run with "debug", in another terminal
./gdb.sh
# NOTE: when in debug, the program will not start without gdb beginning it.
```
