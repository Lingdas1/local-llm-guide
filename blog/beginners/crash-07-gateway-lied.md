     1|# 🤥 Crash #7: The Gateway That Lied to Me
     2|
     3|> *"I set it to auto-start. I checked the config. It said enabled. It lied."*
     4|
     5|---
     6|
     7|## What Happened
     8|
     9|After fixing the networking issue, I wanted to make sure my AI assistant would survive a reboot. I configured the gateway to auto-start on boot. Triple-checked the config: `enabled: true`. I was confident.
    10|
    11|The next morning, my AI was offline again.
    12|
    13|The gateway was **running** — the process was alive, the logs showed no errors — but it wasn't actually **connected** to the messaging platform. It was doing nothing useful while pretending everything was fine.
    14|
    15|**The fix:** I wrote a simple health-check script that tests the connection every 5 minutes and restarts the gateway if it's not responding.
    16|
    17|---
    18|
    19|## What I Learned
    20|
    21|**"Running" and "working" are two different things.**
    22|
    23|A process can be alive but useless. A service can start without actually connecting. A config can say "enabled" while the underlying connection failed silently.
    24|
    25|Always add a health check. Something simple: `curl localhost:port` → if it fails, restart the service. It catches 90% of the "it should work but it doesn't" problems.
    26|
    27|---
    28|
    29|## 🛡️ Golden Rule Reminder
    30|
    31|> **If it works, don't touch it.** And even when it works, **add a health check** so you know the moment it stops working. A 5-second automated check can save you hours of downtime.
    32|
    33|> **A VM makes recovery instant.** With a VM snapshot, if your gateway breaks beyond repair, you can roll back to a known-good state in 30 seconds — no reinstallation, no reconfiguration.
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