from collections import defaultdict
import re
with open('input') as f: lines = [x.strip('\n') for x in f]
segments = [list(map(int, re.findall('[0-9]+',line))) for line in lines]
def line_points(p1,p2,allow_diagonal=True):
    x1,y1 = p1; x2,y2 = p2
    if x1==x2:
        a=min(y1,y2); b=max(y1,y2)
        for y in range(a,b+1): yield (x1,y)
    elif y1==y2:
        a=min(x1,x2); b=max(x1,x2)
        for x in range(a,b+1): yield (x,y1)
    elif allow_diagonal:
        dx = 1 if x2>x1 else -1
        dy = 1 if y2>y1 else -1
        for x,y in zip(range(x1,x2+dx,dx),range(y1,y2+dy,dy)): yield (x,y)

visited = defaultdict(int)
for x1,y1,x2,y2 in segments:
        for p in line_points((x1,y1),(x2,y2),False): visited[p] += 1
print(sum(1 for x in visited if visited[x] > 1))

visited = defaultdict(int)
for x1,y1,x2,y2 in segments:
        for p in line_points((x1,y1),(x2,y2)): visited[p] += 1
print(sum(1 for x in visited if visited[x] > 1))

