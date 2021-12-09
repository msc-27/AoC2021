from collections import defaultdict
import neigh
with open('input') as f: lines = [x.strip('\n') for x in f]
Map = defaultdict(lambda:9)
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        Map[(x,y)] = int(c)
part1 = 0
basins = []
for p in list(Map.keys()):
    if all(Map[q] > Map[p] for q in neigh.atmanhat(p,1)):
        part1 += Map[p]+1
        basin = set()
        fringe = {p}
        while fringe:
            basin |= fringe
            newp = set()
            for q in fringe:
                for r in neigh.atmanhat(q,1):
                    if Map[r] > Map[q] and Map[r] != 9:
                        newp.add(r)
            fringe = newp
        basins.append(len(basin))
basins.sort()
print(part1)
print(basins[-1]*basins[-2]*basins[-3])
