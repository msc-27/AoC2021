with open('input') as f: lines = [x.strip('\n') for x in f]
def tolist(s): return [int(c) if c.isdigit() else c for c in s]
nums = [tolist(s) for s in lines]

punct = ['[',']',',']

def reduce(n):
    again = True
    while again:
        again = False
        depth = 0
        for i in range(len(n)):
            if n[i] == '[':
                depth += 1
                if depth == 5:
                    explode(n,i)
                    again = True
                    break
            elif n[i] == ']':
                depth -= 1
        if not again:
            for i in range(len(n)):
                if n[i] not in punct and n[i] > 9:
                    split(n,i)
                    again = True
                    break

def explode(n,pos):
    left = n[pos+1]
    right = n[pos+3]
    for i in range(pos, -1, -1):
        if n[i] not in punct:
            n[i] += left
            break
    for i in range(pos+4, len(n)):
        if n[i] not in punct:
            n[i] += right
            break
    n[pos:pos+5] = [0]

def split(n,pos):
    n[pos:pos+1] = ['[', n[pos]//2, ',', (n[pos]+1)//2, ']']

def add(a,b):
    n = ['['] + a + [','] + b + [']']
    reduce(n)
    return n

def mag(n):
    def sub_mag(n, pos):
    # Evaluate the magnitude of the pair with opening bracket at position pos
    # Return the magnitude and the position of this pair's closing bracket
        pos += 1
        if n[pos] == '[':
            left,pos = sub_mag(n,pos)
        else:
            left = n[pos]
        pos += 2
        if n[pos] == '[':
            right,pos = sub_mag(n,pos)
        else:
            right = n[pos]
        return 3*left + 2*right, pos+1
    return sub_mag(n, 0)[0]

s = nums[0]
for num in nums[1:]:
    s = add(s,num)
print(mag(s))

print(max(mag(add(a,b)) for a in nums for b in nums if b != a))
