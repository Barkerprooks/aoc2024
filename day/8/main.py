
# loads file as a matrix of symbols, returns the matrix, width, height
def load_matrix(filename: str) -> tuple[list[list[str]], int, int]:
    with open(filename) as file:
        matrix = [[symbol for symbol in line.strip()] for line in file.readlines()]
        return matrix, len(matrix[0]), len(matrix)

# creates adj lists
def load_antennae(matrix: list[list[str]]) -> dict[str, list[tuple[int, int]]]:
    antennae = {}
    for y, row in enumerate(matrix):
        for x, symbol in enumerate(row):
            if antennae.get(symbol):
                antennae[symbol].append((x, y))
            elif symbol != '.':
                antennae[symbol] = [(x, y)]
    return antennae

matrix, w, h = load_matrix('./day/8/input.txt')
anodes = [['.' for _ in range(w)] for _ in range(h)]

antennae = load_antennae(matrix)

for symbol, locations in antennae.items():
    # checking neighbors more than once for now but thats okay
    # we could create a dict for pairs already checked and filter on those
    # but i want to get this done
    for (x0, y0) in locations:
        for (x1, y1) in filter(lambda location: location != (x0, y0), locations):
            sx, sy = (x1 - x0, y1 - y0)
            px, py = x0 + sx, y0 + sy
            nx, ny = x0 - sx, y0 - sy

            if px >= 0 and py >=0 and px < w and py < h:
                if matrix[py][px] != symbol:
                    anodes[py][px] = '#'
            
            if nx >= 0 and ny >=0 and nx < w and ny < h:
                if matrix[ny][nx] != symbol:
                    anodes[ny][nx] = '#'


part1 = sum(row.count('#') for row in anodes)

print('part1:', part1)