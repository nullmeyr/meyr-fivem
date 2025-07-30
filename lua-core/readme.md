Overview:
This server base, specifically designed to handle/store player money and playtime.
Since each in game day is 48 IRL minutes, each in game day the player will earn $250. The more playtime, the more money. 

Commands:
- /addmoney [id] [bank/cash] [amount] | Admin
- /setmoney [id] [bank/cash] [amount] | Admin
- /removemoney [id] [bank/cash] [amount] | Admin
- /transfermoney [id] [bank/cash] [amount] | User

I made this a while back when I used to write all my stuff in LUA, the code is very modular but not *as* modular as I could make it. Hence, why I started something newer in typescript :) 