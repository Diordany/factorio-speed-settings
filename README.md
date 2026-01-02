# Speed Settings II

![thumbnail](thumbnail.png)

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

Adds the ability to configure the following speeds in the mod settings:
- Game speed
- Player running speed
- Player mining speed
- player crafting speed
- worker robot speed
- research lab speed.

# Installation

You can install this mod through the built-in modloader of Factorio under the name "Speed Settings". Alternatively, you can manually install it using git or by downloading the source code in .zip format.

***Mod folder (Windows):*** `%appdata%\Factorio\mods`

***Mod folder (Mac OS X):*** `~/Library/Application\ Support/factorio/mods`

***Mod folder (Linux):*** `~/.factorio/mods`

## Installation with Git

```
cd <path to factorio mods>
git clone https://github.com/Diordany/factorio-speed-settings.git speed-settings_2.0.0
```

## Installation from ZIP

Just save the **.zip** file to the mod directory of Factorio as `speed-settings_2.0.0.zip` (or leave the name as it is if downloading from the releases page).

# Usage

Open the mod settings and you'll be able to change the speed settings.

**WARNING:** keep in mind that a higher game speed will be more demanding for your system!

![Settings](doc/img/settings.png)

The following settings can be changed:

**Override Mode**

Forces the speed modifiers to take the values entered through the settings. This means that the mod attempts to keep the same values for the modifiers, even if it should be affected by research or other mods/sources. Also use this if you want the speed modifiers to be applied immediately for a new save.

**Tracking Interval**

The interval in ticks for tracking. The mod will check the modifiers again after the amount of ticks has passed.

**Game Speed**

Sets the game speed factor. The minimum value is 0.1.

**Additional Player Running Speed**

Give the player additional running speed. The minimum value is -1.0 (corresponding to -100 % of the base speed).

**Additional Player Mining Speed**

Give the player additional mining speed. The minimum value is -1.0 (corresponding to -100 % of the base speed).

**Additional Player Running Speed**

Give the player additional running speed. The minimum value is -1.0 (corresponding to -100 % of the base speed).

**Additional Worker Robot Speed**

Set additional speed for the worker robots that belong to the player force. The minimum value is -1.0 (corresponding to -100 % of the base speed).

**Additional Lab Speed**

Set additional speed for the research labs that belong to the player force. The minimum value is -1.0 (corresponding to -100 % of the base speed).