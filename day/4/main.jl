function findword(wordsearch, wordsfound, x, y, w, h, score=0)
    if abs(score) == 10
        println("found word!")
        return 1
    end

    i = x + w * y
    for ny in range(y - 1, y + 1)
        for nx in range(x - 1, x + 1)
            ni = nx + w * ny
            xbounds = nx > 0 && nx <= w
            ybounds = ny > 0 && ny <= h
            isnotfound = get!(wordsfound, ni, 0) == 0
            if ni != i && xbounds && ybounds && isnotfound
                v = wordsearch[ny][nx]
                matchingdirection = (v > 0 && score > 0) || (v < 0 && score < 0) 
                if abs(wordsearch[y][x] - v) == 1 && (score == 0 || matchingdirection)
                    direction = wordsearch[y][x] - v > 0 ? 1 : -1
                    merge!(wordsfound, Dict(ni => v))
                    return findword(wordsearch, wordsfound, nx, ny, w, h, score + direction)
                end
            end
        end
    end

    println("bruh moment")
    return 0
end

# the idea here is to convert chars to ints and
# check the distance between adjacent indicies is 1
xmas = Dict('X' => 1, 'M' => 2, 'A' => 3, 'S' => 4)
wordsearch = Vector{Int8}[] # start with nothing (we can push >:D)
wordsfound = Dict() # (index; score) at that index

part1 = 0

for (i, line) in enumerate(eachline("./day/4/test.txt"))
    push!(wordsearch, Int8[])
    for char in line
        push!(wordsearch[i], xmas[char])
    end
end

# go in chunks
h = length(wordsearch)
w = length(wordsearch[1])
for y in range(1, h)
    for x in range(1, w)
        global part1
        part1 += findword(wordsearch, wordsfound, x, y, w, h)
    end
end

println(part1)