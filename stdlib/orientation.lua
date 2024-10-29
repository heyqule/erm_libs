--- Functions for working with orientations.
-- @module Area.Orientation
-- @usage local Orientation = require('__stdlib__/stdlib/area/orientation')


local Orientation = {}

local floor = math.floor

--- Returns a 4way or 8way direction from an orientation.
-- @tparam float orientation
-- @tparam[opt=false] boolean eight_way
-- @treturn defines.direction
function Orientation.to_direction(orientation, eight_way)
    local ways = eight_way and 8 or 4
    local mod = eight_way and 2 or 4
    return floor(orientation * ways + 0.5) % ways * mod
end

--- Returns the opposite orientation.
-- @tparam float orientation
-- @treturn float the opposite orientation
function Orientation.opposite(orientation)
    return (orientation + 0.5) % 1
end

--- Add two orientations together.
-- @tparam float orientation1
-- @tparam float orientation2
-- @treturn float the orientations added together
function Orientation.add(orientation1, orientation2)
    return (orientation1 + orientation2) % 1
end

return Orientation
