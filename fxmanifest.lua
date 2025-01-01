fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Khalifouille'
description 'Cramtpé'
version '1.0.0'


dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'ox_lib',
}

client_script {
    'client.lua',
}

server_script 'server.lua'