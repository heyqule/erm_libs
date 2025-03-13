﻿---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 12/1/2024 11:15 AM
---

require("util")
local MapGenFunctions = {}

--- enemy with non enemy_base name
local exclude_autoplace = {
    
}

MapGenFunctions.remove_enemy_autoplace_controls = function(autoplace_controls)
    for key, _ in pairs(autoplace_controls) do
        if string.find(key,"enemy_base", nil, true) or 
           string.find(key,"enemy-base", nil, true) or
           exclude_autoplace[key] 
        then
            autoplace_controls[key] = nil
        end
    end
end

MapGenFunctions.autoplace_is_enemy_base = function(name)
    return string.find(name, "enemy_base", 1, true) or string.find(name,"enemy-base", 1, true)
end

MapGenFunctions.has_enemy_autoplace = function(prototype)
    if prototype.map_gen_settings and prototype.map_gen_settings.autoplace_controls then
        for name, autoplace_control in pairs(prototype.map_gen_settings.autoplace_controls) do
            if MapGenFunctions.autoplace_is_enemy_base(name) then
                return true
            end
        end
    end
    
    return false;
end

---
--- prototype - planet prototype
---
MapGenFunctions.get_enemy_autoplaces = function(prototype)
    local enemy_autoplaces = {}
    if prototype.map_gen_settings and prototype.map_gen_settings.autoplace_controls then
        for name, autoplace_control in pairs(prototype.map_gen_settings.autoplace_controls) do
            if MapGenFunctions.autoplace_is_enemy_base(name) then
                table.insert(enemy_autoplaces, name)
            end
        end
    end
    return enemy_autoplaces
end

---
--- prototype - planet prototype
---
MapGenFunctions.territory_units = function(prototype)
    if prototype.map_gen_settings and prototype.map_gen_settings.territory_settings then
        return prototype.map_gen_settings.territory_settings.units
    end
    return nil
end


return MapGenFunctions