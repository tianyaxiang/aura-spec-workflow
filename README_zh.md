# aura-spec-workflow

一个 Claude Code 插件,把 Kiro 风格的 SPEC 工作流(requirements / design / tasks 三件套)产品化,并在**每次会话启动时自动浮上来**。要解决的问题是:一个新开的 Claude 会话能接着上一会话的进度走,不需要你重新口头说一遍。

[English](./README.md) · 中文

---

## 一分钟搞懂它

插件做两件事:

1. **每次 Claude 会话开起来,自动把 `docs/specs/*/tasks.md` 里没打钩的事汇总注入** — Claude 第一秒就知道你上次卡在哪
2. **给你两个 slash 命令**:`/aura-spec-workflow:spec <name>` 起新 spec,`/aura-spec-workflow:spec-status` 查进度

四种角色:

| 角色 | 谁 | 什么时候动 |
|---|---|---|
| 🤖 **SessionStart hook** | 插件 | 每次开会话 / `/clear` / 压缩后自动跑,无需触发 |
| ⌨️ **Slash 命令** | 你 | 手敲 `/aura-spec-workflow:spec <name>` 或 `/aura-spec-workflow:spec-status` |
| 💬 **填内容** | Claude 跟你对话写 | 你说要做什么 → Claude 写到三个 md 里;或你手写 |
| ✏️ **改状态** | 你(或叫 Claude 帮你) | tasks.md 里把 `[ ]` 改成 `[x]`(手改或让 Claude 改) |

要点:**插件只管"状态浮上来"+"骨架生成"。三件套的内容是你和 Claude 一起写出来的,不是插件凭空生成。**

---

## 安装(一次性)

```shell
/plugin marketplace add tianyaxiang/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

或者从本地 clone 安装(开发模式):

```shell
/plugin marketplace add ~/IdeaProjects/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

装完后 hook 立即在每个项目生效;不需要每个 repo 重复配置。

---

## Workflow 全景表

把"一个新 feature 从想法到验收"切成 7 步,标清"谁动手":

| 步 | 阶段 | 你要做的事 | 系统/Claude 自动做的事 |
|---|---|---|---|
| 1 | 起 spec | 敲 `/aura-spec-workflow:spec <name>` | 插件 scaffold `docs/specs/<name>/{requirements,design,tasks}.md` 三个模板 |
| 2 | 填 requirements | 用大白话告诉 Claude "我想做什么、给谁、验收标准是什么",然后说"写到 requirements.md" | Claude 把对话内容结构化成 user story + AC 落盘 |
| 3 | 填 design | 让 Claude 进 plan mode(`/plan` 或说"先想清楚再动"),探索代码后说"把方案写到 design.md" | Claude 用 Explore subagent 看代码,写 components 表、数据模型、时序、风险 |
| 4 | 拆 tasks | 说"把 design 拆成 10–20 条 tasks,每条 1 天能干完" | Claude 列出编号清单,你 review 增删 |
| 5 | 执行 | 一次说一条:"做 #1"(或 Claude 自己看到 next 就开干) | Claude 改代码、跑测试、commit |
| 6 | 标完成 | 手改 `[ ]` → `[x]`,或说"标 #1 为完成" | Claude 改 tasks.md(一行 edit) |
| 7 | 续(下一会话) | **什么也不用敲**,看输出 | 🤖 SessionStart hook 自动告诉 Claude "next: #2 xxx" |

---

## 端到端走一遍(实例)

以 aura 项目的 `watchlist-extension` 为例,完整流程长这样。`>` 行是**你的输入**;`📋` 是**系统自动注入**;其它是 Claude 的回应。

### Step 1:起 spec

```
> /aura-spec-workflow:spec watchlist-extension

[Claude 调用 Bash mkdir + cp,然后回]
已创建:
  docs/specs/watchlist-extension/requirements.md
  docs/specs/watchlist-extension/design.md
  docs/specs/watchlist-extension/tasks.md
建议填写顺序:requirements → design → tasks。
```

此时三个文件是空模板。

### Step 2:填 requirements(对话驱动)

不要让 Claude 自己脑补。先聊清楚,再让它落盘:

```
> 我想给自选股加 9 个字段:自定义名称、目标买入价、目标卖出价、涨跌幅预警%、备注,
  外加 3 个预警开关(总开关 / 触及买入价通知 / 触及卖出价通知)。目的是让用户在
  微信里收到针对性预警,不只是看通用涨跌。

> 把这些整理成 user story + 验收标准,写到 docs/specs/watchlist-extension/requirements.md。

[Claude 写文件,回报路径]
```

如果你已经有完整的需求文档,可以**手写** requirements.md,跳过这一步。

### Step 3:填 design(plan mode + Claude 驱动)

需求清楚后,让 Claude 先调研再写设计:

```
> 进 plan mode,看 aura 现有 watchlist 模型 / 推送链路 / 前端表格,
  设计这次扩展怎么改最小化。

[Claude EnterPlanMode,跑 Explore subagent,展示方案]
[你 review,可能改几个点,Claude ExitPlanMode]

> 把刚才的 plan 写到 docs/specs/watchlist-extension/design.md,
  组件表用真实文件路径,时序段画预警扫描流程。
```

### Step 4:拆 tasks(Claude 提议 + 你 review)

```
> 把 design.md 拆成 tasks,每条要能 1–2 小时干完 + 有验收点,
  写到 tasks.md。按依赖从底层到上层排序。

[Claude 列出 18 条 - [ ] 1. ... - [ ] 18. ...]

> #3 和 #4 顺序反一下;#15 改成"浏览器走查 UI,不动代码"。
```

### Step 5:执行(一次一条)

```
> 做 #1。

[Claude 改代码,跑测试,可能 commit;干完报告]

> 标 #1 完成。

[Claude 把 tasks.md 里 "- [ ] 1. ..." 改成 "- [x] 1. ..."]

> 做 #2。
…
```

或者更简洁:

```
> 看 spec-status,做 next 一条。
```

Claude 会先跑 `/aura-spec-workflow:spec-status` 拿到 next,然后干那一条。

### Step 6:续 — `/clear` 后的下一个会话

这是插件的核心价值。新会话第一秒,你**什么都不用敲**,Claude 的上下文里已经被系统注入:

```
📋 Active SPECs in this repo:
  • watchlist-extension  (14/18 done)  next: 15. 浏览器走查 WatchlistPage UI...

Open docs/specs/<name>/tasks.md to update. Run /aura-spec-workflow:spec-status anytime.
```

你只需说:

```
> 继续。
```

或:

```
> 看下 #15 该怎么走查,列个 checklist。
```

Claude 已经知道 #15 是什么,不需要你重新介绍 watchlist-extension 是啥。

### Step 7:全部 `[x]` 之后

```
> spec 全跑完了,把 tasks.md 已完成部分搬到底部"完成"区,清空 Open。
```

或者就留着不动,git log 是审计。

---

## 日常 4 个常用 pattern

### Pattern A:中途想加一条任务

执行 #5 时发现还要做个 #19。**不要改老编号**,追加到末尾:

```
> 在 tasks.md 末尾加一条 "- [ ] 19. 给 quote 加 retry,防抖网络抖"。
```

### Pattern B:需求变了

直接改 requirements.md,**git diff 就是变更记录**。不需要写"需求 v2"。如果改动大,在 design.md 顶部加一段 "## 变更记录 2026-05-21:xxx 调整方案"。

### Pattern C:多 spec 并行

每个 feature 一个目录。SessionStart hook 会把每个有未完成事项的 spec 都列出来:

```
📋 Active SPECs in this repo:
  • watchlist-extension  (14/18 done)  next: 15. 浏览器走查...
  • auth-rewrite         (3/12 done)   next: 4. 加 refresh token 旋转
```

### Pattern D:看进度

```
> /aura-spec-workflow:spec-status
```

跟 SessionStart hook 输出一样,任何时候都能看。

---

## 提示词速查

复制粘贴用:

| 想做的事 | 推荐 prompt |
|---|---|
| 起新 spec | `/aura-spec-workflow:spec <kebab-name>` |
| 让 Claude 填 requirements | "把刚才聊的需求整理成 user story + AC 写到 docs/specs/<name>/requirements.md" |
| 让 Claude 出 design | "进 plan mode 看相关代码,设计方案,然后写到 docs/specs/<name>/design.md" |
| 让 Claude 拆 tasks | "把 design.md 拆成 tasks,每条 1–2 小时能干完 + 带验收点,写到 tasks.md" |
| 执行下一条 | "看 spec-status,做 next 那条" |
| 标完成 | "标 #N 完成" 或手改 `[ ]` → `[x]` |
| 查进度 | `/aura-spec-workflow:spec-status` |
| 加临时任务 | "tasks.md 末尾追加一条:- [ ] N. xxx" |

---

## 约定

- 一个 spec 对应一个 feature 或 bugfix。粒度别太大,几天能完结的范围最合适
- 任务 ID 稳定。**永不重新编号**。新增任务追加到末尾
- 扫描脚本只识别 `[ ]` 和 `[x]`。`[~]` 可作进行中标记但不计入统计
- tasks.md 每条任务自足 — 未来的会话光读 tasks.md 就能明白这条要做什么
- requirements.md 改了就 commit,git diff 是变更历史,不要写 "需求 v2"

---

## Troubleshooting

| 症状 | 检查 |
|---|---|
| 新会话没看到 📋 Active SPECs | `docs/specs/` 不存在,或所有 spec 都 `[x]` 完了(hook 设计就是静默),或插件没装(`/plugin` → Installed 列表里找) |
| `/aura-spec-workflow:spec` 不识别 | `/reload-plugins`;如果还不行 `/plugin` → Errors tab 看报错 |
| Skill 报"file not found" | 插件路径用了相对路径或者 `${CLAUDE_PLUGIN_ROOT}` 没用上 — 自己改插件再 `/reload-plugins` |
| hook 输出乱码 / 报错 | 直接跑脚本调试:`CLAUDE_PROJECT_DIR=$PWD ~/.claude/plugins/cache/.../bin/spec-status.sh`(cache 路径 `/plugin` → 详情可见) |
| 想看 hook 到底注入了什么 | 启 Claude Code 时加 `--debug`,SessionStart 输出会在 stderr 打印 |

---

## 文件结构

```
.claude-plugin/marketplace.json
plugins/aura-spec-workflow/
├── .claude-plugin/plugin.json
├── hooks/hooks.json
├── bin/spec-status.sh
├── skills/spec/SKILL.md
├── skills/spec-status/SKILL.md
└── templates/{requirements,design,tasks}.md
```

---

## 本地开发

```shell
claude --plugin-dir ~/IdeaProjects/aura-spec-workflow/plugins/aura-spec-workflow
# 进入会话后:
/reload-plugins
```

改动 → `/reload-plugins` → 再测。要 push 公开版本:`git push` 到 GitHub,用户 `/plugin marketplace update aura-spec-workflow` 就能拿到。

---

## License

MIT.
