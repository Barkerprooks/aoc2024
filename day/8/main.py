
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
part1_anodes = [['.' for _ in range(w)] for _ in range(h)]
part2_anodes = [['.' for _ in range(w)] for _ in range(h)]

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
                    part1_anodes[py][px] = '#'
            
            if nx >= 0 and ny >=0 and nx < w and ny < h:
                if matrix[ny][nx] != symbol:
                    part1_anodes[ny][nx] = '#'

for symbol, locations in antennae.items():
    # checking neighbors more than once for now but thats okay
    # we could create a dict for pairs already checked and filter on those
    # but i want to get this done
    for (x0, y0) in locations:
        for (x1, y1) in filter(lambda location: location != (x0, y0), locations):
            sx, sy = (x1 - x0, y1 - y0)
            px, py = x0 + sx, y0 + sy
            nx, ny = x0 - sx, y0 - sy

            while True:
                p_bounds = True

                if px >= 0 and py >=0 and px < w and py < h:
                    part2_anodes[py][px] = '#'
                else:
                    p_bounds = False

                if nx >= 0 and ny >=0 and nx < w and ny < h:
                    part2_anodes[ny][nx] = '#'
                elif p_bounds == False:
                    break

                px += sx
                py += sy
                nx -= sx
                ny -= sy

print('part 1:', sum(row.count('#') for row in part1_anodes))
print('part 2:', sum(row.count('#') for row in part2_anodes))