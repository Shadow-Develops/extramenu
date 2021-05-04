resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

name 'Extra Menu'
description 'A simple menu to make changing vehicle extras easy with the ability to customize the names extras have within the menu for certain vehicles.'
author 'Agent Squad Productions (www.agentsquad.org)'
version 'v1.0.0'
url 'https://github.com/Agent-Squad-Productions/extramenu'

client_scripts {
    "@NativeUI/NativeUI.lua",
    "config.lua",
    "client/menu.lua"
}

server_scripts {
    "config.lua",
}

dependency "NativeUI"