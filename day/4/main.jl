function to_i(x, y)
    if x == 0
        x = 1
    end
    if y == 0
        y = 1
    end
    return ((x - 1) + width * (y - 1)) + 1 
end

function inbounds(x, y, width, height)
    return x > 0 && x <= width && y > 0 && y <= height 
end

function searchat(wordsearch, foundwords, wordbuffer, x, y, width, height)

    if sort(collect(keys(wordbuffer))) == [1, 2, 3, 4]
        println(values(wordbuffer))
        for (k, v) in wordbuffer
            merge!(foundwords, Dict(v => k))
        end
        empty!(wordbuffer) # reset the word buffer to try again
        return 1
    end

    i = to_i(x, y)
    for ny in range(y - 1, y + 1)
        for nx in range(x - 1, x + 1)
            if inbounds(nx, ny, width, height)
                ni = to_i(nx, ny)
                nv = wordsearch[ni]
                if abs(wordsearch[i] - nv) == 1
                    if get!(foundwords, ni, 0) == 0 && get!(wordbuffer, nv, 0) == 0
                        merge!(wordbuffer, Dict(nv => ni))
                        return searchat(wordsearch, foundwords, wordbuffer, nx, ny, width, height)
                    end
                end
            end
        end
    end

    # failed, we need to empty the wordbuffer
    empty!(wordbuffer)
    return 0
end

# the idea here is to convert chars to ints and
# check the distance between adjacent indicies is 1
xmas = Dict('X' => 1, 'M' => 2, 'A' => 3, 'S' => 4)
foundwords = Dict() # { index: score } words that have been found
wordbuffer = Dict() # { score: index } words we are currently looking at
wordsearch = Int8[] # matrix of letters

width, height = 0, 0

part1 = 0

for line in eachline("./day/4/test.txt")
    global width, height
    
    if width == 0 # use the first line for the width
        width = length(line)
    end

    for char in line
        push!(wordsearch, xmas[char])
    end

    height += 1
end

for y in range(1, height)
    for x in range(1, width)
        global part1
        part1 += searchat(wordsearch, foundwords, wordbuffer, x, y, width, height)
    end
end
println(part1)