with open('input') as f:
    fish = list(map(int,f.read().strip('\n').split(',')))
count = {x:fish.count(x) for x in range(9)}
def next_gen(count):
    d = {x-1:count[x] for x in count if x > 0}
    d[6] += count[0]
    d[8] = count[0]
    return d
for i in range(80): count = next_gen(count)
print(sum(count.values()))
for i in range(80,256): count = next_gen(count)
print(sum(count.values()))
