from collections import defaultdict
import neigh
import astar
with open('input') as f: lines = [x.strip('\n') for x in f]

Map = dict()
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        Map[(x,y)] = int(c)

maxx, maxy = max(Map)
dest1 = (maxx, maxy)
dest2 = (5*(maxx+1)-1, 5*(maxy+1)-1)

def trans1(p):
    for q in neigh.atmanhat(p,1):
        if q in Map: yield (q, Map[q])
def trans2(p):
    for q in neigh.atmanhat(p,1):
        x,y = q
        if x >= 0 and y >= 0:
            mx,my = x%(maxx+1), y%(maxy+1)
            risk = Map[(mx,my)] + (x // (maxx+1)) + (y // (maxy+1))
            while risk > 9: risk -= 9
            yield (q, risk)

a = astar.astar((0,0),trans1)
print(a.run(dest1)[0])
a = astar.astar((0,0),trans2)
print(a.run(dest2)[0])
