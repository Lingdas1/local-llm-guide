# 🔍 本周 AI 工具与资源精选（第 1 期 · 原型）

> **策展人视角：** 我是 Ling，一个自学医学生。以下每个推荐我都亲自看过/试过，附上我的真实评价。
> **阅读指南：** 按你的工具栈翻对应文件夹 🗂️

---

## 📁 Hermes 能用

*这个分类下的工具/文章，Hermes Agent 用户可以直接用或参考。*

### 🛠️ CodeGraph — 给 AI 编程助手装个「代码大脑」
**类型：** MCP Server / 工具  
**安装：** `npm i -g @colbymchenry/codegraph && codegraph install --yes --target=hermes`  
**仓库：** [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) ⭐21k

**我的推荐语：**

如果你让 Hermes 帮你写代码，最大的痛点是什么？——它要花大量时间 `grep`、`find`、逐文件读，才能理解你的项目结构。

CodeGraph 做了一件事：**提前把你的代码库索引成知识图谱**。符号关系、调用链、框架路由——全提前算好。Hermes 接上它之后，理解一个项目从"读几十个文件"变成"查几个图"——官方数据是 **工具调用减少 71%**。

我自己装了，安装体验极顺——一条命令自动配置，Hermes 的 `config.yaml` 被自动写入 MCP server 配置。零手动操作。

**适合谁读：** A类（开发者），经常用 AI 写代码的

---

### 📖 Hermes Agent MCP 集成完整指南
**类型：** 教程文章  
**链接：** [lushbinary.com — Hermes Agent MCP Integration Guide](https://lushbinary.com/blog/hermes-agent-mcp-integration-complete-guide/)

**我的推荐语：**

Hermes 的 MCP 功能文档偏简洁，这篇第三方教程补了很多细节——从连接 GitHub MCP server 到工具过滤、OAuth 设置，手把手那种。如果你装了 CodeGraph 或者想连其他 MCP server，这篇可以当操作手册。

**适合谁读：** A类，需要扩展 Hermes 工具的开发者

---

## 📁 Claude Code 能用

### 🎤 Anthropic 发现 MCP 本质上就是重新打包的库
**类型：** 观点/讨论  
**链接：** [r/LocalLLaMA 讨论串](https://www.reddit.com/r/LocalLLaMA/comments/1szrcwz/anthropic_is_discovering_that_mcp_is_basically/)  
**热评金句：** "I deliberately replaced MCP I used with CLI tool + Skill. That saves tokens, provide more flexibility."

**我的推荐语：**

这个讨论串里有个观点我特别认同——MCP 很好，但不一定什么都要用 MCP。有时候一个简单的 CLI 工具 + SKILL.md 比 MCP server 更省 token、更灵活。对于我们这些在本地跑模型、每一分钱都要抠的人来说，这个取舍很关键。

**适合谁读：** A类，正在搭建 agent 工具链的开发者

---

## 📁 小龙虾（OpenClaw）能用

*小龙虾（OpenClaw）的生态里也有很多可用的技能。*  
*⚠️ 本期素材偏少，下期补上——也欢迎大家推荐！*

---

## 📁 通用（都能用）

*不挑平台，任何 AI 编程助手都能受益的工具或思路。*

### 🧠 "我在搭我的工具库，求推荐" — r/LocalLLaMA 实战讨论
**类型：** 社区讨论  
**链接：** [Building out my tool library, any recommendations?](https://www.reddit.com/r/LocalLLaMA/comments/1t97163/building_out_my_tool_library_any_recommendations/)  
**发布时间：** 2026-05-11

**我的推荐语：**

这个帖子的评论区是个宝藏。楼主在搭自己的 AI 工具库，下面一群人分享自己用的工具和心得。有一条经验我特别有共鸣：**"Renaming for clearer distance between similar tools helped a lot more than re-prompting."** ——给工具起好名字、让 agent 能清楚区分，比反复改 prompt 有效得多。这也是为什么我们这期用"文件夹"来分类——让 agent 和人都能一眼区分。

**适合谁读：** A类 + B类（看评论区能学到很多实战经验）

---

### 🔬 本地 AI 研究工具现状（2026 年 5 月）
**类型：** 综述讨论  
**链接：** [Current state of local research tools as of May 2026](https://www.reddit.com/r/LocalLLaMA/comments/1t4e83m/current_state_of_local_research_tools_as_of_may/)  
**发布时间：** 2026-05-05

**我的推荐语：**

"Deep Research" 这个概念最近很火——AI 帮你自动搜资料、做调研。但这个帖子里有一个灵魂拷问：**"Are DR-specific tools necessary when it's just tool-calling + prompts which can be encoded in a skill?"** ——如果本质就是工具调用+提示词，为什么非要一个专门的"Deep Research"工具？直接写个 SKILL.md 不就行了？

对我们在用 Hermes/Skills 体系的人来说，这个问题问到了点子上。

**适合谁读：** A类

---

### 🗺️ 技能太多太乱？那个"迷失在技能丛林"的帖子
**类型：** 社区讨论  
**链接：** [Getting lost in a crazy jungle of decentralized skills, docs, data...](https://www.reddit.com/r/LocalLLaMA/comments/1ta3jy9/getting_lost_in_a_crazy_jungle_of_decentralized/)  
**发布时间：** 2026-05-11

**我的推荐语：**

这个帖子说出了我一个最近的感受——技能、文档、数据完全分散在各处，很容易迷失。帖子下的讨论很有意思：有人推荐 Obsidian + Git 做版本管理，有人推荐用 MCP 统一文件操作接口。**这其实就是我们做这个"策展"的原因——帮你从丛林里挑出真正值得看的东西。**

**适合谁读：** A类 + B类（B类读者可以通过这个了解生态现状）

---

## 🧠 我的补充 / 吐槽 / 延伸

### 关于这期

这期是第一期的**原型**——结构先搭起来，内容慢慢充实。缺失的部分：
- 🦞 小龙虾分类目前是空的（下期补）
- 🔗 交叉链接还没做（等 A/B 类文章编号定下来）

### 关于策展这件事

今天跟 Hermes 讨论这个方向的时候想到一句话：**"我们不是水的生产者，我们是水的搬运工。"** 

AI 工具生态每天出新东西，没有人能跟上所有的更新。策展人的价值不是"我知道更多"，而是"**我帮你过滤了，这些是真正值得花时间看的**"。

我放在"通用"分类里的那两篇讨论帖，其实都在说同一件事：**工具不是越多越好，关键是好用、分得清、不重复。** 这也是我做这个推荐系列的底层逻辑。

### 关于署名

本期推荐的所有链接都保留了原作者、原链接。如果你是被推荐的作者，觉得哪里不妥——直接告诉我，我来改。

---

*📮 下期预告：补上小龙虾分类 + 挖一些 YouTube 视频资源*
*🔗 我的其他内容：[A类教程](https://dev.to/lingdas1) | [B类入门](https://dev.to/lingdas1)*
