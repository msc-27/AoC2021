from collections import defaultdict
with open('input') as f: lines = [x.strip('\n') for x in f]
initial = lines[0]
mapping = dict()
for line in lines[2:]:
    x,y = line.split(' -> ')
    mapping[x] = y

element_freqs = defaultdict(int)
pair_freqs = defaultdict(int)

for c in initial:
    element_freqs[c] += 1
for c,d in zip(initial, initial[1:]):
    pair_freqs[c+d] += 1
    
def process():
    global pair_freqs, element_freqs
    npf = defaultdict(int)
    for pair in pair_freqs:
        n = pair_freqs[pair]
        e = mapping[pair]
        element_freqs[e] += n
        npf[pair[0]+e] += n
        npf[e+pair[1]] += n
    pair_freqs = npf

def report():
    print(max(element_freqs.values()) - min(element_freqs.values()))

for i in range(10): process()
report()
for i in range(30): process()
report()
