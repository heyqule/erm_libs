local Direction = {}

--- defines.direction.north
Direction.north = defines.direction.north
--- defines.direction.east
Direction.east = defines.direction.east
--- defines.direction.west
Direction.west = defines.direction.west
--- defines.direction.south
Direction.south = defines.direction.south
--- defines.direction.northeast
Direction.northeast = defines.direction.northeast
--- defines.direction.northwest
Direction.northwest = defines.direction.northwest
--- defines.direction.southeast
Direction.southeast = defines.direction.southeast
--- defines.direction.southwest
Direction.southwest = defines.direction.southwest

function Direction.opposite(direction)
    return (direction + 8) % 16
end


function Direction.next(direction, eight_way)
    return (direction + (eight_way and 2 or 4)) % 16
end


function Direction.previous(direction, eight_way)
    return (direction + (eight_way and -2 or -4)) % 16
end


function Direction.to_orientation(direction)
    return direction / 16
end

function Direction.to_vector(direction, distance)
    distance = distance or 1
    local x, y = 0, 0
    if direction == Direction.north then
        y = y - distance
    elseif direction == Direction.northeast then
        x, y = x + distance, y - distance
    elseif direction == Direction.east then
        x = x + distance
    elseif direction == Direction.southeast then
        x, y = x + distance, y + distance
    elseif direction == Direction.south then
        y = y + distance
    elseif direction == Direction.southwest then
        x, y = x - distance, y + distance
    elseif direction == Direction.west then
        x = x - distance
    elseif direction == Direction.northwest then
        x, y = x - distance, y - distance
    end
    return { x = x, y = y }
end

return Direction
