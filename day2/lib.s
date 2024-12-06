.section .lib

# parse report
# convert str report into numeric array
# read report until newline or null terminator
# a0 - buffer pos
# a1 - output pos

# only inc or dec
# a0 - report array pos
# Returns
# a0 - !0 if the report only increments or decrements

# distance check
# a0 - report array pos
# a1 - min distance
# a2 - max distance
# Returns
# a0 - !0 if the report values are least a1 apart and at most a2 part

# is report safe
# check that
# - numbers only increase or decrease (only inc or dec func)
# - consecutive numbers are at least 1 apart and at most 3 (disance check func)
# a0 - report array pos
# Returns
# a0 - !0 is the report is safe

# count reports
# count how many reports are safe
# a0 - buffer pos
# Returns
# a0 - number of safe reports
