from itertools import permutations
with open('input') as f: lines = [x.strip('\n') for x in f]
ssv = [x.split(' ') for x in lines]
part1 = 0
part2 = 0
correct = {'abcefg':0, 'cf':1, 'acdeg':2, 'acdfg':3, 'bcdf':4, \
           'abdfg':5, 'abdefg':6, 'acf':7, 'abcdefg':8, 'abcdfg':9 }
def translate(string, perm):
    mapping = {c:d for c,d in zip('abcdefg', perm)}
    return ''.join(sorted(mapping[c] for c in string))
def validate(perm, inp):
    return all(translate(s, perm) in correct for s in inp)

for line in ssv:
    inp = line[:10]
    outp = line[-4:]
    part1 += sum(1 for x in outp if len(x) in [2,3,4,7])
    perm = next(filter(lambda p: validate(p, inp), permutations('abcdefg')))
    outval = 0
    for digit in outp:
        outval *= 10
        outval += correct[translate(digit, perm)]
    part2 += outval
print(part1)
print(part2)
