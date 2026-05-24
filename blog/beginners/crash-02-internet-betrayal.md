# 🌐 Crash #2: When the Internet Betrayed Me

> *"I'll download local models so my AI works offline." Famous last words.*

---

## What Happened

I study in Russia, where the internet is... let's say *adventurous.* VPN blocks, DNS outages, the whole building losing connection for hours.

I thought I was being smart: *"I'll download some local AI models so my assistant can work offline."*

I spent a weekend downloading 20GB of models. Got everything configured perfectly. Tested it. Worked beautifully.

The next morning: **blue screen of death.** When Windows rebooted, every single model file was corrupted. 20GB, gone.

---

## What I Learned

**Backup your configuration *before* you think you need it.** Not after.

That weekend wasn't wasted because I downloaded models — it was wasted because I didn't screenshot or save my working setup. If I had one config file backed up, recovery would have taken 10 minutes instead of 10 hours.

---

## 🛡️ Golden Rule Reminder

> **If it works, don't touch it.** But also: **backup the working state before you try anything new.** A screenshot of your config, an export of your settings, a VM snapshot — any of these would have saved my weekend.

> **Run everything in a VM.** If my models were inside a VM, I could have taken a snapshot after the first successful test. When Windows crashed, the VM would have been untouched. The VM snapshot *is* the backup.

---

*← Full story: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
