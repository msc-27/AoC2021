from collections import defaultdict
import neigh
with open('input') as f: lines = [x.strip('\n') for x in f]
Map = defaultdict(lambda:None)
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        Map[(x,y)] = int(c)

done1 = False; done2 = False; step = 0
flashcount = 0
keys = list(Map)
while not (done1 and done2):
    step += 1
    flashlist = []
    for p in keys:
        Map[p] += 1
        if Map[p] == 10: flashlist.append(p)
    while flashlist:
        flashcount += len(flashlist)
        newlist = []
        for p in flashlist:
            for q in neigh.atrange(p,1):
                if Map[q] != None: Map[q] += 1
                if Map[q] == 10: newlist.append(q)
        flashlist = newlist
    for p in keys:
        if Map[p] > 9: Map[p] = 0
    if step == 100: 
        part1 = flashcount
        done1 = True
    if not any(Map.values()) and not done2:
        part2 = step
        done2 = True
print(part1)
print(part2)
