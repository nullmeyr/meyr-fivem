# Description
This a chat moderation tool I wrote to help a server protect against people trolling in chat.

What sets this script apart from anything else is that it uses artificial intelligence--it will assess the risk profile of a message and if it's considered "high-risk" it will either ban the player or kick them. 

The only downside is that Azure at the time would ratelimit the script because of loads of chat messages, my plan for the time was to run the messages through a list of offensive terms. If it passed, it would return otherwise it would hit Azure and test the message.

Flow: 

Client (`message`) -> Server(hit Azure with `message`) -> (Server Promise Resolve High Risk/Low Risk) -> Client (if high-risk then ban / else return)  

# Screenshots (A cool webhook showing the exact risk profile)
![image0](https://github.com/user-attachments/assets/9527ff67-8093-47ee-ba1b-49ad49bf48ee)
