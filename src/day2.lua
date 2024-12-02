local part1 = 0

for line in io.lines('input/day2.txt') do
    local levels = {}

    for token in line:gmatch('[^%s]+') do
        levels[#levels+1] = tonumber(token)
    end

    local n = #levels
    local goingUp = levels[n] - levels[n - 1] < 0
    local isSafe = true

    while n > 1 do

        local v0 = levels[n]
        local v1 = levels[n - 1]

        if v0 == v1 then
            isSafe = false
            break
        end

        if (v0 - v1 > 0 and goingUp) or (v0 - v1 < 0 and not goingUp) then
            isSafe = false
            break
        end
        
        if math.abs(v0 - v1) > 3 then
            isSafe = false
            break
        end

        n = n - 1
    end

    if isSafe then
        for _, level in pairs(levels) do
            print(level)
        end
        print()
        part1 = part1 + 1
    end
end

print(part1)