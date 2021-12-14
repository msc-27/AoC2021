from collections import defaultdict
with open('input') as f: lines = [x.strip('\n') for x in f]
pairs = [x.split('-') for x in lines]
succ = defaultdict(set)
for x,y in pairs:
    if x != 'end' and y != 'start': succ[x].add(y)
    if y != 'end' and x != 'start': succ[y].add(x)

# Functions to validate whether we can add a cave to a given path
def validate(path, cave, revisit_allowed=False):
    if cave.isupper() or cave not in path: return True
    if not revisit_allowed: return False
    for c in path:
        if c.islower() and path.count(c) > 1: return False
    return True
    
def search(path, revisit_allowed=False):
    last = path[-1]
    if last == 'end': return [path]
    solutions = []
    dests = succ[last]
    for cave in dests:
        if validate(path, cave, revisit_allowed):
            solutions += search(path + [cave], revisit_allowed)
    return solutions

print(len(search(['start'])))
print(len(search(['start'], True)))
