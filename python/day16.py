from math import prod
with open('input') as f: line = f.read().strip('\n')

bitlist = []
for c in line: bitlist += list(format(int(c,16),'04b'))
operation = {0: sum, 1: prod, 2: min, 3: max, \
             5: lambda x: x[0] > x[1], \
             6: lambda x: x[0] < x[1], \
             7: lambda x: x[0] == x[1] }

def consume(bits, n):
    val = int(''.join(bits[:n]),2)
    bits[:] = bits[n:]
    return val

def packet(bits):
    version_sum = consume(bits, 3)
    typ = consume(bits, 3)
    if typ == 4:
        value = 0
        while True:
            final = consume(bits, 1)
            value *= 16
            value += consume(bits, 4)
            if final == 0: break
    else:
        sub_values = []
        length_type = consume(bits, 1)
        if length_type == 0:
            sub_length = consume(bits, 15)
            old_length = len(bits)
            while len(bits) > old_length - sub_length:
                v,n = packet(bits)
                sub_values.append(n)
                version_sum += v
        else:
            sub_count = consume(bits, 11)
            for _ in range(sub_count):
                v,n = packet(bits)
                sub_values.append(n)
                version_sum += v
        value = operation[typ](sub_values)
    return version_sum, value

part1,part2 = packet(bitlist)
print(part1)
print(part2)
