def transform(stone)
    s = stone.to_s
    case
    when s.length % 2 == 0
        return s[0..(s.length / 2) - 1].to_i, s[s.length / 2..(s.length - 1)].to_i
    when stone == 0
        return 1
    end
    return stone * 2024
end

# old function for blog post later
# def blink(stones)
#     stones.length.times do
#         stone = stones.shift
#         a, b = transform(stone)
#         stones.push(a)
#         if b 
#             stones.push(b)
#         end
#     end
# end

def blink(stones)
    newstones = {}
    stones.clone.each do | stone, n |
        a, b = transform(stone)
        newstones = set_stone(newstones, a, n)
        if b != nil
            newstones = set_stone(newstones, b, n)
        end
    end
    return newstones
end

def set_stone(stones, stone, value)
    if stones.key?(stone)
        stones[stone] = stones[stone] + value
    else
        stones[stone] = value
    end
    return stones
end

stones = {}

File.read('./day/11/input.txt').split(' ').each do | stone |
    set_stone(stones, stone.to_i, 1)
end

25.times do
    stones = blink(stones)
end

part1 = stones.values.inject(0, :+)

50.times do
    stones = blink(stones)
end

part2 = stones.values.inject(0, :+)

puts("part 1: #{part1}")
puts("part 2: #{part2}")