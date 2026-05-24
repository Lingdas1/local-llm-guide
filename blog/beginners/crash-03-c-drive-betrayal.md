# 💾 Crash #3: The C: Drive Betrayal

> *"I followed the migration instructions perfectly. Everything broke."*

---

## What Happened

Windows greeted me one morning with the dreaded: **"Your C: drive is almost full."**

Models, tools, environments — everything was eating up space on my system drive. I needed to move it all to D: drive.

I asked another AI for detailed migration steps. Followed them to the letter. Confidently hit Enter.

My AI assistant couldn't find its files. WSL refused to start. Models looked for paths that no longer existed. **Everything broke at once.**

---

## What I Learned

**Never migrate everything at once.** Move one piece → test → confirm it works → move the next piece.

I made the classic mistake: I tried to fix everything in one go. Migration paths, permissions, symbolic links — each one is a potential failure point. Do them one at a time so you know exactly which step broke what.

Also: **always have a rollback plan.** I got lucky that I had a backup. Without it, I would have been rebuilding from scratch.

---

## 🛡️ Golden Rule Reminder

> **If it works, don't touch it.** But if you *must* move things, do it one step at a time. Test after every single change.

> **Run everything in a VM with 100-200GB of space.** If my AI was inside a VM on D: drive, I would never have had the C: drive problem in the first place. The VM file lives wherever you put it — no migration needed.

---

*← Full story: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
