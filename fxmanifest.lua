fx_version 'cerulean'
game 'gta5'

name 'Extra Menu'
description 'A simple menu to make changing vehicle extras easy with the ability to customize the names extras have within the menu for certain vehicles.'
author 'Shadow Development (www.shadowdevs.com)'
version 'v2.0.0'
url 'https://github.com/Shadow-Develops/extramenu'

client_scripts {
    '@NativeUI/NativeUI.lua',
    'keys.lua',
    'client/menu.lua'
}

server_scripts {
    'keys.lua',
}

shared_scripts {
    'config.lua',
}

dependency "NativeUI"
