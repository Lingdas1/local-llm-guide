     1|# 🔌 Crash #6: The Invisible Network Cable
     2|
     3|> *"The internet works on my laptop. Why doesn't it work INSIDE my laptop?"*
     4|
     5|---
     6|
     7|## What Happened
     8|
     9|My host computer (Windows) had a perfectly good internet connection. My VM (Linux) — sitting right there on the same physical machine — had nothing.
    10|
    11|The network adapter was set to NAT, just like every tutorial said. I checked the settings twice. Three times. I reinstalled VMware network drivers. Changed adapter types. Restarted the VM more times than I count.
    12|
    13|Hours of debugging later, I discovered the issue: **the VMware NAT Service and DHCP Service weren't running in Windows.** They're supposed to start automatically. They didn't.
    14|
    15|Two clicks to start them. Everything worked instantly.
    16|
    17|---
    18|
    19|## What I Learned
    20|
    21|**When virtualization networking breaks, check the host services first, not the VM settings.**
    22|
    23|I was so focused on "what's wrong inside the VM" that I never thought to look at what's running on my host computer. The problem wasn't in Linux — it was in a Windows service I didn't even know existed.
    24|
    25|Also: `ping` and `curl` are way better debugging tools than staring at network icons.
    26|
    27|---
    28|
    29|## 🛡️ Golden Rule Reminder
    30|
    31|> **If it works, don't touch it.** But when it *doesn't* work, start debugging from the outside in. Host → VM → container → app. Not the other way around.
    32|
    33|> **A VM still isolates most problems.** This one wasn't the VM's fault — it was a Windows service issue. But once the service was running, the VM connected and stayed connected. Networking inside the VM has been rock solid since.
    34|
    35|---
    36|
    37|*← Full story: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
    38|
---

## 💬 Your Turn

Have you run into a similar problem? Or hit a wall I didn't mention?

Drop a comment below — I read every single one. Your experience might help someone else who's stuck on the same thing.

The more we share our screw-ups, the fewer people have to make them. 🤝