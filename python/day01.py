with open('input') as f: depths = [int(x) for x in f]
def check_increase(pair): return 1 if pair[1] > pair[0] else 0;
pairs1 = zip(depths, depths[1:])
pairs3 = zip(depths, depths[3:])
print(sum(map(check_increase, pairs1)))
print(sum(map(check_increase, pairs3)))
