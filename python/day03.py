with open('input') as f: lines = [x.strip('\n') for x in f]
def mode(lst): return max(lst, key=lambda x: lst.count(x))
g_chars = [mode(x) for x in zip(*lines)]
g = int(''.join(g_chars),2)
e = 2**len(lines[0]) - 1 - g
print(e*g)

def find_one(cond):
    lst = lines; pos = 0
    while len(lst) > 1:
        lst = prune(lst, cond, pos)
        pos += 1
    return int(lst[0],2)
def prune(lst, cond, pos):
    bits = [x[pos] for x in lst]
    m = max(['1','0'], key = lambda x: bits.count(x))
    return [x for x in lst if (x[pos] == m) == cond]
    
oxy = find_one(True)
co2 = find_one(False)
print(oxy * co2)
