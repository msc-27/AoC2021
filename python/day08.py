with open('input') as f: lines = [x.strip('\n') for x in f]
ssv = [x.split(' ') for x in lines]
part1 = 0
part2 = 0
for line in ssv:
    inp = line[:10]
    outp = line[-4:]
    part1 += sum(1 for x in outp if len(x) in [2,3,4,7])
    str2dig = dict()
    inp.sort(key=lambda x: len(x))
    str2dig[inp[0]] = 1 # two segments lit
    str2dig[inp[1]] = 7 # three segments lit
    str2dig[inp[2]] = 4 # four segments lit
    str2dig[inp[9]] = 8 # seven segments lit
    segs_cf = set(inp[0]) # right hand segments
    segs_bd = set(inp[2]) - set(inp[0]) # top-left and middle segments
    for segs in inp[3:6]: # five segments lit: 2,3,5
        if set(segs) & segs_cf == segs_cf:
            str2dig[segs] = 3 # only 3 has both RH segments lit
        elif set(segs) & segs_bd == segs_bd:
            str2dig[segs] = 5 # only 5 has both these segments lit
        else:
            str2dig[segs] = 2
    for segs in inp[6:9]: # six segments lit: 0,6,9
        if set(segs) & segs_bd != segs_bd:
            str2dig[segs] = 0 # only 0 doesn't have both these lit
        elif set(segs) & segs_cf == segs_cf:
            str2dig[segs] = 9 # only 0 and 9 have both RH segments lit
        else:
            str2dig[segs] = 6
    outval = 0
    for segs in outp:
        for x in str2dig:
            if set(x) == set(segs):
                outval *= 10
                outval += str2dig[x]
    part2 += outval
print(part1)
print(part2)
