import re
with open('input') as f:
    paras = [p.split('\n') for p in f.read().strip('\n').split('\n\n')]
draws = [int(x) for x in paras[0][0].split(',')]
boards = [[[int(x) for x in re.findall('[0-9]+',row)] for row in p] for p in paras[1:]]
drawn = []
scores = []
def eliminate(boards): return [b for b in boards if not completed(b)]
def completed(board):
    for row in board:
        if all(row[x] in drawn for x in range(5)):
            evaluate(board)
            return True
    for col in range(5):
        if all(board[x][col] in drawn for x in range(5)):
            evaluate(board)
            return True
    return False
def evaluate(board):
    nums = [x for row in board for x in row]
    scores.append(sum(x for x in nums if x not in drawn) * drawn[-1])

while boards:
    drawn.append(draws.pop(0))
    boards = eliminate(boards)
print(scores[0])
print(scores[-1])

