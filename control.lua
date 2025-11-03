local g_playersNoChar = {}

function update_player(p_player)
  p_player.character_crafting_speed_modifier = settings.global["speed-settings-player-crafting"].value
  p_player.character_mining_speed_modifier = settings.global["speed-settings-player-mining"].value
  p_player.character_running_speed_modifier = settings.global["speed-settings-player-running"].value
end

function update_base_speed_tracker(old_value, new_value, mod_bonus)
  return 
end

function update_player_force()
  -- For update, we simply add the difference between the current and previous setting
  local laboratory_bonus_delta = settings.global["speed-settings-force-lab"].value - storage["speed-settings-previous-laboratory-bonus"]
  local worker_robot_bonus_delta = settings.global["speed-settings-force-worker-robot"].value - storage["speed-settings-previous-worker-robot-bonus"]
  game.forces["player"].laboratory_speed_modifier = game.forces["player"].laboratory_speed_modifier + laboratory_bonus_delta
  game.forces["player"].worker_robots_speed_modifier = game.forces["player"].worker_robots_speed_modifier + worker_robot_bonus_delta
  -- The previous settings are now updated to the current settings
  storage["speed-settings-previous-laboratory-bonus"] = settings.global["speed-settings-force-lab"].value
  storage["speed-settings-previous-worker-robot-bonus"] = settings.global["speed-settings-force-worker-robot"].value
end

function update_speed_settings()
  -- If it is the first time the mod is loaded, we need to init the trackers for previous settings
  if not storage["speed-settings-first-time"] then
    storage["speed-settings-first-time"] = true
    storage["speed-settings-previous-laboratory-bonus"] = 0.0
    storage["speed-settings-previous-worker-robot-bonus"] = 0.0
  end
  game.speed = settings.global["speed-settings-game"].value
  -- Update all players that have a character associated with them.
  for _, e_player in pairs(game.players) do
    if (e_player.character) then
      update_player(e_player)
    end
  end

  update_player_force()
end

function wait_for_char_creation()
  -- Keep this handler active until all players have a character.
  if #g_playersNoChar > 0 then
    -- For every player on the waiting list.
    for i, e_playerIndex in ipairs(g_playersNoChar) do
      -- Update the player if a character has been created and remove the player from the waiting list.
      if game.players[e_playerIndex].character then
        update_player(game.players[e_playerIndex])
        table.remove(g_playersNoChar, i)
      end
    end
  else
    -- Deactive this handler if the waiting list is empty.
    script.on_event(defines.events.on_tick, nil)
  end
end

-- Update the speed settings on save creation.
script.on_init(update_speed_settings)

-- Apparently, players do not have an associated character on creation. Therefore, I decided to poll for the creation of
-- new characters. I'm not sure if I overlooked something in the API docs, but a more elegant solution will be
-- appreciated (preferably an event that's raised whenever a player character is created).
script.on_event(defines.events.on_player_created, function(p_data)
  table.insert(g_playersNoChar, p_data.player_index)

  script.on_event(defines.events.on_tick, wait_for_char_creation)
end)

-- Update the speed settings after it was changed.
script.on_event(defines.events.on_runtime_mod_setting_changed, update_speed_settings)
