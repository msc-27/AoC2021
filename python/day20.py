from collections import defaultdict
with open('input') as f: lines = [x.strip('\n') for x in f]

algo = lines[0]

Map = defaultdict(lambda:'.')
for y,line in enumerate(lines[2:]):
    for x,c in enumerate(line):
        Map[(x,y)] = c

def calc_new(grid, x, y):
    index = 0
    for yy in range(y-1,y+2):
        for xx in range(x-1,x+2):
            index *= 2
            if grid[(xx,yy)] == '#': index += 1
    return algo[index]

def evolve(grid, step):
    default = '.' if step % 2 else '#'
    ng = defaultdict(lambda:default)
    a = min(grid)
    x1,y1 = a[0]-1, a[1]-1
    b = max(grid)
    x2,y2 = b[0]+1, b[1]+1
    for x in range(x1,x2+1):
        for y in range(y1,y2+1):
            ng[(x,y)] = calc_new(grid, x, y)
    return ng

for step in range(2):
    Map = evolve(Map, step)
print(sum(1 for x in Map if Map[x] == '#'))
for step in range(48):
    Map = evolve(Map, step)
print(sum(1 for x in Map if Map[x] == '#'))
