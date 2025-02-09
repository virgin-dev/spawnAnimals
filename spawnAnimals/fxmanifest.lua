games {'gta5'}

fx_version 'cerulean'

author 'Virgin'
description 'Оптимизированный спавн животных с PolyZone'
version '1.1.0'

shared_script 'config.lua'

client_script {
    '@polyZone/client.lua',
    '@polyZone/CircleZone.lua',
    'client.lua'
}
server_script 'server.lua'
