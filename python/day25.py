with open('input') as f: lines = [x.strip('\n') for x in f]
grid = dict()
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        grid[(x,y)] = c
sizex,sizey = (n+1 for n in max(grid))

def east(p): return ((p[0]+1) % sizex, p[1])
def west(p): return ((p[0]-1) % sizex, p[1])
def south(p): return (p[0], (p[1]+1) % sizey)
def north(p): return (p[0], (p[1]-1) % sizey)

step = 0
oldgrid = None
while oldgrid != grid:
    step += 1
    oldgrid = grid.copy()
    tmpgrid = {p : '.' if oldgrid[p] == '>' and oldgrid[east(p)] == '.' \
           else '>' if oldgrid[p] == '.' and oldgrid[west(p)] == '>' \
           else oldgrid[p] for p in oldgrid }
    grid = {p : '.' if tmpgrid[p] == 'v' and tmpgrid[south(p)] == '.' \
           else 'v' if tmpgrid[p] == '.' and tmpgrid[north(p)] == 'v' \
           else tmpgrid[p] for p in tmpgrid }
print(step)
