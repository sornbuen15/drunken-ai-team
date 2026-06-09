# My AI Skills (Jakkawan's Engineering Standards) 🧠🚀

Welcome to **My AI Skills** — a centralized repository of enterprise-grade, XML-based system prompts. This project is designed to transform any AI coding assistant (Claude CLI, Cursor, Aider) from a generic code-generator into a strictly disciplined, highly empathetic **Senior Enterprise Architect & Tech Lead**.

## The Philosophy
Most AI agents suffer from premature coding, hallucination, and lack of architectural foresight. This repository solves that by enforcing:
1. **XML-Based Boundaries:** Built strictly on Anthropic's prompt engineering guidelines to separate context from fatal constraints.
2. **Separation of Concerns (SoC):** Skills are modularized. The AI only loads what it needs (e.g., Frontend rules aren't loaded during Database migrations), saving token context.
3. **"Thinking" Before Doing:** Every skill forces the AI to open a `<thinking>` block to evaluate Trade-offs, NFRs, and Edge Cases before generating a single line of code.

## Repository Structure

```text
my-ai-skills/
├── scripts/
│   └── link-skills.sh          # Setup script to link skills globally
├── CLAUDE.md                   # The Master Router (Copy this to new projects)
└── skills/                     # The 11 Pillars of Engineering
    ├── architecture/
    │   └── system-design/
    ├── backend/
    │   └── clean-architecture/
    ├── frontend/
    │   └── universal-ux/
    ├── infrastructure/
    │   ├── cloud-native/
    │   └── incident-response/
    ├── leadership/
    │   └── servant-leadership/
    ├── product/
    │   ├── business-telemetry/
    │   └── product-mindset/
    ├── security/
    │   └── secure-by-design/
    └── workflow/
        ├── ai-discipline/
        ├── core-engineering/
        └── project-hygiene/
