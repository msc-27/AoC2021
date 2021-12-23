import heapq
class astar:
    def __init__(self, initial, trans_f, estimate_f = lambda x:0):
        self.initial_state = initial
        self.trans_func = trans_f
        self.estimate_func = estimate_f
    def run(self, target_state):
    # Search for target_state and return cost and path to the target.
    # Run with target_state = None to force full exploration of state space.
    # In this case, if the state space is finite, a list is returned
    # of all states with their associated costs.
        maxcost = 0
        counter = 0
        visited = dict() # state => (cost, ancestor)
        queue = []
        def get_path():
            state = target_state
            path = []
            while state != None:
                path.append(state)
                state = visited[state][1]
            return path
        initial_est = self.estimate_func(self.initial_state)
        heapq.heappush(queue, (initial_est, counter, 0, self.initial_state, None))
        while queue:
            rank, _, cost, state, ancestor = heapq.heappop(queue)
            if state in visited: continue
            visited[state] = (cost,ancestor)
            if state == target_state: return (cost, get_path())
            transitions = self.trans_func(state)
            for next_state, next_cost in transitions:
                new_cost = cost + next_cost
                new_rank = new_cost + self.estimate_func(next_state)
                counter += 1
                heapq.heappush(queue, (new_rank, counter, new_cost, next_state, state))
        if target_state == None: return [(s,visited[s][0]) for s in visited]
