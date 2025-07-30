fx_version 'bodacious'
games {'gta5'}

description "A very cool LUA core."
author "Meyr"
version "1.0.0"

ui_page "html/index.html"

files {
	"html/app.js",
	"html/index.html",
	"html/style.css",
	"html/img/money-stack.png",
	"html/img/wallet.png",
	"html/img/fleeca.png"
}

client_scripts {
    'client/functions/*.lua',
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_config.lua',
	'server/functions/*.lua',
	'server/*.lua',
}
