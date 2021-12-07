with open('input') as f:
    c = [int(x) for x in f.read().strip('\n').split(',')]
print(min(sum(abs(x-a) for x in c) for a in range(min(c),max(c)+1)))
print(min(sum(abs(x-a)*(abs(x-a)+1)//2 for x in c) for a in range(min(c),max(c)+1)))
