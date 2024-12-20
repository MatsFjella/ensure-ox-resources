--[[ 
    ox_fuel - A modern FiveM fuel system for ox_core
    Originally based on LegacyFuel by InZidiuZ
    Rewritten for ox_core compatibility
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ox_fuel'
author 'Original: InZidiuZ, ox_core adaptation: Fjella / Ensure'
version '1.0.0'
repository 'https://github.com/overextended/ox_fuel'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'ox_lib',
    'ox_core',
    'oxmysql'
}

provides {
    'fuel_system'
}
