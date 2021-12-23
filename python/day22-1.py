from collections import defaultdict
import re
with open('input') as f: lines = [x.strip('\n') for x in f]

grid = defaultdict(int)
for line in lines:
    val = 1 if line[:2] == 'on' else 0
    x1,x2,y1,y2,z1,z2 = map(int, re.findall('-?[0-9]+',line))
    if abs(x1) <= 50:
        for x in range(x1,x2+1):
            for y in range(y1,y2+1):
                for z in range(z1,z2+1):
                    grid[(x,y,z)] = val
print(sum(grid.values()))
