---
title: "Unity Skills"
published: 2026-02-04T22:47:30
updated: 2026-06-22T10:30:00
description: "Unity Skills 是面向 AI Coding Agent 的 Unity 编辑器自动化系统，通过 700+ REST Skills、权限控制、批量执行和多终端适配，让 AI 能直接完成场景、资源、组件和项目级操作。"
image: "/images/unityskills-cover.webp"
tags: ["Unity", "AI", "Automation", "MCP", "Agent"]
version: "v2.0.5"
architecture: "Unity Editor Package + REST API Server + AI Skills Client + Permission System"
video: ""
videoPoster: "/images/unityskills-cover.webp"
featured: true
draft: false
lang: "zh_CN"
---

## 项目概览

Unity Skills 是一个让 AI Coding Agent 直接操作 Unity 编辑器的自动化项目。它把 Unity 内部常用能力封装成 REST Skills，让 Claude Code、Gemini CLI、Codex、Antigravity 等终端可以通过自然语言触发具体编辑器操作。

项目当前 README 标注版本为 **v2.0.5**，面向 **Unity 2022.3+**。核心规模包括 **726 个 REST Skills**、**51 个功能源码模块**、**19 个顾问模块**，并提供权限系统、批量执行、场景编辑、资源管理、Prefab、UI、动画、材质、构建等能力。

## 为什么要做

Unity 项目里的大量工作并不是算法难题，而是高频、重复、容易出错的编辑器操作。例如创建 GameObject、挂载组件、批量调整 Inspector 参数、整理场景层级、创建材质、检查资源引用、生成 Prefab 或配置构建参数。

传统 MCP 或简单脚本能解决一部分问题，但在 Unity 场景里还需要更强的能力边界：

- 操作必须可控，不能让 AI 随意执行破坏性动作。
- 结果必须足够精简，否则上下文很快被 Unity 对象信息填满。
- 多步骤任务需要批量执行，避免频繁往返调用。
- 复杂项目需要顾问模块，把常见 Unity 工作流沉淀成可复用规则。

Unity Skills 就是围绕这些问题做的一套 AI-to-Unity 自动化层。

## 核心能力

### 700+ REST Skills

项目将 Unity 编辑器能力拆成大量可调用接口，覆盖场景对象、组件、资源、Prefab、材质、UI、动画、物理、构建、包管理、项目设置等领域。AI 不需要直接猜 Unity API，而是调用已经整理好的技能接口完成任务。

### 权限与风险控制

项目包含权限模式设计，用于区分安全读取、普通编辑和高风险操作。这样可以把 AI 的能力限制在明确边界内，降低误删资源、批量破坏场景或修改关键配置的风险。

### 批量优先

Unity Skills 强调批量执行。相比让 AI 一次只创建一个对象、一次只修改一个字段，批量接口可以减少请求次数，也能让一组相关修改以更接近事务的方式完成。

### 多终端适配

项目提供面向多种 AI 终端的使用方式，README 中覆盖 Claude Code、Gemini CLI、Codex、Antigravity、Cursor 等工作流。不同终端可以通过各自的技能/规则/命令入口调用同一套 Unity 自动化能力。

### 顾问模块

除了直接操作接口，Unity Skills 还包含顾问模块，用于封装 Unity 开发中的工作流经验。例如性能、架构、场景组织、组件拆分、构建配置等方向，让 AI 在执行前能获得更具体的 Unity 上下文。

## 架构说明

整体架构可以拆成四层：

1. **Unity Editor Package**：安装到 Unity 项目内，负责访问编辑器对象、资源、场景和项目设置。
2. **REST API Server**：在本地暴露受控接口，AI 客户端通过 HTTP 调用 Unity 能力。
3. **AI Skills Client**：在 Claude Code、Codex、Gemini CLI 等终端侧提供技能说明和调用脚本。
4. **Permission System**：对技能能力做分级，控制读取、编辑、批量和危险操作的边界。

这种架构避免了把 AI 直接塞进 Unity 编辑器内部，也避免了让 AI 临时生成不可控脚本。AI 只需要描述目标，由 Skills 层把目标转换成稳定、可校验的 Unity 操作。

## 适合场景

- 快速搭建场景结构和基础 GameObject。
- 批量创建、查找、修改组件。
- 整理资源、Prefab、材质和项目设置。
- 让 AI 在 Unity 项目中执行可重复的编辑器工作流。
- 把团队常用 Unity 操作沉淀成 Agent 可复用技能。

## 使用限制

Unity Skills 适合自动化高频编辑器操作，但不应该绕过版本管理、测试和人工确认。涉及删除资源、大规模改场景、修改构建配置等操作时，仍建议先确认 Git 状态，并在小范围项目或测试场景中验证。

## 项目地址

::github{repo="Besty0728/Unity-Skills"}
