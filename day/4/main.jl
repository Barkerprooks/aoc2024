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

# multidim vector of scores
scores = map((line) -> map((letter) -> xmas[letter], collect(line)), eachline("./day/4/input.txt"))

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

rows = (width * height) - 1
nesw, nwse = [Vector{Int8}(undef, 0) for _ in 1:rows], [Vector{Int8}(undef, 0) for _ in 1:rows]

for y in 1:height
    for x in 1:width
        push!(nesw[(y + x) - 1], wordsearch[x, y])
        push!(nwse[(y - x) + height], wordsearch[x, y])
    end
end

for diagonal in nesw
    global part1
    part1 += search(diagonal)
end

for diagonal in nwse
    global part1
    part1 += search(diagonal)
end

println(part1) # not done yet