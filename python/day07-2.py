from math import floor, ceil
with open('input') as f:
    c = [int(x) for x in f.read().strip('\n').split(',')]
c.sort()
median = c[len(c)//2]
mean = sum(c) / len(c)
v = [floor(mean), ceil(mean)]
print(sum(abs(x-median) for x in c))
print(min(sum(abs(x-a)*(abs(x-a)+1)//2 for x in c) for a in v))
