---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 8/10/2023 12:38 AM
---
require('util')
local AnimationDB = {}

---
--- @see https://github.com/heyqule/erm_zerg_hd_assets/blob/master/animation_db.lua for example
AnimationDB.data = {}

---
--- Construct basic layered animations
---
function AnimationDB.get_layered_animations(entity_type, name, animation_type, unit_scale, draw_light)
    draw_light = draw_light or true

    local animation = {
        layers = {
            AnimationDB.get_main_animation(entity_type, name, animation_type, unit_scale),
            AnimationDB.get_shadow_animation(entity_type, name, animation_type, unit_scale),
            AnimationDB.get_team_mask_animation(entity_type, name, animation_type, unit_scale),
            AnimationDB.get_glow_mask_animation(entity_type, name, animation_type, unit_scale),
            AnimationDB.get_effect_mask_animation(entity_type, name, animation_type, unit_scale),
        }
    }

    if draw_light then
        local lightLayer = AnimationDB.get_light_mask_animation(entity_type, name, animation_type, unit_scale)
        if lightLayer then
            table.insert(animation['layers'], lightLayer)
        end
    end

    return animation
end

local subtypes = {
    main = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_main_animation(entity_type, name, animation_type, unit_scale)
    end,
    shadow = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_shadow_animation(entity_type, name, animation_type, unit_scale)
    end,
    glow = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_glow_mask_animation(entity_type, name, animation_type, unit_scale)
    end,
    effect = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_effect_mask_animation(entity_type, name, animation_type, unit_scale)
    end,
    light = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_light_mask_animation(entity_type, name, animation_type, unit_scale)
    end,
    team = function(entity_type, name, animation_type, unit_scale)
        return AnimationDB.get_team_mask_animation(entity_type, name, animation_type, unit_scale)
    end,
}
---
--- get single sprite animation from any subtypes
---
function AnimationDB.get_single_animation(entity_type, name, animation_type, subtype, unit_scale)
    subtype = subtype or 'main'
    if subtypes[subtype] then
        local animation = subtypes[subtype](entity_type, name, animation_type, unit_scale)
        return animation
    end

    return nil
end

function AnimationDB.get_main_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['main'] then
        local animation = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['main'])
        if unit_scale then
            animation.scale = unit_scale
        end
        return animation
    end
end

function AnimationDB.get_shadow_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['shadow'] then
        local animation  = AnimationDB.data[entity_type][name][animation_type]['shadow']
        if animation['frame_count'] == nil then
            animation = AnimationDB.get_main_animation(entity_type, name, animation_type, unit_scale)
            animation['shift'] = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['shadow']['shift'])
        end
        animation['draw_as_shadow'] = true
        return animation
    end
end

---
--- Return glow mask
---
function AnimationDB.get_glow_mask_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['glow'] then
        local animation = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['glow'])
        animation['draw_as_glow'] = true
        if unit_scale then
            animation.scale = unit_scale
        end
        return animation
    end
end

---
--- Return effect mask
---
function AnimationDB.get_effect_mask_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['effect'] then
        local animation = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['effect'])
        if unit_scale then
            animation.scale = unit_scale
        end
        return animation
    end
end

---
--- Return draw_as_light mask
---
function AnimationDB.get_light_mask_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['light'] then
        local animation = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['light'])
        if unit_scale then
            animation.scale = unit_scale
        end
        animation['draw_as_light'] = true
        return animation
    end
end

---
--- Return color mask for team colors
---
function AnimationDB.get_team_mask_animation(entity_type, name, animation_type, unit_scale)
    if AnimationDB.data[entity_type][name][animation_type]['team'] then
        local animation = util.table.deepcopy(AnimationDB.data[entity_type][name][animation_type]['team'])
        if unit_scale then
            animation.scale = unit_scale
        end
        return animation
    end
end

function AnimationDB.alter_team_color(animation_data, color, disable_mask, preserve_gloss)
    if animation_data['layers'] then
        for index, animation_node in pairs(animation_data['layers']) do
            if (animation_node.filename and string.find( animation_node.filename, '_teamcolour') ~= nil) or
                (animation_node.filenames and string.find( animation_node.filenames[1], '_teamcolour') ~= nil) or
                (animation_node.stripes and string.find( animation_node.stripes[1].filename, '_teamcolour') ~= nil) then
                if disable_mask then
                    animation_data['layers'][index] = nil
                else
                    animation_data['layers'][index]['tint'] = color
                    if preserve_gloss then
                        animation_data['layers'][index]['blend_mode'] = 'additive-soft'
                    end
                end
            end
        end
    end

    return animation_data
end

---
--- Toggle whether team color can be apply_runtime_time, only applicable to unit and turret. Does not work on Unit-spawner
---
function AnimationDB.apply_runtime_tint(animation_data, runtime_tint)
    if animation_data['layers'] then
        for index, animation_node in pairs(animation_data['layers']) do
            if (animation_node.filename and string.find( animation_node.filename, '_teamcolour') ~= nil) or
                (animation_node.filenames and string.find( animation_node.filenames[1], '_teamcolour') ~= nil) or
                (animation_node.stripes and string.find( animation_node.stripes[1].filename, '_teamcolour') ~= nil) then
                if runtime_tint then
                    animation_data['layers'][index]['apply_runtime_tint'] = true
                else
                    animation_data['layers'][index]['apply_runtime_tint'] = false
                end
            end
        end
    end
    return animation_data
end


function AnimationDB.change_animation_speed(animation_data, speed)
    if animation_data['layers'] then
        for index, _ in pairs(animation_data['layers']) do
            animation_data['layers'][index]['animation_speed'] = speed
        end
    elseif animation_data['animation_speed'] then
        animation_data['animation_speed'] = speed
    end

    return animation_data
end

function AnimationDB.change_frame_count(animation_data, frame_count)
    if animation_data['layers'] then
        for index, _ in pairs(animation_data['layers']) do
            animation_data['layers'][index]['animation_speed'] = frame_count
        end
    elseif animation_data['animation_speed'] then
        animation_data['animation_speed'] = frame_count
    end

    return animation_data
end

function AnimationDB.change_scale(animation_data, unit_scale, relative_scale)
    if animation_data['layers'] then
        for index, _ in pairs(animation_data['layers']) do
            if relative_scale then
                animation_data['layers'][index]['scale'] = animation_data['layers'][index]['scale'] * unit_scale
            else
                animation_data['layers'][index]['scale'] = unit_scale
            end
        end
    elseif animation_data['scale'] then
        if relative_scale then
            animation_data['scale'] = animation_data['scale'] * unit_scale
        else
            animation_data['scale'] = unit_scale
        end
    end

    return animation_data;
end

local adjust_shift = function(shift, new_shift)
    if shift then
        shift = {shift[1]+new_shift[1], shift[2]+new_shift[2]}
    else
        shift = new_shift
    end
    return shift
end

function AnimationDB.shift(animation_data, shift_vector)
    if animation_data['layers'] then
        for index, _ in pairs(animation_data['layers']) do
            animation_data['layers'][index]['shift'] = adjust_shift(animation_data['layers'][index]['shift'], shift_vector)
        end
    elseif animation_data['animation_speed'] then
        animation_data['shift'] = adjust_shift(animation_data['shift'], shift_vector)
    end

    return animation_data;
end

return AnimationDB;