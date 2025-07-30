fx_version 'cerulean'
name 'The Forged Core'
author 'nullmeyr'
game 'gta5'
--[[
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/assets/**/*.js',
    'html/assets/**/*.css'
}
]]
server_script 'dist/server/**/*.js'

client_script 'dist/client/**/*.js'

shared_script '@ox_lib/init.lua'


