data.raw["lab"]["lab"].researching_speed = data.raw["lab"]["lab"].researching_speed * settings.startup["speed-settings-lab"].value
if mods["space-age"] then
    data.raw["lab"]["biolab"].researching_speed = data.raw["lab"]["biolab"].researching_speed * settings.startup["speed-settings-lab"].value
end

data.raw["construction-robot"]["construction-robot"].speed = data.raw["construction-robot"]["construction-robot"].speed * settings.startup["speed-settings-worker-robot"].value
data.raw["logistic-robot"]["logistic-robot"].speed = data.raw["logistic-robot"]["logistic-robot"].speed * settings.startup["speed-settings-worker-robot"].value

data.raw["character"]["character"].crafting_speed = settings.startup["speed-settings-player-crafting"].value
data.raw["character"]["character"].mining_speed = data.raw["character"]["character"].mining_speed * settings.startup["speed-settings-player-mining"].value
data.raw["character"]["character"].running_speed = data.raw["character"]["character"].running_speed * settings.startup["speed-settings-player-running"].value