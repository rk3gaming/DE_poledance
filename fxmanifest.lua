fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/index.css',
    'web/assets/index.js'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'src/server/*.lua'
}

client_scripts {
    'src/client/*.lua'
}

lua54 'yes'