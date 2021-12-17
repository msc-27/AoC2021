import re
with open('input') as f: line = f.read().strip('\n')
x1,x2,y1,y2 = map(int, re.findall('-?\d+', line))
# Assume x1 positive and y2 negative for logic to work

def traj(xv,yv):
    x = 0; y = 0
    while x <= x2 and y >= y1:
        x += xv
        y += yv
        if xv > 0: xv -= 1
        yv -= 1
        yield (x,y)

def good(xv,yv):
    return any(x in range(x1,x2+1) and y in range(y1,y2+1) for x,y in traj(xv,yv))

# For part 1, assume some xv exists which brings x to a halt
# in the desired range while y is still nonnegative.
# The first negative y-value for a positive yv is -(yv+1).
# Make this equal to y1 to find the trajectory that just catches
# the bottom of the target area at high speed.

print(max(y for x,y in traj(0,-y1-1)))
print(sum(good(xv,yv) for xv in range(1, x2+1) for yv in range(y1, -y1)))
