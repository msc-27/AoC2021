with open('input') as f: lines = [x.strip('\n') for x in f]
ssv = [x.split(' ') for x in lines]

x = 0
z = 0
aim = 0

for move in ssv:
    cmd = move[0]
    val = int(move[1])
    if cmd == 'forward':
        x += val
        z += aim * val
    if cmd == 'down':
        aim += val
    if cmd == 'up':
        aim -= val
print(x * aim)
print(x * z)
