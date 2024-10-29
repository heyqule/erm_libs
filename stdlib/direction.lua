local Direction = {}

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


return Direction
