import astar
with open('input') as f: lines = [x.strip('\n') for x in f]
def manhat(p,q): return sum(abs(a-b) for a,b in zip(p,q))
def between(a,b): return range(a,b+1) if b >= a else range(a,b-1,-1)

def get_initial(part):
    initial_sets = [set(),set(),set(),set()]
    for y,line in enumerate(lines[2:]):
        for x,c in enumerate(line):
            if c in ('A','B','C','D'):
                px = x-1
                py = y+1 + 2*(part==2 and y==1)
                initial_sets[ord(c)-ord('A')].add((px,py))
    if part == 2:
        initial_sets[0] |= {(8,2),(6,3)}
        initial_sets[1] |= {(6,2),(4,3)}
        initial_sets[2] |= {(4,2),(8,3)}
        initial_sets[3] |= {(2,2),(2,3)}
    return tuple(frozenset(s) for s in initial_sets)

energy = [1,10,100,1000]
home_x = [2,4,6,8]

def trans(state, part):
    for i in range(4):
        for p in state[i]:
            for q in legal_moves(state, i, p, part):
                newset = (set(state[i]) - {p}) | {q}
                newstate = list(state)
                newstate[i] = frozenset(newset)
                cost = manhat(p,q) * energy[i]
                yield (tuple(newstate), cost)
def legal_moves(state, i, p, part):
    occupied = set.union(*(set(s) for s in state)) - {p} # all other occupied positions
    foreign = occupied - state[i] # foreign amphipod positions
    maxy = 2 if part == 1 else 4
    x,y = p
    if y == 0: # in hallway
        if any((home_x[i],yy) in foreign for yy in range(1,maxy+1)):
            return [] # home has a foreigner in it: can't go home yet
        for xx in between(x, home_x[i]):
            if (xx,0) in occupied: return [] # path to home blocked
        next_spot = max(yy for yy in range(1,maxy+1) if (home_x[i],yy) not in state[i])
        return [(home_x[i], next_spot)]
    else: # in a room
        if (x,y-1) in occupied: return [] # blocked in by another amphipod
        if x == home_x[i]: # already home; is there a foreigner in the room?
            if all(((p[0],yy) not in foreign for yy in range(1,maxy+1))):
                return [] # no: this amphipod is happy where it is
        moves = [] # to be filled with all reachable and permissible hallway positions
        xx = x - 1
        while xx >= 1 and (xx,0) not in occupied:
            moves.append((xx,0))
            xx -= 2
        if xx == -1 and (0,0) not in occupied: moves.append((0,0))
        xx = x + 1
        while xx <= 9 and (xx,0) not in occupied:
            moves.append((xx,0))
            xx += 2
        if xx == 11 and (10,0) not in occupied: moves.append((10,0))
        return moves

dest1 = tuple(frozenset({(x,1),(x,2)}) for x in home_x)
a = astar.astar(get_initial(1), lambda x:trans(x,1))
print(a.run(dest1)[0])

dest2 = tuple(frozenset({(x,y) for y in range(1,5)}) for x in home_x)
a = astar.astar(get_initial(2), lambda x:trans(x,2))
print(a.run(dest2)[0])
