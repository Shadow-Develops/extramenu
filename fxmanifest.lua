fx_version 'cerulean'
games {'gta5'}

real_name 'Extra Menu'
description 'A simple menu to make changing vehicle extras easy with the ability to customize the names extras have within the menu for certain vehicles.'
author 'Shadow Development (www.shadowdevs.com)'
version '3.2.0'
config_version '2.0'
url 'https://github.com/Shadow-Develops/extramenu'

client_scripts {
    '@NativeUI/NativeUI.lua',
    'keys.lua',
    'client/*.lua'
}

server_scripts {
    'keys.lua',
    'server/*.lua'
}

shared_scripts {
    'config.lua',
}

dependency "NativeUI"
