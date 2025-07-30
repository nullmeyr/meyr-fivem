fx_version 'cerulean'
name 'Rewards'
author 'Tellurium'
game 'gta5'
lua54 'yes'
dependency 'ox_target'


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/assets/**/*.js',
    'html/assets/**/*.css',
    'html/assets/**/*.*'
}

shared_script { 'config.lua', '@ox_lib/init.lua'}

server_script {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

client_script 'client/*.lua'