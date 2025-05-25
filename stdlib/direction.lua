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

Direction.multipliers = {
    [defines.direction.north] = {0, -1},
    [defines.direction.northeast] = {1, -1},
    [defines.direction.east] = {1, 0},
    [defines.direction.southeast] = {1, 1},
    [defines.direction.south] = {0, 1},
    [defines.direction.southwest] = {-1, 1},
    [defines.direction.west] = {-1, 0},
    [defines.direction.northwest] = {-1, -1},
}

Direction.divisions = {
    [defines.direction.north] = {315, 45},
    [defines.direction.northeast] = {0, 90},
    [defines.direction.east] = {45, 135},
    [defines.direction.southeast] = {90, 180},
    [defines.direction.south] = {135, 225},
    [defines.direction.southwest] = {180, 270},
    [defines.direction.west] = {225, 315},
    [defines.direction.northwest] = {270, 360},
}

Direction.debug = {
    [defines.direction.north] = "north",
    [defines.direction.northeast] = "northeast",
    [defines.direction.east] = "east",
    [defines.direction.southeast] = "southeast",
    [defines.direction.south] = "south",
    [defines.direction.southwest] = "southwest",
    [defines.direction.west] = "west",
    [defines.direction.northwest] = "northwest",
}

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

function Direction.which_area(position)
    if position.x <= 0  and position.y <= 0 then
        return defines.direction.northwest
    elseif position.x >= 0  and position.y <= 0 then
        return defines.direction.northeast
    elseif position.x >= 0  and position.y >= 0 then
        return defines.direction.southeast
    else
        return defines.direction.southwest
    end
end

return Direction
