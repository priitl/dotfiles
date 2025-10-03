---
description: Bootstrap a new project following constitution principles
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/bootstrap` in the triggering message **is** the project description. Use it as context but NEVER assume - ALWAYS ask clarifying questions. Do not ask the user to repeat the description unless they provided an empty command.

Given that project description, do this:

1. Load `.ai/2_templates/bootstrap-template.md` to understand the interactive bootstrap process.

2. If `constitution.md` does NOT exist at project root:
   - This is a greenfield bootstrap
   - Follow the template's Execution Flow to ask questions and gather all decisions
   - Create `constitution.md` encoding all architectural decisions as principles

3. If `constitution.md` DOES exist at project root:
   - This is adding to an existing project
   - Read the constitution at `constitution.md` to understand constitutional requirements
   - Use constitution as the source of truth for tech stack and architecture
   - Skip questions already answered by constitution
   - Only ask about new aspects not covered by constitution

4. Follow the bootstrap template's questioning strategy:
   - Start broad (tech stack, language, framework)
   - Go deeper (architecture, build tools, testing)
   - Get specific (dependencies, versions, optional features)
   - NEVER assume - mark with [NEEDS ANSWER] if unclear
   - Provide options when user seems uncertain

5. Once all decisions are clear (no [NEEDS ANSWER] markers remain):
   - Generate project structure based on decisions
   - Create all build configurations, dependencies, and foundational code
   - Set up testing infrastructure
   - Configure quality tooling
   - Initialize persistence layer (if applicable)
   - Create documentation (if requested)

6. Validate the generated project:
   - Run build command to verify compilation
   - Ensure tests pass (if example scaffold created)
   - Verify structure aligns with architectural decisions

7. Report completion with:
   - Summary of created structure
   - Build commands and how to run
   - Next steps: Run `/specify [your first feature]` to start development

Use absolute paths with the repository root for all file operations to avoid path issues.

Note: This command creates the PROJECT STRUCTURE only. To add features, use the spec-driven workflow: `/specify` → `/plan` → `/tasks` → `/implement`.
