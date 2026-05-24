     1|# ✅ The Only 3 Rules You Need: My Final Setup
     2|
     3|> *After 7 crashes, 1 OS reinstall, and countless hours of debugging — here's what I wish I knew from day one.*
     4|
     5|---
     6|
     7|## Rule #1: Put Everything in a VM
     8|
     9|This is the single most important decision you can make.
    10|
    11|**What to do:** Install VMware or VirtualBox. Create a Linux virtual machine. Give it 100-200GB of disk space (put it on D: drive or wherever you have space — NOT C:). Install everything — your AI assistant, model runner, gateway — inside this VM.
    12|
    13|**Why it works:**
    14|- Host OS crashes → VM is untouched
    15|- VM breaks → restore a snapshot (30 seconds)
    16|- C: drive fills up → doesn't matter, the VM is on D:
    17|- Emulators, games, random software → the VM doesn't care
    18|- Want to try something risky → take a snapshot first, experiment, rollback if it fails
    19|
    20|**I can't overstate how much pain this would have saved me.** Every single crash I experienced would have been a 30-second snapshot restore instead of a multi-hour debugging session.
    21|
    22|---
    23|
    24|## Rule #2: If It Works, Don't Touch It
    25|
    26|This sounds obvious. It's not. The temptation to "improve" a working setup is the #1 cause of broken setups.
    27|
    28|**What this means in practice:**
    29|- Your AI is running fine? Leave it alone. Don't update, don't migrate, don't "clean up."
    30|- You found a "better" way to configure something? Write it down. Try it on a test VM first. Not your production one.
    31|- Everything's stable? Good. Walk away.
    32|
    33|**But what if something breaks on its own?** Fix *only* that one thing. Don't use the opportunity to "also upgrade this and reorganize that." Fix the broken part, confirm it works, stop.
    34|
    35|---
    36|
    37|## Rule #3: Backup Before You Push
    38|
    39|Before making *any* change:
    40|1. Take a VM snapshot (if using a VM — see Rule #1)
    41|2. Or copy your config files somewhere safe
    42|3. Or at least *write down* what you're about to change
    43|
    44|This takes 30 seconds. It saves hours. Every single time.
    45|
    46|---
    47|
    48|## The One Exception: Health Checks
    49|
    50|The only thing you should add to a stable system is a health check.
    51|
    52|A simple script that pings your AI every few minutes and restarts it if it's unresponsive. This catches the "running but not working" problem without you needing to check manually.
    53|
    54|---
    55|
    56|## My Setup Today (And Why It's Boring)
    57|
    58|I run Hermes Agent inside a Linux VM on VMware. The VM has 150GB on my D: drive. I have a snapshot from the day everything first worked. My health-check script runs every 5 minutes.
    59|
    60|It's been running for weeks without issues.
    61|
    62|I haven't touched a single config file since the last crash.
    63|
    64|And that's exactly how it should be.
    65|
    66|---
    67|
    68|*This is the end of the "7 Crashes" series. If you're just starting your own AI journey: expect it to break, backup before changes, and put everything in a VM. You'll save yourself most of the pain I went through.*
    69|
    70|*Happy building — and remember: if it works, leave it alone. 😄*
    71|
    72|---
    73|
    74|*← Start from the beginning: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
    75|
---

## 💬 Your Turn

Have you run into a similar problem? Or hit a wall I didn't mention?

Drop a comment below — I read every single one. Your experience might help someone else who's stuck on the same thing.

The more we share our screw-ups, the fewer people have to make them. 🤝