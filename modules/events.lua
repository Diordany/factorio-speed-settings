local m_events = {}

local m_settings = require("__speed-settings__/modules/settings")
local m_string = require("__speed-settings__/modules/string")

local g_playersNoChar = {}

-- Tracking loop.
function track_speed_settings_cb()
  m_settings.update_all(settings.global["speed-settings-tracking-override"].value)
end

function on_init_cb()
  -- According to the docs, on_runtime_mod_setting_changed won't be triggered during docs. It should be safe to modify
  -- the settings here.
  m_settings.init_game_modifiers()
  m_settings.init_force_modifiers()
  m_settings.init_all_players_modifiers()
end

-- Apparently, players do not have an associated character on creation. Therefore, I decided to poll for the creation of
-- new characters. I'm not sure if I overlooked something in the API docs, but a more elegant solution will be
-- appreciated (preferably an event that's raised whenever a player character is created).
function on_player_created_cb(p_data)
  table.insert(g_playersNoChar, p_data.player_index)

  script.on_event(defines.events.on_tick, wait_for_char_creation)
end

function on_settings_changed_cb(p_data)
  if m_settings.blockEvent then
    return
  end

  if p_data then
    m_settings.update_tracking(p_data)

    if not m_string.starts_with(p_data.setting, "speed-settings-") then
      return
    end
  end

  m_settings.update_all(true)
end

function m_events.init()
  script.on_init(on_init_cb)

  script.on_event(defines.events.on_player_created, on_player_created_cb)
  script.on_event(defines.events.on_runtime_mod_setting_changed, on_settings_changed_cb)

  local interval = settings.global["speed-settings-tracking-interval"].value

  script.on_nth_tick(interval, track_speed_settings_cb)
end

function wait_for_char_creation_cb()
  -- Keep this handler active until all players have a character.
  if #g_playersNoChar > 0 then
    -- For every player on the waiting list.
    for i, e_playerIndex in ipairs(g_playersNoChar) do
      -- Update the player if a character has been created and remove the player from the waiting list.
      if game.players[e_playerIndex].character then
        m_settings.init_player_modifiers(game.players[e_playerIndex])
        table.remove(g_playersNoChar, i)
      end
    end
  else
    -- Deactive this handler if the waiting list is empty.
    script.on_event(defines.events.on_tick, nil)
  end
end

return m_events
