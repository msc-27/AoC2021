import itertools
with open('input') as f:
    p1,p2 = map(int, (line.strip().split(' ')[-1] for line in f))

def move(pos, score, roll):
    pos = (pos + roll) % 10
    return pos, score + (pos if pos != 0 else 10)

die = itertools.cycle(range(1,101))
def turn(pos, score):
    r = next(die) + next(die) + next(die)
    return move(pos, score, r)

s1,s2 = 0,0
count = 0
while True:
    p1,s1 = turn(p1,s1)
    count += 3
    if s1 >= 1000:
        print(s2 * count)
        break
    p2,s2 = turn(p2,s2)
    count += 3
    if s2 >= 1000:
        print(s1 * count)
        break
