
import sys

def f(nums):
    return nums[0]*10 + nums[-1]

strs = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

part1 = 0
part2 = 0
for line in sys.stdin:
    part1 += f(list(map(int, filter(str.isdigit, line))))

    nums = []
    for i, _ in enumerate(line):
        for s in strs:
            if line[i:].startswith(s):
                nums.append(strs.index(s)+1)
        if str.isdigit(line[i]):
            nums.append(int(line[i]))
            
    part2 += f(nums)

print(part1)
print(part2)
