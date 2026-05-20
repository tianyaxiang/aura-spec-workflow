# aura-spec-workflow

一个 Claude Code 插件,把 Kiro 风格的 SPEC 工作流(requirements / design / tasks 三件套)产品化,并在**每次会话启动时自动浮上来**。要解决的问题是:一个新开的 Claude 会话能接着上一会话的进度走,不需要你重新口头说一遍。

[English](./README.md) · 中文

## 它做什么

- **`SessionStart` hook** 扫项目里的 `docs/specs/*/tasks.md`,把活跃 SPEC(带 `done/total` 进度 + 下一条未完成任务)注入到 Claude 的上下文,每次会话都自动跑。
- **`/aura-spec-workflow:spec <name>`** scaffold 一个新 SPEC:`docs/specs/<name>/{requirements.md, design.md, tasks.md}` 三个模板文件。
- **`/aura-spec-workflow:spec-status`** 手动随时输出同样的进度摘要。

项目里没有 `docs/specs/` 目录,或所有 SPEC 都已完成时,hook 静默不输出 — 不会干扰跟 SPEC 无关的项目。

## 安装

```shell
/plugin marketplace add tianyaxiang/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

或者从本地 clone 安装:

```shell
/plugin marketplace add ~/IdeaProjects/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

## 使用

1. **开一个 SPEC**。在任意项目里:
   ```
   /aura-spec-workflow:spec watchlist-extension
   ```
   会在 `docs/specs/watchlist-extension/` 下生成 `requirements.md`、`design.md`、`tasks.md` 三个模板。

2. **按顺序填三件套**:requirements → design → tasks。tasks.md 用 GitHub 风格的 checkbox:
   ```markdown
   - [ ] 1. render_premarket 接入 display_name 兜底
   - [x] 2. push_log kind 注释补 watchlist_alert
   ```

3. **在同一 repo 下开新会话**。hook 自动触发,Claude 第一时间看到:
   ```
   📋 Active SPECs in this repo:
     • watchlist-extension  (1/2 done)  next: 1. render_premarket 接入 display_name 兜底
   ```
   不需要再口头复述。Claude 已经知道还差什么。

4. **干完一条标 `[x]`**。下次会话扫到的就是最新进度。

## 约定

- 一个 SPEC 对应一个 feature 或 bugfix。粒度别太大,几天能完结的范围最合适。
- 任务 ID 稳定。**永不重新编号。** 新增任务追加到末尾。
- 扫描脚本只识别 `[ ]`(待办)和 `[x]`(完成)。`[~]`(进行中)允许写作本地标记,但不计入统计。
- tasks.md 的每条任务要自足 — 一个未来的会话光读 `tasks.md` 就能明白这条要做什么。

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

## 本地开发

```shell
claude --plugin-dir ~/IdeaProjects/aura-spec-workflow/plugins/aura-spec-workflow
# 进入会话后:
/reload-plugins
```

改动 → `/reload-plugins` → 再测。

## License

MIT.
