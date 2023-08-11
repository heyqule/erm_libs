---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 8/10/2023 5:48 PM
---
local AnimationDB = require('__erm_zerg_hd_assets__/animation_db')
local String = require('__stdlib__/stdlib/utils/string')

local TeamColorManager = {}

local name_check = function(name, target)
    local nameToken = String.split(name, '/')
    return nameToken[1] == target
end


function TeamColorManager.change_team_color(target_race, color, disable_mask, preserve_gloss)

    local applicable_entity_types = {'unit','unit-spawner', 'turret', 'explosion', 'corpse'}

    for _, entity_type in pairs(applicable_entity_types) do
        for _, entity in pairs(data.raw[entity_type]) do
            if name_check(entity.name, target_race) == true then
                if entity['animation'] then
                    entity['animations'] = AnimationDB.alter_team_color(entity['animation'], color, disable_mask, preserve_gloss)
                end
                if entity['animations'] then
                    entity['animations'] = AnimationDB.alter_team_color(entity['animations'], color, disable_mask, preserve_gloss)
                end
                if entity['run_animation'] then
                    entity['run_animation'] = AnimationDB.alter_team_color(entity['run_animation'], color, disable_mask, preserve_gloss)
                end
                if entity['attack_parameters'] and entity['attack_parameters']['animation'] then
                    entity['attack_parameters']['animation'] = AnimationDB.alter_team_color(entity['attack_parameters']['animation'], color, disable_mask, preserve_gloss)
                end
                if entity['folding_animation'] then
                    entity['folding_animation'] = AnimationDB.alter_team_color(entity['folding_animation'], color, disable_mask, preserve_gloss)
                end
                if entity['folded_animation'] then
                    entity['folded_animation'] = AnimationDB.alter_team_color(entity['folded_animation'], color, disable_mask, preserve_gloss)
                end
                if entity['preparing_animation'] then
                    entity['preparing_animation'] = AnimationDB.alter_team_color(entity['preparing_animation'], color, disable_mask, preserve_gloss)
                end
                if entity['prepared_animation'] then
                    entity['prepared_animation'] = AnimationDB.alter_team_color(entity['prepared_animation'], color, disable_mask, preserve_gloss)
                end
                if entity['starting_attack_animation'] then
                    entity['starting_attack_animation'] = AnimationDB.alter_team_color(entity['starting_attack_animation'], color, disable_mask, preserve_gloss)
                end
            end
        end
    end
end

return TeamColorManager