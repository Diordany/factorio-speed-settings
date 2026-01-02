local m_settings = { blockEvent = false }

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

  m_settings.write_settings("player-crafting", p_player.character_crafting_speed_modifier)
  m_settings.write_settings("player-mining", p_player.character_mining_speed_modifier)
  m_settings.write_settings("player-running", p_player.character_running_speed_modifier)
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
    if settings.global["speed-settings-game"].value ~= game.speed then
      m_settings.write_settings("game", game.speed)
    end
  end
end

function m_settings.update_player_modifiers(p_player, p_override)
  if p_override then
    p_player.character_crafting_speed_modifier = settings.global["speed-settings-player-crafting"].value
    p_player.character_mining_speed_modifier = settings.global["speed-settings-player-mining"].value
    p_player.character_running_speed_modifier = settings.global["speed-settings-player-running"].value
  else
    if settings.global["speed-settings-player-crafting"].value ~= p_player.character_crafting_speed_modifier then
      m_settings.write_settings("player-crafting", p_player.character_crafting_speed_modifier)
    end

    if settings.global["speed-settings-player-mining"].value ~= p_player.character_mining_speed_modifier then
      m_settings.write_settings("player-mining", p_player.character_mining_speed_modifier)
    end

    if settings.global["speed-settings-player-running"].value ~= p_player.character_running_speed_modifier then
      m_settings.write_settings("player-running", p_player.character_running_speed_modifier)
    end
  end
end

function m_settings.update_player_force_modifiers(p_override)
  if p_override then
    game.forces["player"].laboratory_speed_modifier = settings.global["speed-settings-force-lab"].value
    game.forces["player"].worker_robots_speed_modifier = settings.global["speed-settings-force-worker-robot"].value
  else
    if settings.global["speed-settings-force-lab"].value ~= game.forces["player"].laboratory_speed_modifier then
      m_settings.write_settings("force-lab", game.forces["player"].laboratory_speed_modifier)
    end

    if settings.global["speed-settings-force-worker-robot"].value ~= game.forces["player"].worker_robots_speed_modifier then
      m_settings.write_settings("force-worker-robot", game.forces["player"].worker_robots_speed_modifier)
    end
  end
end

function m_settings.update_tracking(p_data)
  if p_data.setting == "speed-settings-tracking-interval" then
    script.on_nth_tick(nil)
    script.on_nth_tick(settings.global[p_data.setting].value, track_speed_settings)
  end
end

-- Unfortunately, I see no way of avoiding race conditions with the modding API.. So this could potentially lead to bugs
-- in (hopefully) rare cases.. Suggestions on how to mitigate this further will be appreciated.
function m_settings.write_settings(p_name, p_value)
  m_settings.blockEvent = true
  settings.global["speed-settings-" .. p_name] = { value = p_value }
  m_settings.blockEvent = false
end

return m_settings
