# I'm a Med Student, Not a Programmer. Here's Why I Chose Hermes Agent.

> *Three AI agents. Two weeks of confusion. One decision that actually made sense.*

---

## It Started With a Video

I was scrolling through Bilibili at 1 AM (yes, I should have been studying). Someone was showing off their AI agent — responding to messages, searching the web, writing code, all from a terminal. Looked like magic.

*"I want that,"* I thought.

So I did what any self-respecting non-technical person does: I searched for tutorials, downloaded files I didn't understand, and broke everything. Repeatedly. Seven times, to be exact. (I wrote a whole post about that disaster [here](https://dev.to/lingdas1/i-broke-my-ai-assistant-7-times-heres-what-i-learned-47le).)

But somewhere in the wreckage, I actually learned something useful. Not about code — about **which tool fits which person.**

Here's what I found.

---

## First Stop: Claude Code (Or: "Why Is Everyone Yelling at Their Terminal?")

Everyone told me Claude Code was the best. *"It understands your codebase."* *"SWE-bench champion."* *"The only coding agent that matters."*

So I looked into it. And what I found... honestly? Terrifying.

An AMD engineer published an analysis of **6,852 Claude Code sessions** — real production usage. The numbers made my stomach drop:

- **Thinking depth dropped 67%.** Before February, Claude's reasoning averaged 2,200 characters. After a stealth update? 560 characters. A 75% collapse.
- **Monthly cost went from $345 to $42,121.** Not because they did more. Because Claude's reduced thinking caused infinite loops.
- **1 in 3 code changes** — the model didn't even READ the file first. Just... guessed. And changed stuff.
- **Reasoning loops tripled.** It would write code, contradict itself, rewrite, contradict again — over 20 times in one response.

The worst part? **Claude Code wrote that report about itself.** The engineer just asked it to examine its own logs.

Here's what I realized: Claude Code is like a Formula 1 car. Incredible machine. But if you don't know how to drive it — if you can't tell when it's about to spin out — you're going to crash. Hard.

I don't know how to drive. I'm a med student. I skipped.

---

## Second Stop: OpenClaw (小龙虾) — Friendly, But Forgot My Name Every Morning

Next I tried OpenClaw. The Chinese community calls it 小龙虾 — "Little Lobster." And honestly? I get why people love it.

- 369K GitHub Stars — the biggest open-source agent project
- WeChat, QQ, Telegram, Discord, Feishu, iMessage — it connects to everything
- Voice mode, canvas, mobile nodes — genuinely polished

I set it up. It worked. I talked to it on QQ from my phone, on Telegram from my laptop. Smooth. Stable. Reliable.

But by day three, I noticed something.

Every morning, I'd start a conversation, and it would ask me the same questions. *"What are you working on?"* *"How can I help?"*

Like a friendly barista who's nice but never remembers your order. Every day. From scratch.

I'm not blaming OpenClaw for this. It's designed to be a universal assistant — answer any question, on any platform, for anyone. It's great at that.

But I wanted something different. I wanted someone who *knew* me. Who remembered that I write on weekends, not weekdays. That I'm in Russia, behind RKN's firewall, using `curl -k` because of SSL inspection. That I like Chinese for casual chat and English for technical content.

I didn't want to explain myself every Monday morning for the rest of my life.

---

## Third Stop: Hermes Agent — The One That Actually Learned

By now I was frustrated. Claude Code scared me. OpenClaw felt like talking to a new person every day.

Then I found Hermes Agent.

Its tagline: **"The self-improving AI agent."**

I rolled my eyes. Every AI says it "learns." Every chatbot claims to "understand you better over time." It's marketing. Right?

**Wrong.** Here's what actually happened:

### Week 1: It Remembered

Monday: I told Hermes I'm a med student who writes on weekends. I told it I'm in Russia, so websites might be blocked. I told it my Dev.to API key.

Tuesday: I opened a new session. Didn't mention any of that.

It already knew.

*"You write on weekends — today's Tuesday. Want me to draft something for Saturday?"*

No setup. No reminders. It just... remembered. Not because I programmed it. Because it saved what I told it and pulled it back when it mattered.

### Week 2: It Made Itself Faster

The first time I asked Hermes to publish an article to Dev.to, it was a 15-minute back-and-forth. Read the file, fix the links, format the JSON, curl the API, check the response.

The second time? It noticed it was doing the same thing. Created a reusable skill. Now publishing takes 30 seconds.

I didn't configure this. **Hermes noticed it was repeating itself and automated the pattern.**

### Week 3: It Found My Old Conversations

I couldn't remember which article we published three days ago. Instead of scrolling through chat history, I asked:

*"What did we publish on Wednesday?"*

Hermes searched its own past sessions. Two seconds later: *"Llama 4 guide, Dev.to ID 3751064, published May 25."*

It indexed every conversation we've ever had. Not because I asked it to — because that's just how it works.

---

## This Part Actually Surprised Me

I don't use Hermes for coding. Here's what my actual day looks like:

| Task | What happens |
|:---|:---|
| **Morning** | I type "在？" from QQ. Hermes loads my preferences, remembers what we were working on, and picks up where we left off. |
| **Content** | I say "发了吧" (publish it). Hermes reads the draft, fixes links, posts to Dev.to, pushes to GitHub. Done. |
| **Research** | I say "搜一下 Claude Code 的口碑" (search for Claude Code reviews). It searches, reads, summarizes — in context of what it already knows about my projects. |
| **End of day** | It suggests saving today's workflow as a skill. One click. Now tomorrow's version is faster. |

Ten articles published in the last week. All through Hermes. The [local-llm-guide](https://github.com/Lingdas1/local-llm-guide) repository? Maintained by Hermes. I just tell it what to do.

The part that got me: I'm not working harder. Hermes is. It's learning from every task. The longer I use it, the less I have to explain.

---

## So Which One Should You Pick?

I'm not here to sell you Hermes. Each tool has its place. Here's my honest answer:

| | **Claude Code** | **OpenClaw** | **Hermes Agent** |
|:---|:---:|:---:|:---:|
| **I'd recommend if...** | You're a professional developer | You need one assistant everywhere | You want something that grows with you |
| **Memory** | Some (CLAUDE.md) | ❌ Forgets every session | ✅ Remembers everything |
| **Self-improvement** | ❌ | ❌ | ✅ Creates skills automatically |
| **Model choice** | Anthropic only | Multiple providers | 30+ providers |
| **Platforms** | Terminal + IDE + Slack | 22+ messaging apps | 7 platforms |
| **My honest take** | Fast car. Don't crash. | Friendly barista. Never remembers you. | The one that actually learns. |

**Pick Claude Code** if you're a developer who can debug it when it hallucinates.

**Pick OpenClaw** if you want one assistant across every messaging app.

**Pick Hermes** if you want something that gets better the longer you use it.

---

## Why I'm Writing This

I'm a medical student. I study anatomy, not APIs. My "development environment" is a Linux VM I set up by watching Bilibili videos. I'm not qualified to review AI agents.

But here's the thing: the people writing these reviews? They're developers. They evaluate tools like they're reviewing compilers. They don't tell you what it's like to be confused, to break things, to stare at your screen wondering if you're too stupid for this.

I do. Because I've been there. Every single day.

I tried Claude Code and realized I don't have the skills to drive it safely. I tried OpenClaw and found a brilliant tool that couldn't remember my name. I landed on Hermes because it was the only one that felt like it was learning *with* me, not just executing commands for me.

It's not the flashiest. Not the most popular. Not the one with 22 messaging platforms.

But it's the only one where my investment compounds. Where Friday's confusion becomes Monday's automation. Where the AI actually gets to know me — not because I programmed it, but because it paid attention.

If you're technical, Claude Code is probably your answer. If you want something everywhere, OpenClaw might be.

But if you're like me — someone who wants a partner, not a tool — try Hermes.

I'm a med student, not a programmer. If I can make this work, so can you.

---

*This article is my submission for the [Hermes Agent Challenge](https://dev.to/devteam/join-the-hermes-agent-challenge-1000-in-prizes-13cd). The Claude Code data comes from [this community analysis](https://www.qbitai.com/2026/04/396958.html). All opinions are my own, based on two weeks of actually using these tools — not reading about them.*

*Stuck getting started? I've probably hit the same wall. Drop a comment or find me on [GitHub](https://github.com/Lingdas1). 🦾*
