function inbounds(x, y, width, height)
    return x > 0 && x <= width && y > 0 && y <= height
end

function findword(wordsearch, foundwords, i, scores)
    if sort(collect(keys(scores))) == [1, 2, 3, 4] # found a word forward or backward
        for (k, v) in scores
            merge!(foundwords, Dict(v => k))
        end
        return 1
    end
    
    y, x = div(i - 1, width) + 1, ((i - 1) % width) + 1
    for iy in range(y - 1, y + 1)
        for ix in range(x - 1, x + 1)
            if !(ix == x && iy == y) && inbounds(ix, iy, width, height)
                ii = ((ix - 1) + width * (iy - 1)) + 1
                v = wordsearch[i] - wordsearch[ii]
                if abs(v) == 1 && !get(foundwords, ii, 0) == 0
                    newscores = Dict(wordsearch[ii] => ii)
                    merge!(newscores, scores)
                    return findword(wordsearch, foundwords, i, newscores)
                end
            end
        end
    end

    return 0
end

# the idea here is to convert chars to ints and
# check the distance between adjacent indicies is 1
xmas = Dict('X' => 1, 'M' => 2, 'A' => 3, 'S' => 4)
foundwords = Dict() # { index: score }
wordsearch = Int8[]
scores = Dict()

height = 0
width = 0

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

for i in range(1, width * height)
    global part1
    
    part1 += findword(wordsearch, foundwords, i, scores)
end

println(part1)