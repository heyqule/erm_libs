--- Generated from Qwen3-Coder.  Only need to change distance to manhattan_distance :D
local Position = require('__erm_libs__/stdlib/position')
local Direction = require('__erm_libs__/stdlib/direction')

local Territory = {}

--- Helper function to generate a path segment with width
-- @tparam table start_chunk Starting chunk position
-- @tparam table end_chunk End chunk position
-- @tparam number path_width Width of the path
-- @tparam table seen Table to track already added chunks
-- @tparam table chunks Table to store the resulting chunks
local function generate_wide_path(start_chunk, end_chunk, path_width, seen, chunks)
    local direction = {
        x = end_chunk.x - start_chunk.x,
        y = end_chunk.y - start_chunk.y
    }

    local distance = Position.manhattan_distance(start_chunk, end_chunk)
    if distance <= 0 then
        return
    end

    local unit_vector = {
        x = direction.x / distance,
        y = direction.y / distance
    }

    -- Perpendicular vector for width
    local perpendicular = {
        x = -unit_vector.y,
        y = unit_vector.x
    }

    local steps = math.ceil(distance)
    -- Ensure we don't divide by zero
    if steps == 0 then
        steps = 1
    end
    
    for i = 0, steps do
        local progress = i / steps
        local center_pos = {
            x = start_chunk.x + progress * direction.x,
            y = start_chunk.y + progress * direction.y
        }

        -- Add the center chunk
        local center_chunk = {
            x = math.floor(center_pos.x),
            y = math.floor(center_pos.y)
        }
        local center_key = center_chunk.x .. "," .. center_chunk.y
        if not seen[center_key] then
            seen[center_key] = true
            table.insert(chunks, center_chunk)
        end

        -- Add width to the path
        local half_width = path_width / 2
        for j = 1, math.floor(half_width) do
            -- Add chunks to one side
            local side1_pos = {
                x = center_pos.x + j * perpendicular.x,
                y = center_pos.y + j * perpendicular.y
            }
            local side1_chunk = {
                x = math.floor(side1_pos.x),
                y = math.floor(side1_pos.y)
            }
            local side1_key = side1_chunk.x .. "," .. side1_chunk.y
            if not seen[side1_key] then
                seen[side1_key] = true
                table.insert(chunks, side1_chunk)
            end

            -- Add chunks to other side
            local side2_pos = {
                x = center_pos.x - j * perpendicular.x,
                y = center_pos.y - j * perpendicular.y
            }
            local side2_chunk = {
                x = math.floor(side2_pos.x),
                y = math.floor(side2_pos.y)
            }
            local side2_key = side2_chunk.x .. "," .. side2_chunk.y
            if not seen[side2_key] then
                seen[side2_key] = true
                table.insert(chunks, side2_chunk)
            end
        end
    end
end

--- Create an L-shaped territory
-- @tparam table corner_position The corner position of the L shape
-- @tparam table horizontal_end_position The end position of the horizontal part of the L
-- @tparam table vertical_end_position The end position of the vertical part of the L
-- @tparam number path_width Width of the path in chunks
-- @treturn table Array of chunk positions representing the L-shaped territory
function Territory.compute_L_shape(corner_position, path_width)
    local direction = Direction.which_area(corner_position)
    local chunks = {}
    local seen = {}

    -- Convert positions to chunk positions
    local corner_chunk = Position.to_chunk_position(corner_position)
    local h_end_chunk = Position.to_chunk_position(horizontal_end_position)
    local v_end_chunk = Position.to_chunk_position(vertical_end_position)

    -- Generate horizontal part of the L
    generate_wide_path(corner_chunk, h_end_chunk, path_width, seen, chunks)

    -- Generate vertical part of the L
    generate_wide_path(corner_chunk, v_end_chunk, path_width, seen, chunks)

    return chunks
end

--- Compute a dynamic width chunk path array from position A to position B
-- @tparam table pos_a Starting position
-- @tparam table pos_b Ending position
-- @tparam number width Width of the path in chunks (default: 4)
-- @treturn table Array of chunk positions representing a path of specified width
function Territory.compute_territory_path(pos_a, pos_b, width)
    -- Set default width to 5 if not provided
    width = width or 4

    -- Convert positions to chunk positions
    local chunk_a = Position.to_chunk_position(pos_a)
    local chunk_b = Position.to_chunk_position(pos_b)

    -- Handle special case where start and end are the same chunk
    if chunk_a.x == chunk_b.x and chunk_a.y == chunk_b.y then
        return {chunk_a}
    end

    local chunks = {}
    local seen = {}
    generate_wide_path(chunk_a, chunk_b, width, seen, chunks)
    
    return chunks
end

return Territory