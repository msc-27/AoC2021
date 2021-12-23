import re
from math import prod
from collections import defaultdict
with open('input') as f: lines = [x.strip('\n') for x in f]

def intersection(box1, box2):
    max0 = tuple(max(a,b) for a,b in zip(box1[0],box2[0]))
    min1 = tuple(min(a,b) for a,b in zip(box1[1],box2[1]))
    if all(a <= b for a,b in zip(max0,min1)):
        return (max0,min1)
    else:
        return None

def volume(box):
    return prod(b-a+1 for a,b in zip(*box))

boxes = defaultdict(int)
for line in lines:
    x1,x2,y1,y2,z1,z2 = map(int, re.findall('-?[0-9]+',line))
    newbox = ((x1,y1,z1),(x2,y2,z2))
    for oldbox, polarity in list(boxes.items()):
        xect = intersection(newbox, oldbox)
        if xect != None: boxes[xect] -= polarity
    if line[:2] == 'on': boxes[newbox] += 1

print(sum(polarity * volume(box) for box,polarity in boxes.items()))
