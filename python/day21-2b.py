# Part 2 'bearoff database' method
from collections import defaultdict
with open('input') as f:
    p1,p2 = map(int, (line.strip().split(' ')[-1] for line in f))

def move(pos, score, roll):
    pos = (pos + roll) % 10
    return pos, score + (pos if pos != 0 else 10)

distrib = [(3,1),(4,3),(5,6),(6,7),(7,6),(8,3),(9,1)]

def calc_finishes(pos, score):
    finished_in = defaultdict(int)
    for roll, n in distrib:
        np, ns = move(pos, score, roll)
        if ns >= 21:
            finished_in[0] += n
        else:
            for moves,total in calc_finishes(np, ns).items():
                finished_in[moves+1] += n * total
    return finished_in

# How many universes end in a win on a certain turn for each player?
# (not counting universes created by the opponent's rolls)
finishes_1 = calc_finishes(p1,0)
finishes_2 = calc_finishes(p2,0)
# How many universes have each player still playing after a certain turn?
ongoing_1 = {-1:1}
for i in range(max(finishes_2)+1):
    ongoing_1[i] = ongoing_1[i-1] * 27 - finishes_1[i]
ongoing_2 = {-1:1}
for i in range(max(finishes_1)):
    ongoing_2[i] = ongoing_2[i-1] * 27 - finishes_2[i]

w1 = sum(finishes_1[n] * ongoing_2[n-1] for n in finishes_1)
w2 = sum(finishes_2[n] * ongoing_1[n] for n in finishes_2)
print(max(w1,w2))
