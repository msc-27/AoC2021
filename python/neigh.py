import itertools
def inrange(point, dist, include_point = False):
    dim = len(point)
    ranges = [range(-dist,dist+1)] * dim
    origin = tuple([0] * dim)
    for delta in itertools.product(*ranges):
        if include_point or delta != origin:
            yield tuple((x+y for x,y in zip(point, delta)))

def atrange(point, dist):
    dim = len(point)
    if dim == 1:
        yield (point[0]-dist,)
        if dist != 0: yield (point[0]+dist,)
    else:
        for p in ((point[0]-dist,) + q for q in inrange(point[1:], dist, True)):
            yield p
        for x in range(-dist+1, dist):
            for p in ((point[0]+x,) + q for q in atrange(point[1:], dist)):
                yield p
        if dist!= 0:
            for p in ((point[0]+dist,) + q for q in inrange(point[1:], dist, True)):
                yield p

def inmanhat(point, dist, include_point = False):
    dim = len(point)
    if dim == 1:
        for x in range(-dist, dist+1):
            if include_point or dist != 0: yield (point[0]+x,)
    else:
        for x in range(-dist, dist+1):
            for p in ((point[0]+x,) + q for q in inmanhat(point[1:], dist - abs(x), True)):
                if include_point or p != point: yield p

def atmanhat(point, dist):
    dim = len(point)
    if dim == 1:
        yield (point[0]-dist,)
        if dist != 0: yield (point[0]+dist,)
    else:
        for x in range(-dist, dist+1):
            for p in ((point[0]+x,) + q for q in atmanhat(point[1:], dist - abs(x))):
                yield p
