# Part 2 brute force 'rollout' method
with open('input') as f:
    p1,p2 = map(int, (line.strip().split(' ')[-1] for line in f))

def move(pos, score, roll):
    pos = (pos + roll) % 10
    return pos, score + (pos if pos != 0 else 10)

s1,s2 = 0,0
distrib = [(3,1),(4,3),(5,6),(6,7),(7,6),(8,3),(9,1)]

def play(p1, s1, p2, s2):
    w1 = 0; w2 = 0
    for roll, n in distrib:
        np1, ns1 = move(p1, s1, roll)
        if ns1 >= 21:
            w1 += n
        else:
            a,b = play(p2, s2, np1, ns1)
            w2 += n*a; w1 += n*b
    return w1,w2

w1,w2 = play(p1, s1, p2, s2)
print(max(w1,w2))
