from collections import defaultdict
with open('input') as f:
    paras = [p.split('\n') for p in f.read().strip('\n').split('\n\n')]

dots = set()
for line in paras[0]:
    x,y = line.split(',')
    dots.add((int(x),int(y)))

def fold(axis, size):
    global dots
    new_dots = set()
    for x,y in dots:
        if axis == 'x':
            new_dots.add((x,y) if x < size else (2*size-x, y))
        else:
            new_dots.add((x,y) if y < size else (x, 2*size-y))
    dots = new_dots

def get_parms(line):
    inst = line.split(' ')[2]
    a,n = inst.split('=')
    return a, int(n)

fold(*get_parms(paras[1][0]))
print(len(dots),'\n')

for line in paras[1][1:]:
    fold(*get_parms(line))
            
maxx = max(d[0] for d in dots)
maxy = max(d[1] for d in dots)
grid = [[' ']*(maxx+1) for i in range(maxy+1)]
for x,y in dots: grid[y][x] = '#'
for line in grid: print(''.join(line))
