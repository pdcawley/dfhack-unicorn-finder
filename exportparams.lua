-- [[file:~/Projects/dfhack-unicorn-finder/README.org::27A57D34-29C9-44B7-9BCF-BA8489A706DF][27A57D34-29C9-44B7-9BCF-BA8489A706DF]]
--  Exports the world generation parameters and the map as a parameter set. The file is <DF directory>\data\init\exported_map.txt.
--[====[

   exportparam
   ==========
]====]
-- [[[[file:~/Projects/dfhack-unicorn-finder/README.org::5D0EA62F-5F4B-42F7-B7FB-3DEFD118DF69][5D0EA62F-5F4B-42F7-B7FB-3DEFD118DF69]]][5D0EA62F-5F4B-42F7-B7FB-3DEFD118DF69]]
-- NB: This file is generated from README.org https://github.com/pdcawley/dfhack-unicorn-finder.
-- Ideally, you should edit that file and regenerate this, but it only really matters if you are
-- planning to contribute to the project.
-- 5D0EA62F-5F4B-42F7-B7FB-3DEFD118DF69 ends here

-- [[[[file:~/Projects/dfhack-unicorn-finder/README.org::exportparams][exportparams]]][exportparams]]
function exportparamset(file)
   if not dfhack.isWorldLoaded () then
      dfhack.color (COLOR_LIGHTRED)
      dfhack.println ("exportmap requires a world to be loaded in DF.")
      dfhack.color (COLOR_RESET)
      return
   end

   --  Couldn't find the definition of the enum.
   --
   local pole_map = {}
   pole_map [0] = "NONE"
   pole_map [1] = "NORTH_OR_SOUTH"
   pole_map [2] = "NORTH_AND_OR_SOUTH"
   pole_map [3] = "NORTH"
   pole_map [4] = "SOUTH"
   pole_map [5] = "NORTH_AND_SOUTH"

   local pole = df.global.world.world_data.flip_latitude

   function pole_to_string (pole)
      if pole == -1 then
         return "NONE"
      elseif pole == 0 then
         return "NORTH"
      elseif pole == 1 then
         return "SOUTH"
      else
         return "NORTH_AND_SOUTH"
      end
   end

   function boolean_to_int (b)
      if true then
         return 1
      else
         return 0
      end
   end

   local param = df.global.world.worldgen.worldgen_parms

   local world_name = dfhack.TranslateName(df.global.world.world_data.name)

   file:write ("[WORLD_GEN]\n")
   file:write ("     [TITLE:" .. world_name:gsub(' ', '_'):upper() .. "]\n")
   file:write ("     [SEED:" .. param.seed .. "]\n")
   file:write ("     [HISTORY_SEED:" .. param.history_seed .. "]\n")
   file:write ("     [NAME_SEED:" .. param.name_seed .. "]\n")
   file:write ("     [CREATURE_SEED:" .. param.creature_seed .. "]\n")
   file:write ("     [DIM:" .. tostring (param.dim_x) .. ":" ..
                  tostring (param.dim_y) .. "]\n")
   file:write ("     [EMBARK_POINTS:" .. tostring (param.embark_points) .. "]\n")
   file:write ("     [END_YEAR:" .. tostring (param.end_year) .. "]\n")
   file:write ("     [BEAST_END_YEAR:"  .. tostring (param.beast_end_year) .. ":" ..
                  tostring (param.beast_end_year_percent) .. "]\n")
   file:write ("     [REVEAL_ALL_HISTORY:" .. tostring (param.reveal_all_history) .. "]\n")
   file:write ("     [CULL_HISTORICAL_FIGURES:" .. tostring (param.cull_historical_figures) .. "]\n")
   file:write ("     [ELEVATION:" .. tostring (param.ranges [0] [df.worldgen_range_type.ELEVATION]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.ELEVATION]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.ELEVATION]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.ELEVATION]) .. "]\n")
   file:write ("     [RAINFALL:" .. tostring (param.ranges [0] [df.worldgen_range_type.RAINFALL]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.RAINFALL]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.RAINFALL]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.RAINFALL]) .. "]\n")
   file:write ("     [TEMPERATURE:" .. tostring (param.ranges [0] [df.worldgen_range_type.TEMPERATURE]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.TEMPERATURE]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.TEMPERATURE]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.TEMPERATURE]) .. "]\n")
   file:write ("     [DRAINAGE:" .. tostring (param.ranges [0] [df.worldgen_range_type.DRAINAGE]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.DRAINAGE]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.DRAINAGE]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.DRAINAGE]) .. "]\n")
   file:write ("     [VOLCANISM:" .. tostring (param.ranges [0] [df.worldgen_range_type.VOLCANISM]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.VOLCANISM]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.VOLCANISM]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.VOLCANISM]) .. "]\n")
   file:write ("     [SAVAGERY:" .. tostring (param.ranges [0] [df.worldgen_range_type.SAVAGERY]) .. ":" ..
                  tostring (param.ranges [1] [df.worldgen_range_type.SAVAGERY]) .. ":" ..
                  tostring (param.ranges [2] [df.worldgen_range_type.SAVAGERY]) .. ":" ..
                  tostring (param.ranges [3] [df.worldgen_range_type.SAVAGERY]) .. "]\n")
   file:write ("     [ELEVATION_FREQUENCY:" .. tostring (param.elevation_frequency [0]) .. ":" ..
                  tostring (param.elevation_frequency [1]) .. ":" ..
                  tostring (param.elevation_frequency [2]) .. ":" ..
                  tostring (param.elevation_frequency [3]) .. ":" ..
                  tostring (param.elevation_frequency [4]) .. ":" ..
                  tostring (param.elevation_frequency [5]) .. "]\n")
   file:write ("     [RAIN_FREQUENCY:" .. tostring (param.rain_frequency [0]) .. ":" ..
                  tostring (param.rain_frequency [1]) .. ":" ..
                  tostring (param.rain_frequency [2]) .. ":" ..
                  tostring (param.rain_frequency [3]) .. ":" ..
                  tostring (param.rain_frequency [4]) .. ":" ..
                  tostring (param.rain_frequency [5]) .. "]\n")
   file:write ("     [DRAINAGE_FREQUENCY:" .. tostring (param.drainage_frequency [0]) .. ":" ..
                  tostring (param.drainage_frequency [1]) .. ":" ..
                  tostring (param.drainage_frequency [2]) .. ":" ..
                  tostring (param.drainage_frequency [3]) .. ":" ..
                  tostring (param.drainage_frequency [4]) .. ":" ..
                  tostring (param.drainage_frequency [5]) .. "]\n")
   file:write ("     [TEMPERATURE_FREQUENCY:" .. tostring (param.temperature_frequency [0]) .. ":" ..
                  tostring (param.temperature_frequency [1]) .. ":" ..
                  tostring (param.temperature_frequency [2]) .. ":" ..
                  tostring (param.temperature_frequency [3]) .. ":" ..
                  tostring (param.temperature_frequency [4]) .. ":" ..
                  tostring (param.temperature_frequency [5]) .. "]\n")
   file:write ("     [SAVAGERY_FREQUENCY:" .. tostring (param.savagery_frequency [0]) .. ":" ..
                  tostring (param.savagery_frequency [1]) .. ":" ..
                  tostring (param.savagery_frequency [2]) .. ":" ..
                  tostring (param.savagery_frequency [3]) .. ":" ..
                  tostring (param.savagery_frequency [4]) .. ":" ..
                  tostring (param.savagery_frequency [5]) .. "]\n")
   file:write ("     [VOLCANISM_FREQUENCY:" .. tostring (param.volcanism_frequency [0]) .. ":" ..
                  tostring (param.volcanism_frequency [1]) .. ":" ..
                  tostring (param.volcanism_frequency [2]) .. ":" ..
                  tostring (param.volcanism_frequency [3]) .. ":" ..
                  tostring (param.volcanism_frequency [4]) .. ":" ..
                  tostring (param.volcanism_frequency [5]) .. "]\n")
   file:write ("     [POLE:" .. pole_to_string (pole) .."]\n")
   file:write ("     [MINERAL_SCARCITY:" .. tostring (param.mineral_scarcity) .. "]\n")
   file:write ("     [MEGABEAST_CAP:" .. tostring (param.megabeast_cap) .. "]\n")
   file:write ("     [SEMIMEGABEAST_CAP:" .. tostring (param.semimegabeast_cap) .. "]\n")
   file:write ("     [TITAN_NUMBER:" .. tostring (param.titan_number) .. "]\n")
   file:write ("     [TITAN_ATTACK_TRIGGER:" .. tostring (param.titan_attack_trigger [0]) .. ":" ..
                  tostring (param.titan_attack_trigger [1]) .. ":" ..
                  tostring (param.titan_attack_trigger [2]).. "]\n")
   file:write ("     [DEMON_NUMBER:" .. tostring (param.demon_number) .. "]\n")
   file:write ("     [NIGHT_TROLL_NUMBER:" .. tostring (param.night_troll_number) .. "]\n")
   file:write ("     [BOGEYMAN_NUMBER:" .. tostring (param.bogeyman_number) .. "]\n")
   if dfhack.pcall (function () local dummy = param.nightmare_number end) then
      file:write ("     [NIGHTMARE_NUMBER:" .. tostring (param.nightmare_number) .. "]\n")
   end
   file:write ("     [VAMPIRE_NUMBER:" .. tostring (param.vampire_number) .. "]\n")
   file:write ("     [WEREBEAST_NUMBER:" .. tostring (param.werebeast_number) .. "]\n")
   if dfhack.pcall (function () local dummy = param.werebeast_attack_trigger [0] end) then
      file:write ("     [WEREBEAST_ATTACK_TRIGGER:" .. tostring (param.werebeast_attack_trigger [0]) .. ":" ..
                     tostring (param.werebeast_attack_trigger [1]) .. ":" ..
                     tostring (param.werebeast_attack_trigger [2]).. "]\n")
   end
   file:write ("     [SECRET_NUMBER:" .. tostring (param.secret_number) .. "]\n")
   file:write ("     [REGIONAL_INTERACTION_NUMBER:".. tostring (param.regional_interaction_number).. "]\n")
   file:write ("     [DISTURBANCE_INTERACTION_NUMBER:" .. tostring(param.disturbance_interaction_number) .. "]\n")
   file:write ("     [EVIL_CLOUD_NUMBER:" .. tostring (param.evil_cloud_number) .. "]\n")
   file:write ("     [EVIL_RAIN_NUMBER:" .. tostring (param.evil_rain_number) .. "]\n")
   local generate_divine_materials
   if not dfhack.pcall (function () generate_divine_materials = param.generate_divine_materials end) then  --  Expected new name
      generate_divine_materials = param.anon_1   --  Will probably be renamed soon.
   end
   file:write ("     [GENERATE_DIVINE_MATERIALS:" .. tostring (generate_divine_materials) .. "]\n")
   if dfhack.pcall (function () local dummy = param.allow_divination end) then
      file:write ("     [ALLOW_DIVINATION:" .. tostring (param.allow_divination) .. "]\n")
      file:write ("     [ALLOW_DEMONIC_EXPERIMENTS:" .. tostring (param.allow_demonic_experiments) .. "]\n")
      file:write ("     [ALLOW_NECROMANCER_EXPERIMENTS:" .. tostring (param.allow_necromancer_experiments) .. "]\n")
      file:write ("     [ALLOW_NECROMANCER_LIEUTENANTS:" .. tostring (param.allow_necromancer_lieutenants) .. "]\n")
      file:write ("     [ALLOW_NECROMANCER_GHOULS:" .. tostring (param.allow_necromancer_ghouls) .. "]\n")
      file:write ("     [ALLOW_NECROMANCER_SUMMONS:" .. tostring (param.allow_necromancer_summons) .. "]\n")
   end
   file:write ("     [GOOD_SQ_COUNTS:" .. tostring (param.good_sq_counts_0) .. ":" ..
                  tostring (param.good_sq_counts_1) .. ":" ..
                  tostring (param.good_sq_counts_2) .. "]\n")
   file:write ("     [EVIL_SQ_COUNTS:" .. tostring (param.evil_sq_counts_0) .. ":" ..
                  tostring (param.evil_sq_counts_1) .. ":" ..
                  tostring (param.evil_sq_counts_2) .. "]\n")
   file:write ("     [PEAK_NUMBER_MIN:" .. tostring (param.peak_number_min) .. "]\n")
   file:write ("     [PARTIAL_OCEAN_EDGE_MIN:" .. tostring (param.partial_ocean_edge_min) .. "]\n")
   file:write ("     [COMPLETE_OCEAN_EDGE_MIN:" .. tostring (param.complete_ocean_edge_min) .. "]\n")
   file:write ("     [VOLCANO_MIN:" .. tostring (param.volcano_min) .. "]\n")
   file:write ("     [REGION_COUNTS:SWAMP:" .. tostring (param.region_counts [0] [df.worldgen_region_type.SWAMP]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.SWAMP]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.SWAMP]) .. "]\n")
   file:write ("     [REGION_COUNTS:DESERT:" .. tostring (param.region_counts [0] [df.worldgen_region_type.DESERT]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.DESERT]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.DESERT]) .. "]\n")
   file:write ("     [REGION_COUNTS:FOREST:" .. tostring (param.region_counts [0] [df.worldgen_region_type.FOREST]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.FOREST]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.FOREST]) .. "]\n")
   file:write ("     [REGION_COUNTS:MOUNTAINS:" .. tostring (param.region_counts [0] [df.worldgen_region_type.MOUNTAINS]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.MOUNTAINS]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.MOUNTAINS]) .. "]\n")
   file:write ("     [REGION_COUNTS:OCEAN:" .. tostring (param.region_counts [0] [df.worldgen_region_type.OCEAN]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.OCEAN]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.OCEAN]) .. "]\n")
   file:write ("     [REGION_COUNTS:GLACIER:" .. tostring (param.region_counts [0] [df.worldgen_region_type.GLACIER]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.GLACIER]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.GLACIER]) .. "]\n")
   file:write ("     [REGION_COUNTS:TUNDRA:" .. tostring (param.region_counts [0] [df.worldgen_region_type.TUNDRA]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.TUNDRA]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.TUNDRA]) .. "]\n")
   file:write ("     [REGION_COUNTS:GRASSLAND:" .. tostring (param.region_counts [0] [df.worldgen_region_type.GRASSLAND]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.GRASSLAND]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.GRASSLAND]) .. "]\n")
   file:write ("     [REGION_COUNTS:HILLS:" .. tostring (param.region_counts [0] [df.worldgen_region_type.HILLS]) .. ":" ..
                  tostring (param.region_counts [1] [df.worldgen_region_type.HILLS]) .. ":" ..
                  tostring (param.region_counts [2] [df.worldgen_region_type.HILLS]) .. "]\n")
   file:write ("     [EROSION_CYCLE_COUNT:" .. tostring (param.erosion_cycle_count) .. "]\n")
   file:write ("     [RIVER_MINS:" .. tostring (param.river_mins [0]) ..":" ..
                  tostring (param.river_mins [1]) .. "]\n")
   file:write ("     [PERIODICALLY_ERODE_EXTREMES:" .. tostring (param.periodically_erode_extremes) .. "]\n")
   file:write ("     [OROGRAPHIC_PRECIPITATION:" .. tostring (param.orographic_precipitation) .. "]\n")
   file:write ("     [SUBREGION_MAX:" .. tostring (param.subregion_max) .. "]\n")
   file:write ("     [CAVERN_LAYER_COUNT:" .. tostring (param.cavern_layer_count) .. "]\n")
   file:write ("     [CAVERN_LAYER_OPENNESS_MIN:" .. tostring (param.cavern_layer_openness_min) .. "]\n")
   file:write ("     [CAVERN_LAYER_OPENNESS_MAX:" .. tostring (param.cavern_layer_openness_max) .. "]\n")
   file:write ("     [CAVERN_LAYER_PASSAGE_DENSITY_MIN:" .. tostring (param.cavern_layer_passage_density_min) .. "]\n")
   file:write ("     [CAVERN_LAYER_PASSAGE_DENSITY_MAX:" .. tostring (param.cavern_layer_passage_density_max) .. "]\n")
   file:write ("     [CAVERN_LAYER_WATER_MIN:" .. tostring (param.cavern_layer_water_min) .. "]\n")
   file:write ("     [CAVERN_LAYER_WATER_MAX:" .. tostring (param.cavern_layer_water_max) .. "]\n")
   file:write ("     [HAVE_BOTTOM_LAYER_1:" .. tostring (boolean_to_int (param.have_bottom_layer_1)) .. "]\n")
   file:write ("     [HAVE_BOTTOM_LAYER_2:" .. tostring (boolean_to_int (param.have_bottom_layer_2)) .. "]\n")
   file:write ("     [LEVELS_ABOVE_GROUND:" .. tostring (param.levels_above_ground) .. "]\n")
   file:write ("     [LEVELS_ABOVE_LAYER_1:" .. tostring (param.levels_above_layer_1) .. "]\n")
   file:write ("     [LEVELS_ABOVE_LAYER_2:" .. tostring (param.levels_above_layer_2) .. "]\n")
   file:write ("     [LEVELS_ABOVE_LAYER_3:" .. tostring (param.levels_above_layer_3) .. "]\n")
   file:write ("     [LEVELS_ABOVE_LAYER_4:" .. tostring (param.levels_above_layer_4) .. "]\n")
   file:write ("     [LEVELS_ABOVE_LAYER_5:" .. tostring (param.levels_above_layer_5) .. "]\n")
   file:write ("     [LEVELS_AT_BOTTOM:" .. tostring (param.levels_at_bottom) .. "]\n")
   file:write ("     [CAVE_MIN_SIZE:" .. tostring (param.cave_min_size) .. "]\n")
   file:write ("     [CAVE_MAX_SIZE:" .. tostring (param.cave_max_size) .. "]\n")
   file:write ("     [MOUNTAIN_CAVE_MIN:" .. tostring (param.mountain_cave_min) .. "]\n")
   file:write ("     [NON_MOUNTAIN_CAVE_MIN:" .. tostring (param.non_mountain_cave_min) .. "]\n")
   file:write ("     [ALL_CAVES_VISIBLE:" .. tostring (param.all_caves_visible) .. "]\n")
   file:write ("     [SHOW_EMBARK_TUNNEL:" .. tostring (param.show_embark_tunnel) .. "]\n")
   file:write ("     [TOTAL_CIV_NUMBER:" .. tostring (param.total_civ_number) .. "]\n")
   file:write ("     [TOTAL_CIV_POPULATION:" .. tostring (param.total_civ_population) .. "]\n")
   file:write ("     [SITE_CAP:" .. tostring (param.site_cap) .. "]\n")
   file:write ("     [PLAYABLE_CIVILIZATION_REQUIRED:" .. tostring (param.playable_civilization_required) .. "]\n")
   file:write ("     [ELEVATION_RANGES:" .. tostring (param.elevation_ranges_0) .. ":" ..
                  tostring (param.elevation_ranges_1) .. ":" ..
                  tostring (param.elevation_ranges_2) .. "]\n")
   file:write ("     [RAIN_RANGES:" .. tostring (param.rain_ranges_0) .. ":" ..
                  tostring (param.rain_ranges_1) .. ":" ..
                  tostring (param.rain_ranges_2) .. "]\n")
   file:write ("     [DRAINAGE_RANGES:" .. tostring (param.drainage_ranges_0) .. ":" ..
                  tostring (param.drainage_ranges_1) .. ":" ..
                  tostring (param.drainage_ranges_2) .. "]\n")
   file:write ("     [SAVAGERY_RANGES:" .. tostring (param.savagery_ranges_0) .. ":" ..
                  tostring (param.savagery_ranges_1) .. ":" ..
                  tostring (param.savagery_ranges_2) .. "]\n")
   file:write ("     [VOLCANISM_RANGES:" .. tostring (param.volcanism_ranges_0) .. ":" ..
                  tostring (param.volcanism_ranges_1) .. ":" ..
                  tostring (param.volcanism_ranges_2) .. "]\n\n")

   file:flush()
   file:close()
end
-- exportparams ends here

exportparamset()
-- 27A57D34-29C9-44B7-9BCF-BA8489A706DF ends here
