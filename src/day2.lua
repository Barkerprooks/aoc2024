local part1 = 0

-- supposedly the file closes automatically at the end of this loop
for line in io.lines('input/day2.txt') do
    local levels = {}

    -- split on a regex of white spaces, just manually build the table
    for token in line:gmatch('[^%s]+') do
        levels[#levels+1] = tonumber(token)
    end

    local n = #levels -- count down from this number
    local goingUp = levels[n] - levels[n - 1] < 0 -- get the first direction
    -- its okay if they are equal, the while loop below will detect that and
    -- mark it as invalid regardless
    local isSafe = true -- assume it's a safe record

    while n > 1 do -- going until n == 2

        -- sliding window of [n, n - 1]
        local v = levels[n] - levels[n - 1]

        -- the 3 if statements below act as a filter based on the problem statement
        if v == 0 then
            isSafe = false
            break
        end

        if (v > 0 and goingUp) or (v < 0 and not goingUp) then
            isSafe = false
            break
        end
        
        if math.abs(v) > 3 then
            isSafe = false
            break
        end

        n = n - 1 -- decrement by 1
    end

    if isSafe then -- only add to the total if it's safe
        part1 = part1 + 1
    end
end

print(part1)