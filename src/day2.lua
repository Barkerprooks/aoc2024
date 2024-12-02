local function checkLevels(levels)
    local n = #levels
    local up = levels[n] - levels[n - 1] < 0

    while n > 1 do
        local v = levels[n] - levels[n - 1]

        if (v == 0) or ((v > 0 and up) or (v < 0 and not up)) or (math.abs(v) > 3) then
            return false
        end

        n = n - 1
    end

    return true
end

local part1 = 0
local part2 = 0

-- supposedly the file closes automatically at the end of this loop
for line in io.lines('input/day2.txt') do
    local levels = {}

    -- split on a regex of white spaces, just manually build the table
    for token in line:gmatch('[^%s]+') do
        levels[#levels+1] = tonumber(token)
    end

    if checkLevels(levels) then -- only add to the total if it's safe
        part1 = part1 + 1
    end

    -- O(n * (m - 1)) ... yikes
    -- luckily m is usually small
    for i in pairs(levels) do
        -- test a new levels array with the current index removed
        local levels_copy = { table.unpack(levels) }
        table.remove(levels_copy, i)

        if checkLevels(levels_copy) then
            part2 = part2 + 1
            break -- as soon as we find a valid levels table, break
        end
    end
end

print(string.format("part 1: %d", part1))
print(string.format("part 2: %d", part2))