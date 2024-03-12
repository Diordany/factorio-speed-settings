script.on_init(function()
  game.speed = settings.global["speed-settings-factor"].value
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  game.speed = settings.global["speed-settings-factor"].value
end)
