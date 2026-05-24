# ✅ The Only 3 Rules You Need: My Final Setup

> *After 7 crashes, 1 OS reinstall, and countless hours of debugging — here's what I wish I knew from day one.*

---

## Rule #1: Put Everything in a VM

This is the single most important decision you can make.

**What to do:** Install VMware or VirtualBox. Create a Linux virtual machine. Give it 100-200GB of disk space (put it on D: drive or wherever you have space — NOT C:). Install everything — your AI assistant, model runner, gateway — inside this VM.

**Why it works:**
- Host OS crashes → VM is untouched
- VM breaks → restore a snapshot (30 seconds)
- C: drive fills up → doesn't matter, the VM is on D:
- Emulators, games, random software → the VM doesn't care
- Want to try something risky → take a snapshot first, experiment, rollback if it fails

**I can't overstate how much pain this would have saved me.** Every single crash I experienced would have been a 30-second snapshot restore instead of a multi-hour debugging session.

---

## Rule #2: If It Works, Don't Touch It

This sounds obvious. It's not. The temptation to "improve" a working setup is the #1 cause of broken setups.

**What this means in practice:**
- Your AI is running fine? Leave it alone. Don't update, don't migrate, don't "clean up."
- You found a "better" way to configure something? Write it down. Try it on a test VM first. Not your production one.
- Everything's stable? Good. Walk away.

**But what if something breaks on its own?** Fix *only* that one thing. Don't use the opportunity to "also upgrade this and reorganize that." Fix the broken part, confirm it works, stop.

---

## Rule #3: Backup Before You Push

Before making *any* change:
1. Take a VM snapshot (if using a VM — see Rule #1)
2. Or copy your config files somewhere safe
3. Or at least *write down* what you're about to change

This takes 30 seconds. It saves hours. Every single time.

---

## The One Exception: Health Checks

The only thing you should add to a stable system is a health check.

A simple script that pings your AI every few minutes and restarts it if it's unresponsive. This catches the "running but not working" problem without you needing to check manually.

---

## My Setup Today (And Why It's Boring)

I run Hermes Agent inside a Linux VM on VMware. The VM has 150GB on my D: drive. I have a snapshot from the day everything first worked. My health-check script runs every 5 minutes.

It's been running for weeks without issues.

I haven't touched a single config file since the last crash.

And that's exactly how it should be.

---

*This is the end of the "7 Crashes" series. If you're just starting your own AI journey: expect it to break, backup before changes, and put everything in a VM. You'll save yourself most of the pain I went through.*

*Happy building — and remember: if it works, leave it alone. 😄*

---

*← Start from the beginning: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
