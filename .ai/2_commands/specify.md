---
description: Create or update the feature specification from a natural language feature description.
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. Parse JIRA task number (if present) and determine branch naming strategy:
   - Check if feature description contains a JIRA task ID (e.g., PROJ-123, ABC-456)
   - If JIRA task found:
     - Extract JIRA task number
     - Use enterprise branch format: `feature/JIRA-TASK-NUMBER` (e.g., `feature/PROJ-123`)
     - Create feature directory: `specs/feature-JIRA-TASK-NUMBER/` (e.g., `specs/feature-PROJ-123/`)
   - If NO JIRA task found:
     - List all directories in `specs/` to find highest number (e.g., 001, 002, 003)
     - Increment by 1 to get new feature number (e.g., if 003 exists, new is 004)
     - Create branch name from number + feature description slug (e.g., `004-user-notifications`)
     - Create feature directory: `specs/[branch-name]/` (e.g., `specs/004-user-notifications/`)
   - Create git branch with the determined branch name

2. Load `~/.ai/1_templates/spec-template.md` (from home directory) to understand required sections.

3. Write the specification to `specs/[branch-name]/spec.md` using the template structure:
   - If JIRA task found: Set **JIRA Task** field to the JIRA task number, **Feature Branch** to `feature/JIRA-TASK-NUMBER`
   - If NO JIRA task: Set **JIRA Task** field to "N/A", **Feature Branch** to `###-feature-name` format
   - Replace other placeholders with concrete details derived from the feature description (arguments)
   - Preserve section order and headings

4. Report completion with branch name, spec file path, JIRA task number (if applicable), and readiness for the next phase.
