from collections import defaultdict
import re
import itertools
with open('input') as f:
    paras = [p.split('\n') for p in f.read().strip('\n').split('\n\n')]
def manhat(p,q): return sum(abs(a-b) for a,b in zip(p,q))

def parse_para(para):
    return {tuple(map(int, re.findall('-?\d+', line))) for line in para[1:]}

resolved = [parse_para(paras[0])] # scanners in scanner-0-relative coords
pending = [parse_para(p) for p in paras[1:]] # scanners in original coords

rtab = [ ((0,1),  (1,1),  (2,1)), \
         ((0,-1), (1,-1), (2,1)),\
         ((0,-1), (1,1),  (2,-1)),\
         ((0,1),  (1,-1), (2,-1)),\
         ((1,1),  (2,1),  (0,1)), \
         ((1,-1), (2,-1), (0,1)), \
         ((1,-1), (2,1),  (0,-1)),\
         ((1,1),  (2,-1), (0,-1)),\
         ((2,1),  (0,1),  (1,1)), \
         ((2,-1), (0,-1), (1,1)), \
         ((2,-1), (0,1),  (1,-1)),\
         ((2,1),  (0,-1), (1,-1)),\
         ((1,-1), (0,-1), (2,-1)),\
         ((1,1),  (0,1),  (2,-1)),\
         ((1,1),  (0,-1), (2,1)), \
         ((1,-1), (0,1),  (2,1)), \
         ((0,-1), (2,-1), (1,-1)),\
         ((0,1),  (2,1),  (1,-1)),\
         ((0,1),  (2,-1), (1,1)), \
         ((0,-1), (2,1),  (1,1)), \
         ((2,-1), (1,-1), (0,-1)),\
         ((2,1),  (1,1),  (0,-1)),\
         ((2,1),  (1,-1), (0,1)), \
         ((2,-1), (1,1),  (0,1)) ] # todo: generate this in a simple way

def add(p,q): return tuple(a+b for a,b in zip(p,q))
def diff(p,q): return tuple(a-b for a,b in zip(p,q))
def rotate(p, rot):
    return tuple(p[rtab[rot][i][0]]*rtab[rot][i][1] for i in range(3))
def normalize(scanner, rot, xlat):
    return {add(rotate(p, rot), xlat) for p in scanner}

# look at each pair of beacons in a candidate scanner under every possible rotation
# and look for a pair in a normalized scanner with the same difference.
# TODO: more efficient would be to look only for a matching manhattan distance
# and then try all the rotations to find an exact matching difference
def matchup(candidate, scanner):
    diffs = get_diffs(scanner)
    for p,q in itertools.combinations(candidate, 2):
        for rot in range(24):
            np, nq = (rotate(x, rot) for x in (p,q))
            for op in diffs[diff(np,nq)]:
                offset = diff(op,np)
                new = normalize(candidate, rot, offset)
                if check_match(scanner, new): return new, offset
def get_diffs(scanner):
    d = defaultdict(list)
    for p,q in itertools.permutations(scanner, 2):
        d[diff(p,q)].append(p)
    return d

def check_match(s1, s2): return (len(s1 & s2) >= 12)

scanners = {(0,0,0)} # set of scanner offsets relative to scanner 0
while pending:
    new_pending = []
    for candidate in pending:
        result = None
        for match_to in resolved:
            result = matchup(candidate, match_to)
            if result:
                normalized, offset = result
                resolved.append(normalized)
                scanners.add(offset)
                break
        if result == None:
            new_pending.append(candidate)
    pending = new_pending

print(len(set.union(*resolved)))
print(max(manhat(p,q) for p,q in itertools.combinations(scanners,2)))
