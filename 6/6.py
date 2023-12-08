
import sys

def scan(time, distance, start, delta):
    hold_for = start
    while True:
        d = (time - hold_for) * hold_for
        if d > distance:
            return hold_for
        hold_for += delta

lines = sys.stdin.readlines()

def join_nums(nums): return int(''.join(nums))

time_nums, distance_nums = [line.split(':')[1].split() for line in lines]
part1 = [(int(a), int(b)) for a, b in zip(time_nums, distance_nums)]
part2 = [(join_nums(time_nums), join_nums(distance_nums))]

for part in [part1, part2]:
    result = 1
    for time, distance in part:
        result *=  scan(time, distance, time-1, -1) - scan(time, distance, 1, 1) + 1

    print(result)
