local Position = { }

local Direction = require('__erm_libs__/stdlib/direction')
local Orientation = require('__erm_libs__/stdlib/orientation')

local floor, abs, atan2, round_to, round = math.floor, math.abs, math.atan2, math.round_to, math.round
local cos, sin, ceil, sqrt, pi, random = math.cos, math.sin, math.ceil, math.sqrt, math.pi, math.random
local deg, acos, max, min, is_number = math.deg, math.acos, math.max, math.min, math.is_number
local directions = defines.direction

Position.distance = util.distance

--- Addition of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position|number ... position or x, y values.
-- @treturn Concepts.Position pos1 with pos2 added
function Position.add(pos1, ...)
    pos1 = pos1
    local poss = unpack(...)
    for _, pos in pairs(poss) do
        pos1.x = pos1.x + pos.x
        pos1.y = pos1.y + pos1.y
    end
    return { x = pos1.x, y = pos1.y }
end

function Position.subtract(pos1, ...)
    pos1 = pos1
    local poss = unpack(...)
    for _, pos in pairs(poss) do
        pos1.x = pos1.x - pos.x
        pos1.y = pos1.y - pos1.y
    end
    return { x = pos1.x, y = pos1.y }
end

--- Multiplication of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position|number ... position or x, y values
-- @treturn Concepts.Position pos1 multiplied by pos2
function Position.multiply(pos1, ...)
    pos1 = pos1
    local poss = unpack(...)
    for _, pos in pairs(poss) do
        pos1.x = pos1.x * pos.x
        pos1.y = pos1.y * pos1.y
    end
    return { x = pos1.x, y = pos1.y }
end

--- Division of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position|number ... position or x, y values
-- @treturn Concepts.Position pos1 divided by pos2
function Position.divide(pos1, ...)
    pos1 = pos1
    local poss = unpack(...)
    for _, pos in pairs(poss) do
        pos1.x = pos1.x / pos.x
        pos1.y = pos1.y / pos1.y
    end
    return { x = pos1.x, y = pos1.y }
end


--- Return the closest position to the first position.
-- @tparam Concepts.Positions pos1 The position to find the closest too
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position
function Position.closest(pos1, positions)
    local x, y = pos1.x, pos1.y
    local closest = math.MAXINT32
    for _, pos in pairs(positions) do
        local distance = Position.distance(pos1, pos)
        if distance < closest then
            x, y = pos.x, pos.y
            closest = distance
        end
    end
    return { x = x, y = y}
end

--- Return the farthest position from the first position.
-- @tparam Concepts.Positions pos1 The position to find the farthest from
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position
function Position.farthest(pos1, positions)
    local x, y = pos1.x, pos1.y
    local closest = 0
    for _, pos in pairs(positions) do
        local distance = Position.distance(pos1, pos)
        if distance > closest then
            x, y = pos.x, pos.y
            closest = distance
        end
    end
    return { x = x, y = y}
end

--- The middle of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn Concepts.Position pos1 the middle of two positions
function Position.between(pos1, pos2)
    return {x = (pos1.x + pos2.x) / 2, y = (pos1.y + pos2.y) / 2}
end

--- The projection point of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn Concepts.Position pos1 projected
function Position.projection(pos1, pos2)
    local s = (pos1.x * pos2.x + pos1.y * pos2.y) / (pos2.x * pos2.x + pos2.y * pos2.y)
    return {x = s * pos2.x, y = s * pos2.y}
end

--- The reflection point or two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn Concepts.Position pos1 reflected
function Position.reflection(pos1, pos2)
    local s = 2 * (pos1.x * pos2.x + pos1.y * pos2.y) / (pos2.x * pos2.x + pos2.y * pos2.y)
    return {x = s * pos2.x - pos1.x,y = s * pos2.y - pos1.y}
end


local function pos_center(pos)
    local x, y
    local ceil_x = ceil(pos.x)
    local ceil_y = ceil(pos.y)
    x = pos.x >= 0 and floor(pos.x) + 0.5 or (ceil_x == pos.x and ceil_x + 0.5 or ceil_x - 0.5)
    y = pos.y >= 0 and floor(pos.y) + 0.5 or (ceil_y == pos.y and ceil_y + 0.5 or ceil_y - 0.5)
    return {x = x,y = y}
end

--- The center position of the tile where the given position resides.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position A new position at the center of the tile
function Position.center(pos)
    return pos_center(pos)
end

--- Rounds a positions points to the closest integer.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position A new position rounded
function Position.round(pos)
    return { x = round(pos.x), y = round(pos.y) }
end

--- Perpendicular position.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position pos
function Position.perpendicular(pos)
    return { x = -pos.y, y = pos.x }
end

--- Swap the x and y coordinates.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position A new position with x and y swapped
function Position.swap(pos)
    return { x = pos.y, y = pos.x }
end

--- Flip the signs of the position.
-- @tparam Concepts.Position pos
-- @return Concepts.Position A new position with flipped signs
function Position.flip(pos)
    return { x = pos.x, y = -pos.y }
end
Position.unary = Position.flip

--- Flip the x sign.
-- @tparam Concepts.Position pos
-- @return Concepts.Position A new position with flipped sign on the x
function Position.flip_x(pos)
    return { x = -pos.x, y = pos.y }
end

--- Flip the y sign.
-- @tparam Concepts.Position pos
-- @return Concepts.Position A new position with flipped sign on the y
function Position.flip_y(pos)
    return { x = pos.x, y = -pos.y }
end

--- Lerp position of pos1 and pos2.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @tparam float alpha 0-1 how close to get to position 2
-- @treturn Concepts.Position the lerped position
function Position.lerp(pos1, pos2, alpha)
    local x = pos1.x + (pos2.x - pos1.x) * alpha
    local y = pos1.y + (pos2.y - pos1.y) * alpha
    return { x = x, y = y }
end

---  Trim the position to a length.
-- @tparam Concepts.Position pos
-- @tparam number max_len
function Position.trim(pos, max_len)
    local s = max_len * max_len / (pos.x * pos.x + pos.y * pos.y)
    s = (s > 1 and 1) or sqrt(s)
    return  { x = pos.x * s, y = pos.y * s }
end



--- Translates a position in the given direction.
-- @tparam Concepts.Position pos the position to translate
-- @tparam defines.direction direction the direction of translation
-- @tparam number distance distance of the translation
-- @treturn Concepts.Position a new translated position
function Position.translate(pos, direction, distance)
    direction = direction or 0
    distance = distance or 1
    return Position.add(pos, Direction.to_vector(direction, distance))
end

--- Return a random offset of a position.
-- @tparam Concepts.Position pos the position to randomize
-- @tparam[opt=0] number minimum the minimum amount to offset
-- @tparam[opt=1] number maximum the maximum amount to offset
-- @tparam[opt=false] boolean random_tile randomize the location on the tile
-- @treturn Concepts.Position a new random offset position
function Position.random(pos, minimum, maximum, random_tile)
    local rand_x = random(minimum or 0, maximum or 1)
    local rand_y = random(minimum or 0, maximum or 1)
    local x = pos.x + (random() >= .5 and -rand_x or rand_x) + (random_tile and random() or 0)
    local y = pos.y + (random() >= .5 and -rand_y or rand_y) + (random_tile and random() or 0)
    return { x = x, y = y }
end

local function get_array(...)
    local array = select(2, ...)
    if array then
        table.insert(array, (...))
    else
        array = (...)
    end
    return array
end

--- Return the average position of the passed positions.
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position a new position
function Position.average(...)
    local positions = get_array(...)
    local avg = new(0, 0)
    for _, pos in ipairs(positions) do Position.add(avg, pos) end
    return Position.divide(avg, #positions)
end

--- Return the minimum position of the passed positions.
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position a new position
function Position.min(...)
    local positions = get_array(...)
    local x, y
    local len = math.MAXINT32
    for _, pos in pairs(positions) do
        local cur_len = Position.len(pos)
        if cur_len < len then
            len = cur_len
            x, y = pos.x, pos.y
        end
    end
    return { x = x, y = y }
end

--- Return the maximum position of the passed positions.
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position a new position
function Position.max(...)
    local positions = get_array(...)
    local x, y
    local len = -math.MAXINT32
    for _, pos in pairs(positions) do
        local cur_len = Position.len(pos)
        if cur_len > len then
            len = cur_len
            x, y = pos.x, pos.y
        end
    end
    return { x = x, y = y }
end

--- Return a position created from the smallest x, y values in the passed positions.
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position a new position
function Position.min_xy(...)
    local positions = get_array(...)
    local x, y = positions[1].x, positions[1].y
    for _, pos in pairs(positions) do
        x = min(x, pos.x)
        y = min(y, pos.y)
    end
    return { x = x, y = y }
end

--- Return a position created from the largest x, y values in the passed positions.
-- @tparam array positions array of Concepts.Position
-- @treturn Concepts.Position a new position
function Position.max_xy(...)
    local positions = get_array(...)
    local x, y = positions[1].x, positions[1].y
    for _, pos in pairs(positions) do
        x = max(x, pos.x)
        y = max(y, pos.y)
    end
    return { x = x, y = y }
end

--- The intersection of 4 positions.
-- @treturn Concepts.Position a new position
function Position.intersection(pos1_start, pos1_end, pos2_start, pos2_end)
    local d = (pos1_start.x - pos1_end.x) * (pos2_start.y - pos2_end.y) - (pos1_start.y - pos1_end.y) *
        (pos2_start.x - pos2_end.x)
    local a = pos1_start.x * pos1_end.y - pos1_start.y * pos1_end.x
    local b = pos2_start.x * pos2_end.y - pos2_start.y * pos2_end.x
    local x = (a * (pos2_start.x - pos2_end.x) - (pos1_start.x - pos1_end.x) * b) / d
    local y = (a * (pos2_start.y - pos2_end.y) - (pos1_start.y - pos1_end.y) * b) / d
    return is_number(x) and is_number(y) and new(x, y) or pos1_start
end

--- Position Mutate Methods
-- @section Mutate Methods

--- Normalizes a position by rounding it to 2 decimal places.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the normalized position mutated
function Position.normalized(pos)
    pos.x, pos.y = round_to(pos.x, 2), round_to(pos.y, 2)
    return pos
end

--- Abs x, y values
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the absolute position mutated
function Position.absed(pos)
    pos.x, pos.y = abs(pos.x), abs(pos.y)
    return pos
end

--- Ceil x, y values in place.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the ceiled position mutated
function Position.ceiled(pos)
    pos.x, pos.y = ceil(pos.x), ceil(pos.y)
    return pos
end

--- Floor x, y values.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the floored position mutated
function Position.floored(pos)
    pos.x, pos.y = floor(pos.x), floor(pos.y)
    return pos
end

--- The center position of the tile where the given position resides.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the centered position mutated
function Position.centered(pos)
    pos.x, pos.y = pos_center(pos)
    return pos
end

--- Rounds a positions points to the closest integer.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the rounded position mutated
function Position.rounded(pos)
    pos.x, pos.y = round(pos.x), round(pos.y)
    return pos
end

--- Swap the x and y coordinates.
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position the swapped position mutated
function Position.swapped(pos)
    pos.x, pos.y = pos.y, pos.x
    return pos
end

--- Flip the signs of the position.
-- @tparam Concepts.Position pos
-- @return Concepts.Position the flipped position mutated
function Position.flipped(pos)
    pos.x, pos.y = -pos.x, -pos.y
    return pos
end

--- Position Conversion Methods
-- @section Position Conversion Methods
-- Test Comment

--- Convert to pixels from position
-- @tparam Concepts.Position pos
-- @treturn Concepts.Position pos
function Position.to_pixels(pos)
    local x = pos.x * 32
    local y = pos.y * 32
    return { x = x, y = y }
end

--- Gets the chunk position of a chunk where the specified position resides.
-- @tparam Concepts.Position pos a position residing somewhere in a chunk
-- @treturn Concepts.ChunkPosition a new chunk position
-- @usage local chunk_x = Position.chunk_position(pos).x
function Position.to_chunk_position(pos)
    local x, y = floor(pos.x / 32), floor(pos.y / 32)
    return { x = x, y = y }
end

--- Area Conversion Methods
-- @section Area Conversion Methods



--- Position Functions
-- @section Functions

--- Gets the squared length of a position
-- @tparam Concepts.Position pos
-- @treturn number
function Position.len_squared(pos)
    return pos.x * pos.x + pos.y * pos.y
end

--- Gets the length of a position
-- @tparam Concepts.Position pos
-- @treturn number
function Position.len(pos)
    return (pos.x * pos.x + pos.y * pos.y) ^ 0.5
end

--- Is this position {0, 0}.
-- @tparam Concepts.Position pos
-- @treturn boolean
function Position.is_position(pos)
    return pos.x and pos.y
end

--- Is a position inside of an area.
-- @tparam Concepts.Position pos The pos to check
-- @tparam Concepts.BoundingBox area The area to check.
-- @treturn boolean Is the position inside of the area.
function Position.inside(pos, area)
    local lt = area.left_top
    local rb = area.right_bottom

    return pos.x >= lt.x and pos.y >= lt.y and pos.x <= rb.x and pos.y <= rb.y
end

--- Return the atan2 of 2 positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn number
function Position.atan2(pos1, pos2)
    return atan2(pos2.x - pos1.x, pos2.y - pos1.y)
end

--- The angle between two positions
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn number
function Position.angle(pos1, pos2)
    local dist = Position.distance(pos1, pos2)
    if dist ~= 0 then
        return deg(acos((pos1.x * pos2.x + pos1.y * pos2.y) / dist))
    else
        return 0
    end
end

--- Return the cross product of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn number
function Position.cross(pos1, pos2)
    return pos1.x * pos2.y - pos1.y * pos2.x
end

-- Return the dot product of two positions.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn number
function Position.dot(pos1, pos2)
    return pos1.x * pos2.x + pos1.y * pos2.y
end

--- Calculates the Euclidean distance squared between two positions, useful when sqrt is not needed.
-- @tparam Concepts.Position pos1
-- @tparam[opt] Concepts.Position pos2
-- @treturn number the square of the euclidean distance
function Position.distance_squared(pos1, pos2)
    local ax_bx = pos1.x - pos2.x
    local ay_by = pos1.y - pos2.y
    return ax_bx * ax_bx + ay_by * ay_by
end

--- Calculates the Euclidean distance between two positions.
-- @tparam Concepts.Position pos1
-- @tparam[opt={x=0, y=0}] Concepts.Position pos2
-- @treturn number the euclidean distance
function Position.distance(pos1, pos2)
    local ax_bx = pos1.x - pos2.x
    local ay_by = pos1.y - pos2.y
    return (ax_bx * ax_bx + ay_by * ay_by) ^ 0.5
end

--- Calculates the manhatten distance between two positions.
-- @tparam Concepts.Position pos1
-- @tparam[opt] Concepts.Position pos2 the second position
-- @treturn number the manhatten distance
-- @see https://en.wikipedia.org/wiki/Taxicab_geometry Taxicab geometry (manhatten distance)
function Position.manhattan_distance(pos1, pos2)
    return abs(pos2.x - pos1.x) + abs(pos2.y - pos1.y)
end

--- Returms the direction to a position using simple delta comparisons.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @treturn defines.direction
function Position.direction_to(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    if dx ~= 0 then
        if dy == 0 then
            return dx > 0 and directions.west or directions.east
        else
            local adx, ady = abs(dx), abs(dy)
            if adx > ady then
                return dx > 0 and directions.north or directions.south
            else
                return dy > 0 and directions.west or directions.east
            end
        end
    else
        return dy > 0 and directions.north or directions.south
    end
end

--- Returns the direction to a position.
-- @tparam Concepts.Position pos1
-- @tparam Concepts.Position pos2
-- @tparam boolean eight_way return the eight way direction
-- @treturn defines.direction
function Position.complex_direction_to(pos1, pos2, eight_way)
    return Orientation.to_direction(Position.orientation_to(pos1, pos2), eight_way)
end

function Position.orientation_to(pos1, pos2)
    -- @TODO 3rdparty 2.0 fix?
    return (1 - (Position.atan2(pos1, pos2) / pi)) / 2
end


return Position
