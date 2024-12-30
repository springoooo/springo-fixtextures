fx_version 'cerulean'
game 'gta5'

author 'Springo'
version '1.0.0'
description 'springo_1 | A small script that takes you on a wild ride and assists in fixing your mushy textures!'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts{
    'client/*.lua',
}

server_script {
    'server/*.lua',
}