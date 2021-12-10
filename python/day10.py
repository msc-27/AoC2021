with open('input') as f: lines = [x.strip('\n') for x in f]
match = {'(':')', '[':']', '{':'}', '<':'>'}
score1 = {')':3, ']':57, '}':1197, '>':25137 }
score2 = {'(':1, '[':2, '{':3, '<':4 }

part1 = 0
part2 = []
for line in lines:
    stack = []
    for c in line:
        if c in ('(','[','{','<'):
            stack.append(c)
        else:
            s = stack.pop()
            if c != match[s]:
                part1 += score1[c]
                break
    else:
        p2score = 0
        while stack:
            c = stack.pop()
            p2score *= 5
            p2score += score2[c]
        part2.append(p2score)
part2.sort()

print(part1)
print(part2[len(part2)//2])
