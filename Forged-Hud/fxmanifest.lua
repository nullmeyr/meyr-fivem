fx_version 'cerulean'
game 'gta5'

author 'Hydrogen'
description 'Forged RP Health System'
version '1.0.0'

ui_page {
   "html/dist/index.html"
}

files {
   "html/dist/index.html",
   "html/dist/assets/*.*"
}

client_script {
   'lua/client/*.lua'
}

server_script {
   'lua/server/*.lua'
}

lua54 'yes'
