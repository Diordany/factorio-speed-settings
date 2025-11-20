local g_playersNoChar = {}

function starts_with(p_string, p_sub)
  return string.sub(p_string, 1, string.len(p_sub)) == p_sub
end

function update_player(p_player)
  p_player.character_crafting_speed_modifier = settings.global["speed-settings-player-crafting"].value
  p_player.character_mining_speed_modifier = settings.global["speed-settings-player-mining"].value
  p_player.character_running_speed_modifier = settings.global["speed-settings-player-running"].value
end

function update_bonus(p_modifier, p_tracker, p_new_bonus)
  local target = p_modifier + p_new_bonus - p_tracker.prevBonus + p_tracker.excess
  p_tracker.excess = math.min(0.0, target + 1.0)
  p_tracker.prevBonus = p_new_bonus
  return math.max(-1.0, target)
end

function update_player_force()
  game.forces["player"].laboratory_speed_modifier = update_bonus(game.forces["player"].laboratory_speed_modifier, storage.speedSettings.labs, settings.global["speed-settings-force-lab"].value)
  game.forces["player"].worker_robots_speed_modifier = update_bonus(game.forces["player"].worker_robots_speed_modifier, storage.speedSettings.bots, settings.global["speed-settings-force-worker-robot"].value)
end

function update_speed_settings(p_data)
  if p_data then
    if not starts_with(p_data.setting, "speed-settings-") then
      return
    end
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

-- Initialize the trackers and update the speed settings on save creation.
script.on_init(function()
  storage.speedSettings = {
    labs = {
      prevBonus = 0.0,
      excess = 0.0,
    },
    bots = {
      prevBonus = 0.0,
      excess = 0.0,
    },
  }
  update_speed_settings()
end)


-- Apparently, players do not have an associated character on creation. Therefore, I decided to poll for the creation of
-- new characters. I'm not sure if I overlooked something in the API docs, but a more elegant solution will be
-- appreciated (preferably an event that's raised whenever a player character is created).
script.on_event(defines.events.on_player_created, function(p_data)
  table.insert(g_playersNoChar, p_data.player_index)

  script.on_event(defines.events.on_tick, wait_for_char_creation)
end)

-- Update the speed settings after it was changed.
script.on_event(defines.events.on_runtime_mod_setting_changed, update_speed_settings)
