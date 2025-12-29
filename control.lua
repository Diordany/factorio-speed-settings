local g_playersNoChar = {}

function on_settings_changed(p_data)
  if p_data then
    update_tracking(p_data)

    if not starts_with(p_data.setting, "speed-settings-") then
      return
    end
  end

  update_speed_settings(true)
end

function starts_with(p_string, p_sub)
  return string.sub(p_string, 1, string.len(p_sub)) == p_sub
end

function track_speed_settings()
  update_speed_settings(settings.global["speed-settings-tracking-override"].value)
end

function update_game(p_override)
  if p_override then
    game.speed = settings.global["speed-settings-game"].value
  else
    if settings.global["speed-settings-game"].value ~= game.speed then
      settings.global["speed-settings-game"] = { value = game.speed }
    end
  end
end

function update_player(p_player, p_override)
  if p_override then
    p_player.character_crafting_speed_modifier = settings.global["speed-settings-player-crafting"].value
    p_player.character_mining_speed_modifier = settings.global["speed-settings-player-mining"].value
    p_player.character_running_speed_modifier = settings.global["speed-settings-player-running"].value
  else
    if settings.global["speed-settings-player-crafting"].value ~= p_player.character_crafting_speed_modifier then
      settings.global["speed-settings-player-crafting"] = { value = p_player.character_crafting_speed_modifier }
    end

    if settings.global["speed-settings-player-mining"].value ~= p_player.character_mining_speed_modifier then
      settings.global["speed-settings-player-mining"] = { value = p_player.character_mining_speed_modifier }
    end

    if settings.global["speed-settings-player-running"].value ~= p_player.character_running_speed_modifier then
      settings.global["speed-settings-player-running"] = { value = p_player.character_running_speed_modifier }
    end
  end
end

function update_player_force(p_override)
  if p_override then
    game.forces["player"].laboratory_speed_modifier = settings.global["speed-settings-force-lab"].value
    game.forces["player"].worker_robots_speed_modifier = settings.global["speed-settings-force-worker-robot"].value
  else
    if settings.global["speed-settings-force-lab"].value ~= game.forces["player"].laboratory_speed_modifier then
      settings.global["speed-settings-force-lab"] = { value = game.forces["player"].laboratory_speed_modifier }
    end

    if settings.global["speed-settings-force-worker-robot"].value ~= game.forces["player"].worker_robots_speed_modifier then
      settings.global["speed-settings-force-worker-robot"] = {
        value = game.forces["player"]
            .worker_robots_speed_modifier
      }
    end
  end
end

function update_speed_settings(p_override)
  update_game(p_override)
  update_player_force(p_override)

  -- Update all players that have a character associated with them.
  for _, e_player in pairs(game.players) do
    if (e_player.character) then
      update_player(e_player, p_override)
    end
  end
end

function update_tracking(p_data)
  if p_data.setting == "speed-settings-tracking-interval" then
    script.on_nth_tick(nil)
    script.on_nth_tick(settings.global[p_data.setting].value, track_speed_settings)
  end
end

function wait_for_char_creation()
  -- Keep this handler active until all players have a character.
  if #g_playersNoChar > 0 then
    -- For every player on the waiting list.
    for i, e_playerIndex in ipairs(g_playersNoChar) do
      -- Update the player if a character has been created and remove the player from the waiting list.
      if game.players[e_playerIndex].character then
        update_player(game.players[e_playerIndex], true)
        table.remove(g_playersNoChar, i)
      end
    end
  else
    -- Deactive this handler if the waiting list is empty.
    script.on_event(defines.events.on_tick, nil)
  end
end

-- Update the speed settings on save creation.
script.on_init(on_settings_changed)

-- Apparently, players do not have an associated character on creation. Therefore, I decided to poll for the creation of
-- new characters. I'm not sure if I overlooked something in the API docs, but a more elegant solution will be
-- appreciated (preferably an event that's raised whenever a player character is created).
script.on_event(defines.events.on_player_created, function(p_data)
  table.insert(g_playersNoChar, p_data.player_index)

  script.on_event(defines.events.on_tick, wait_for_char_creation)
end)

-- Register event handlers.
script.on_nth_tick(settings.global["speed-settings-tracking-interval"].value, track_speed_settings)
script.on_event(defines.events.on_runtime_mod_setting_changed, on_settings_changed)
