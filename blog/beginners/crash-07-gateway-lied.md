# 🤥 Crash #7: The Gateway That Lied to Me

> *"I set it to auto-start. I checked the config. It said enabled. It lied."*

---

## What Happened

After fixing the networking issue, I wanted to make sure my AI assistant would survive a reboot. I configured the gateway to auto-start on boot. Triple-checked the config: `enabled: true`. I was confident.

The next morning, my AI was offline again.

The gateway was **running** — the process was alive, the logs showed no errors — but it wasn't actually **connected** to the messaging platform. It was doing nothing useful while pretending everything was fine.

**The fix:** I wrote a simple health-check script that tests the connection every 5 minutes and restarts the gateway if it's not responding.

---

## What I Learned

**"Running" and "working" are two different things.**

A process can be alive but useless. A service can start without actually connecting. A config can say "enabled" while the underlying connection failed silently.

Always add a health check. Something simple: `curl localhost:port` → if it fails, restart the service. It catches 90% of the "it should work but it doesn't" problems.

---

## 🛡️ Golden Rule Reminder

> **If it works, don't touch it.** And even when it works, **add a health check** so you know the moment it stops working. A 5-second automated check can save you hours of downtime.

> **A VM makes recovery instant.** With a VM snapshot, if your gateway breaks beyond repair, you can roll back to a known-good state in 30 seconds — no reinstallation, no reconfiguration.

---

*← Full story: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
