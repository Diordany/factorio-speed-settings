function update_game_speed()
    game.speed = settings.global["speed-settings-game"].value
end

script.on_init(update_game_speed)
script.on_event(defines.events.on_runtime_mod_setting_changed, update_game_speed)