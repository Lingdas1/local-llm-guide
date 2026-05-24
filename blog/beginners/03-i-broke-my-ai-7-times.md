# I Broke My AI Assistant 7 Times. Here's What I Learned.

> *One medical student's journey from "I want a Jarvis" to accidentally becoming a self-taught DevOps engineer.*

---

## The Beginning: I Almost Bought a Phone for AI

It started with a video.

I was scrolling through Bilibili (think YouTube, but Chinese) and saw something that blew my mind: **the "Doubao Phone."** A smartphone with a built-in AI assistant that could do everything — order food, compare prices across stores, play games for you, book appointments. *"Finally,"* I thought, *"my own Jarvis."*

I almost bought it.

Then the app store drama happened. The big companies blocked Doubao's integrations. The phone stopped being magical. And I moved on to the next viral thing.

**Farming crayfish with AI.**

Yes, that was a real trend. You could deploy an AI agent that managed a virtual crayfish farm. It was hilarious but also... expensive. The token costs were insane, and the AI kept forgetting what happened five minutes ago.

I watched from the sidelines, feeling that familiar itch: *"I want to do this too, but I don't know how."*

Then I found **Hermes Agent** — an open-source AI assistant you can run on your own computer. Free. Private. Controllable.

I searched Bilibili for tutorials. Downloaded the files. And thus began the longest, most frustrating, most educational tech journey of my life.

---

## The Setup: 7 Times I Broke Everything

Here's the honest story of what happened when a medical student with no coding background tried to deploy an AI assistant on his own.

---

### 💥 Crash #1: The Gateway Ghost

**What happened:** I followed the tutorial step by step. Everything installed fine. Then the gateway started disconnecting randomly. Sometimes it worked for hours. Sometimes it died after 10 minutes.

**My reaction:** *"Did I do something wrong? Let me reinstall everything."*

**What actually fixed it:** Restarting the gateway. That's it. Just... restarting it. I had already wiped and reinstalled twice before I figured this out.

**Lesson learned:** Before assuming you broke something, try turning it off and on again. It's cliché because it works.

---

### 💥 Crash #2: Russia's Internet Hates Me

**What happened:** I'm studying in Russia, and the internet here is... let's say *unstable.* The VPN blocks. The DNS dies. The whole building loses connection for hours at a time.

I thought: *"No problem — I'll download some local AI models so my assistant can work offline."*

I spent a weekend downloading models. Got everything set up. It was beautiful.

The next morning, Windows gave me a blue screen of death. When it rebooted, **all my downloaded models were gone.** Corrupted. Unreadable.

**My reaction:** Staring at my screen in disbelief. 20GB of models, gone.

**What actually fixed it:** I switched to a different model loader, redownloaded everything, and took a screenshot of the working config this time.

**Lesson learned:** Backup your configuration **before** you think you need it. Not after.

---

### 💥 Crash #3: The C: Drive Betrayal

**What happened:** Everything installed to C: drive by default. Models, tools, environments — all happily eating up space on my system drive.

One morning, Windows greeted me with: **"Your C: drive is almost full."**

*Panic.*

I decided to move everything to D: drive. I consulted with another AI, got detailed migration instructions, and followed them carefully.

Everything broke.

My assistant couldn't find its files. WSL refused to start. Models were looking for paths that no longer existed.

**My reaction:** *"But... I followed the instructions!"*

**What actually fixed it:** I restored from a backup I thankfully made before starting, and did the migration **one piece at a time** — move WSL first, confirm it works, then move the model loader, confirm it works, then move the assistant.

**Lesson learned:** Never migrate everything at once. One step at a time. And always have a rollback plan.

---

### 💥 Crash #4: The Emulator War

**What happened:** Remember that Android emulator I installed months ago to play mobile games? I had uninstalled it. No big deal, right?

**Wrong.**

After uninstalling the emulator, WSL2 started throwing this error: `HCS_E_SERVICE_NOT_AVAILABLE`. Virtualization broke. Windows Subsystem for Linux stopped working. My AI couldn't run.

It turned out the emulator and WSL2 were fighting over the same virtualization resources. And when I removed the emulator, it took something with it.

**My reaction:** *"I just deleted a game emulator. How does that break my AI assistant?"*

**What actually fixed it:** Multiple restarts, repairing Windows Hyper-V components, and a lot of swearing at my screen.

**Lesson learned:** Your computer's virtualization layer is like a house of cards. Remove one component and the whole thing can collapse. Also: Windows 11 Home edition hides virtualization settings, making this 10x harder to debug.

---

### 💥 Crash #5: The Great OS Migration

**What happened:** After the emulator war, I decided enough was enough. I backed up everything, wiped my computer, and installed a fresh Windows. This time, I would run my AI inside a **virtual machine** with Linux. No more WSL2 headaches.

It worked. For about a day.

**My reaction:** Relief followed by confusion.

**What actually fixed it:** Nothing — it worked fine. I just didn't trust it anymore.

---

### 💥 Crash #6: The Invisible Network Cable

**What happened:** My host computer (Windows) had internet. My VM (Linux) didn't. The network adapter was set to NAT, just like every tutorial said. But the VM couldn't reach the outside world.

I spent hours checking settings, reinstalling network drivers, changing adapter types.

**My reaction:** *"The internet works on my laptop. Why doesn't it work INSIDE my laptop?"*

**What actually fixed it:** The VMware NAT Service and DHCP Service weren't running in Windows. They're supposed to start automatically. They didn't. One click to start them, and everything worked.

**Lesson learned:** When virtualization networking breaks, check the **host services first**, not the VM settings. And `ping` and `curl` are better debugging tools than staring at network icons.

---

### 💥 Crash #7: The Gateway That Lied to Me

**What happened:** I had set up the gateway to auto-start on boot. I checked the configuration. It said `enabled: true`. I was confident.

The next morning, my AI was offline again.

The gateway had "started" but hadn't actually connected. It was running as a process, but doing nothing useful.

**My reaction:** *"But I set it to auto-start! Why is it lying to me?"*

**What actually fixed it:** I wrote a simple script that checks every 5 minutes whether the gateway is actually connected, and restarts it if not. Bulletproof.

**Lesson learned:** "Running" and "working" are two different things. Always add a health check.

---

## The Golden Rule: Don't Touch It

After weeks of crashes, debugging, and existential crises, my setup finally stabilized. Everything worked. The gateway stayed connected. The models loaded correctly. Messages flowed.

And I learned the most important lesson of all:

**If it works, don't touch it.**

You never know which piece of your spaghetti-code setup is holding everything together. That random config file? The one you're not sure does anything? Yeah, it probably does something. Leave it alone.

Every time I thought *"I'll just fix this one small thing,"* I ended up spending 3 hours recovering from the consequences.

---

## What I Want You to Know

I'm telling you all this not because I'm an expert — I'm not. I'm a medical student. I study anatomy, not APIs. I chose this career because I wanted to help people, not because I wanted to debug network services at 2 AM.

But I got it working. And if I can, you can too.

Here's what I learned that actually matters:

| Before I started | After I broke everything 7 times |
|:---|:---|
| "AI is for programmers" | "AI is for anyone stubborn enough to try" |
| "I'll just follow the tutorial" | "I'll follow the tutorial *and* backup first" |
| "It should work perfectly" | "It will break, and that's normal" |
| "I'm not technical enough" | "Being patient matters more than being technical" |

---

## Your Turn

If you're reading this and thinking *"That sounds like me"* — good. You're exactly who I wrote this for.

Start with something small. Expect it to break. Backup before you change anything. And when it finally works, **leave it alone.**

I'm still learning. Every day something new confuses me. But I'm not scared of it anymore — because I've already broken everything that could break.

And the AI is still running.

---

*Hi, I'm Ling. I'm a medical student in China who somehow became a self-taught AI deployer. No CS degree, no big tech job — just a laptop, broken internet, and way too much stubbornness.*

*This is the first of my "Real People, Real AI" series. Star the repo or follow me here to get notified when the next one drops.*

*P.S. — If you've broken your own AI setup in a creative way, leave a comment. Misery loves company. 😄*
