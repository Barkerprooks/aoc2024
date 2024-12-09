function search(line) # was waaaay overthinking. sliding window of 4
    count = 0
    for i in length(line):-1:4
        queue = line[i - 3 : i]
        if length(queue) == 4
            if queue == [1, 2, 3, 4] || queue == [4, 3, 2, 1]
                count += 1
            end
        end
    end
    return count
end

# the idea here is to convert chars to ints and
# check the distance between adjacent indicies is 1
xmas = Dict('X' => 1, 'M' => 2, 'A' => 3, 'S' => 4)
foundwords = Dict() # { index: score } words that have been found
wordbuffer = Dict() # { score: index } words we are currently looking at

# multidim vector of scores
scores = map((line) -> map((letter) -> xmas[letter], collect(line)), eachline("./day/4/test.txt"))

# get the width and height of the matrix
# use the first row as a basis for the width
height, width = length(scores), length(scores[1])

# convert scores into a matrix
wordsearch = reshape(collect(Iterators.flatten(scores)), width, height)

part1 = 0

for y in 1:height
    global part1
    part1 += search(wordsearch[:, y])
end

for x in 1:width
    global part1
    part1 += search(wordsearch[x, :])
end

println(part1) # not done yet