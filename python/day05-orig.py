# Original attempt
# Code tidied up and part 1 separated but logic intact
# begin boilerplate code
from collections import defaultdict
import re
with open('input') as f:
    lines = [x.strip('\n') for x in f]
numbers = [list(map(int, re.findall('-?[0-9]+',line))) for line in lines]
# end boilerplate code

p = defaultdict(lambda:0)
for x1,y1,x2,y2 in numbers:
    if x1==x2:
        if y1 < y2:
            for y in range(y1,y2+1): p[(x1,y)] += 1
        else:
            for y in range(y2,y1+1): p[(x1,y)] += 1
    if y1==y2:
        if x1 < x2:
            for x in range(x1,x2+1): p[(x,y1)] += 1
        else:
            for x in range(x2,x1+1): p[(x,y1)] += 1
print(len([x for x in p if p[x] > 1]))

for x1,y1,x2,y2 in numbers:
    if x1 != x2 and y1 != y2:
        l = abs(x2-x1)+1
        dx = 1; dy = 1
        if x2 < x1: dx = -1
        if y2 < y1: dy = -1
        for i in range(l):
            p[(x1+i*dx,y1+i*dy)] += 1
print(len([x for x in p if p[x] > 1]))
