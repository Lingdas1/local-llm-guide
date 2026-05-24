     1|# 💾 Crash #3: The C: Drive Betrayal
     2|
     3|> *"I followed the migration instructions perfectly. Everything broke."*
     4|
     5|---
     6|
     7|## What Happened
     8|
     9|Windows greeted me one morning with the dreaded: **"Your C: drive is almost full."**
    10|
    11|Models, tools, environments — everything was eating up space on my system drive. I needed to move it all to D: drive.
    12|
    13|I asked another AI for detailed migration steps. Followed them to the letter. Confidently hit Enter.
    14|
    15|My AI assistant couldn't find its files. WSL refused to start. Models looked for paths that no longer existed. **Everything broke at once.**
    16|
    17|---
    18|
    19|## What I Learned
    20|
    21|**Never migrate everything at once.** Move one piece → test → confirm it works → move the next piece.
    22|
    23|I made the classic mistake: I tried to fix everything in one go. Migration paths, permissions, symbolic links — each one is a potential failure point. Do them one at a time so you know exactly which step broke what.
    24|
    25|Also: **always have a rollback plan.** I got lucky that I had a backup. Without it, I would have been rebuilding from scratch.
    26|
    27|---
    28|
    29|## 🛡️ Golden Rule Reminder
    30|
    31|> **If it works, don't touch it.** But if you *must* move things, do it one step at a time. Test after every single change.
    32|
    33|> **Run everything in a VM with 100-200GB of space.** If my AI was inside a VM on D: drive, I would never have had the C: drive problem in the first place. The VM file lives wherever you put it — no migration needed.
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