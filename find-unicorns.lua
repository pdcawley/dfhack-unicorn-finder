-- Generate worlds and search for ones matching the embark assistant profile
--@module = true
--[====[

   find-unicorns
   =============
   Generate worlds and search for embarks in them until we find at least one
   embark that matches our embark-assistant profile.

]====]

local PRESETNAME  = 'PDC1'
local gui = require 'gui'
local utils = require 'utils'
local WORLD_GEN_MENU_ID=3
local worldgen_confirmed  = false

local SEARCHRESULTS_PATH = dfhack.getDFPath() .. "/data/init/embark_assistant_fileresult.txt"
local UNICORNPRESETS_PATH = dfhack.getDFPath() .. '/data/init/unicorn_presets.txt'

local target_region = false
local target_worldname_str = ''
local worldsFound = 0

local onSearchComplete = dfhack.event.new()

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

function istrue(v)
   return v ~= nil and v ~= false and v ~= 0
end

function K(k)
   return df.interface_key[k]
end

function send_key(k)
   gui.simulateInput(dfhack.gui.getCurViewscreen(), k)
end

-- Borrowed from dfremote
function embark_cancel()
   local ws = dfhack.gui.getCurViewscreen()
   if ws._type ~= df.viewscreen_choose_start_sitest then
      return
   end

   -- Gather path info while we have the data loaded
   local optsws = df.viewscreen_optionst:new()

   optsws.options:insert(0,5) -- abort game
   optsws.parent = ws
   ws.child = optsws

   gui.simulateInput(optsws, 'SELECT')
end


function start_advanced_worldgen()
   local ws = dfhack.gui.getCurViewscreen()
   -- Check we're on the title screen or its subscreens
   while ws and ws.parent and ws._type ~= df.viewscreen_titlest do
      ws = ws.parent
   end
   if ws._type ~= df.viewscreen_titlest then
      print 'wrong screen'
      return
   end

   -- Return to title screen
   ws = dfhack.gui.getCurViewscreen()
   while ws and ws.parent and ws._type ~= df.viewscreen_titlest do
      local parent = ws.parent
      parent.child = nil
      ws:delete()
      ws = parent
   end

   local titlews = ws --as:df.viewscreen_titlest

   titlews.sel_subpage = df.viewscreen_titlest.T_sel_subpage.None
   -- Skip any 'start/continue playing' lines, and choose advanced worldgen
   titlews.sel_menu_line =
      (#titlews.arena_savegames-#titlews.start_savegames > 1 and 1 or 0) +
      (#titlews.start_savegames > 0 and 1 or 0) +
      1
   gui.simulateInput(titlews, 'SELECT')

   -- Now wait for raws to load and stuff and continue with the process
   dfhack.timeout(2, 'frames', progress_worldgen)
end

function progress_worldgen()
   local ws = dfhack.gui.getCurViewscreen() --as:df.viewscreen_new_regionst

   if ws._type ~= df.viewscreen_new_regionst then
      print('check', ws._type)
      return
   end

   -- If finished loading raws
   if ws.in_worldgen and ws.unk_b8 == 19 then
      -- Close 'Welcome to ...' message
      if #ws.welcome_msg > 0 then
         gui.simulateInput(ws, 'LEAVESCREEN')
      end
      for i,p in pairs(ws.worldgen_presets) do
         if p.anon_1 == PRESETNAME then
            ws.cursor_paramset = i
         end
      end

      gui.simulateInput(ws, 'SELECT')
      dfhack.timeout(20, 'frames', check_worldgen_done)
      return
   end
   dfhack.timeout(20, 'frames', progress_worldgen)
end

function check_worldgen_done()
   if df.global.world.worldgen_status.state == 10 then
      -- worldgen is done!
      target_worldname_str = dfhack.TranslateName(df.global.world.world_data.name)
      local ws = dfhack.gui.getCurViewscreen()  --as:df.viewscreen_new_regionst
      gui.simulateInput(ws, 'SELECT')

      dfhack.timeout(20, 'frames', wait_for_home_screen)
      return
   end
   dfhack.timeout(20, 'frames', check_worldgen_done)
end

function wait_for_home_screen()
   local ws = dfhack.gui.getCurViewscreen()
   if ws._type ~= df.viewscreen_titlest then
      dfhack.timeout(2, 'frames', wait_for_home_screen)
      return
   end
   dfhack.timeout(2,'frames', start_search)
end

function find_unicorns(desired)
   onSearchComplete.singleSearch = function (count)
      if (count > 0) and (worldsFound >= desired) then
         onSearchComplete.singleSearch = nil
         return
      else
         dfhack.timeout(1,'frames', start_advanced_worldgen)
      end
   end
   start_advanced_worldgen()
end

function search_all(remaining)
   local ws = dfhack.gui.getCurViewscreen()
   local nextSave = 0
   onSearchComplete.searchAll = function(count)
      if count and count < 0 then
         print('Finishing searchAll')
         onSearchComplete.searchAll = nil
         return
      end
      print('Checking we are on the right screen')
      ws = dfhack.gui.getCurViewscreen()
      if ws._type ~= df.viewscreen_titlest then
         print('... nope!')
         dfhack.timeout(2,'frames', onSearchComplete.searchAll)
         return
      else
         print('... yup!')
         print('getting ready to check save number ' .. nextSave .. ' of ' .. #ws.start_savegames)

         if nextSave < #ws.start_savegames then
            target_worldname_str = ws.start_savegames[nextSave].world_name_str
            print('About to search for ' .. target_worldname_str)
            nextSave = nextSave + 1
            start_search()
         end
         return
      end
   end
   onSearchComplete.searchAll(0)
end

-- we assume we're back at the start screen here
function start_search()
   ws = dfhack.gui.getCurViewscreen()
   ws.sel_subpage = df.viewscreen_titlest.T_sel_subpage.None

   if #ws.start_savegames == 0 then
      print 'Nothing left to search'
      onSearchComplete(-1)
      return
   end

   ws.sel_menu_line = (#ws.arena_savegames - #ws.start_savegames > 1 and 1 or 0)
   send_key('SELECT')
   ws = dfhack.gui.getCurViewscreen()
   if ws.sel_subpage == 1 then
      -- There's more than one world available. Choose the one we're interested in
      print('Getting ready to search for ' .. target_worldname_str)
      for i,sg in pairs(ws.start_savegames) do
         if sg.world_name_str == target_worldname_str then
            ws.sel_submenu_line = i
         end
      end
      send_key('SELECT')
   end
   send_key('SELECT')
   dfhack.timeout(2,'frames',progress_embark)
end

function progress_embark()
   local ws = dfhack.gui.getCurViewscreen()
   if ws._type ~= df.viewscreen_choose_start_sitest then
      dfhack.timeout(10,'frames',progress_embark)
      return
   end
   do_search()
end

function do_search()
   -- remove any previous file results
   os.remove( SEARCHRESULTS_PATH)
   dfhack.run_command('embark-assistant', 'fileresult')
   dfhack.timeout(10,'frames', await_search_results)
end

function await_search_results()
   local r,err = io.open(SEARCHRESULTS_PATH, 'r')
   if not err then
      local count = r:read('*number')
      send_key('CUSTOM_Q')
      search_got_result(count)
      return
   end
   dfhack.timeout(5, 'frames',  await_search_results)
end

function search_got_result(count)
   if count > 0 then
      worldsFound = worldsFound + 1
      exportparamset(assert(io.open(UNICORNPRESETS_PATH, 'a')))
   end
   embark_cancel()
   onSearchComplete(count)
   return
end

function show_help()
   print "find-unicorns search -- Searches all the existing saves for something"
   print "                        matching your embark_assistant_profile.txt"
   print "find-unicorns build [-preset PRESETNAME] [-count 5]"
   print "    -- Starts building a world using PRESETNAME, then searches it for"
   print "       'unicorns' based on your embark_assistant_profile.txt"
   print ""
   print "The full paramset for any 'hit' is appended to data/init/unicorn_presets.txt."
   print "To use the worlds you found, append this file to your data/init/world_gen.txt"
   print ""
   print "If your desired embark is particularly rare, expect to generate a LOT of"
   print "worlds. If you've got a couple of desired types, don't throw them away"
   print "immediately, just update the search profile and run 'find-unicorns search'"
end


if not moduleMode then
   utils = require('utils')
   local valid_args = {
      help = {},
      search = {},
      build = utils.invert{'preset', 'count'},
   }
   local args = {...}

   function unpack (t, i)
      i = i or 1
      if t[i] ~= nil then
         return t[i], unpack(t, i + 1)
      end
   end

   function dispatch_command(raw_args)
      local cmd = table.remove(raw_args, 1)
      local args = utils.processArgs(raw_args, valid_args[cmd] or {})
      if cmd == 'help' then
         if show_help then show_help(args) end
      elseif cmd == 'search' then
         search_all(args)
      elseif cmd == 'build' then
         if args.preset then PRESETNAME = args.preset end
         find_unicorns( args.count or 5 )
      elseif  tonumber(cmd) then
         find_unicorns( tonumber(cmd) )
      elseif cmd then
         if show_help then show_help() end
      else
         find_unicorns(5)
      end
   end

   dispatch_command(args)
end