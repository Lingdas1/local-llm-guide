# 🔌 Crash #6: The Invisible Network Cable

> *"The internet works on my laptop. Why doesn't it work INSIDE my laptop?"*

---

## What Happened

My host computer (Windows) had a perfectly good internet connection. My VM (Linux) — sitting right there on the same physical machine — had nothing.

The network adapter was set to NAT, just like every tutorial said. I checked the settings twice. Three times. I reinstalled VMware network drivers. Changed adapter types. Restarted the VM more times than I count.

Hours of debugging later, I discovered the issue: **the VMware NAT Service and DHCP Service weren't running in Windows.** They're supposed to start automatically. They didn't.

Two clicks to start them. Everything worked instantly.

---

## What I Learned

**When virtualization networking breaks, check the host services first, not the VM settings.**

I was so focused on "what's wrong inside the VM" that I never thought to look at what's running on my host computer. The problem wasn't in Linux — it was in a Windows service I didn't even know existed.

Also: `ping` and `curl` are way better debugging tools than staring at network icons.

---

## 🛡️ Golden Rule Reminder

> **If it works, don't touch it.** But when it *doesn't* work, start debugging from the outside in. Host → VM → container → app. Not the other way around.

> **A VM still isolates most problems.** This one wasn't the VM's fault — it was a Windows service issue. But once the service was running, the VM connected and stayed connected. Networking inside the VM has been rock solid since.

---

*← Full story: [I Broke My AI Assistant 7 Times](/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le)*
