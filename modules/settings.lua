local m_settings = { blockEvent = false }

-- Enable the event after writing the settings.
function m_settings.finish_write_settings()
  m_settings.blockEvent = false
end

function m_settings.init_force_modifiers()
  if settings.global["speed-settings-tracking-override"].value then
    return
  end

  settings.global["speed-settings-force-lab"] = { value = game.forces["player"].laboratory_speed_modifier }
  settings.global["speed-settings-force-worker-robot"] = { value = game.forces["player"].worker_robots_speed_modifier }
end

function m_settings.init_game_modifiers()
  if settings.global["speed-settings-tracking-override"].value then
    return
  end

  settings.global["speed-settings-game"] = { value = game.speed }
end

function m_settings.init_all_players_modifiers()
  if settings.global["speed-settings-tracking-override"].value then
    return
  end

  for _, e_player in pairs(game.players) do
    if (e_player.character) then
      m_settings.init_player_modifiers(e_player)
    end
  end
end

function m_settings.init_player_modifiers(p_player)
  if settings.global["speed-settings-tracking-override"].value then
    return
  end

  m_settings.start_write_settings()

  settings.global["speed-settings-player-crafting"] = { value = p_player.character_crafting_speed_modifier }
  settings.global["speed-settings-player-mining"] = { value = p_player.character_mining_speed_modifier }
  settings.global["speed-settings-player-running"] = { value = p_player.character_running_speed_modifier }

  m_settings.finish_write_settings()
end

-- Disable the event before writing to settings.
function m_settings.start_write_settings()
  m_settings.blockEvent = true
end

function m_settings.update_all(p_override)
  m_settings.update_game_modifiers(p_override)
  m_settings.update_player_force_modifiers(p_override)

  -- Update all players that have a character associated with them.
  for _, e_player in pairs(game.players) do
    if (e_player.character) then
      m_settings.update_player_modifiers(e_player, p_override)
    end
  end
end

function m_settings.update_game_modifiers(p_override)
  if p_override then
    game.speed = settings.global["speed-settings-game"].value
  else
    m_settings.start_write_settings()

    if settings.global["speed-settings-game"].value ~= game.speed then
      settings.global["speed-settings-game"] = { value = game.speed }
    end

    m_settings.finish_write_settings()
  end
end

function m_settings.update_player_modifiers(p_player, p_override)
  if p_override then
    p_player.character_crafting_speed_modifier = settings.global["speed-settings-player-crafting"].value
    p_player.character_mining_speed_modifier = settings.global["speed-settings-player-mining"].value
    p_player.character_running_speed_modifier = settings.global["speed-settings-player-running"].value
  else
    m_settings.start_write_settings()

    if settings.global["speed-settings-player-crafting"].value ~= p_player.character_crafting_speed_modifier then
      settings.global["speed-settings-player-crafting"] = { value = p_player.character_crafting_speed_modifier }
    end

    if settings.global["speed-settings-player-mining"].value ~= p_player.character_mining_speed_modifier then
      settings.global["speed-settings-player-mining"] = { value = p_player.character_mining_speed_modifier }
    end

    if settings.global["speed-settings-player-running"].value ~= p_player.character_running_speed_modifier then
      settings.global["speed-settings-player-running"] = { value = p_player.character_running_speed_modifier }
    end

    m_settings.finish_write_settings()
  end
end

function m_settings.update_player_force_modifiers(p_override)
  if p_override then
    game.forces["player"].laboratory_speed_modifier = settings.global["speed-settings-force-lab"].value
    game.forces["player"].worker_robots_speed_modifier = settings.global["speed-settings-force-worker-robot"].value
  else
    m_settings.start_write_settings()

    if settings.global["speed-settings-force-lab"].value ~= game.forces["player"].laboratory_speed_modifier then
      settings.global["speed-settings-force-lab"] = { value = game.forces["player"].laboratory_speed_modifier }
    end

    if settings.global["speed-settings-force-worker-robot"].value ~= game.forces["player"].worker_robots_speed_modifier then
      settings.global["speed-settings-force-worker-robot"] = {
        value = game.forces["player"]
            .worker_robots_speed_modifier
      }
    end

    m_settings.finish_write_settings()
  end
end

function m_settings.update_tracking(p_data)
  if p_data.setting == "speed-settings-tracking-interval" then
    script.on_nth_tick(nil)
    script.on_nth_tick(settings.global[p_data.setting].value, track_speed_settings)
  end
end

return m_settings
