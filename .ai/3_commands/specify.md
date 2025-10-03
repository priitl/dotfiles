---
description: Create or update the feature specification from a natural language feature description.
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. Determine the next feature number and branch name:
   - List all directories in `specs/` to find highest number (e.g., 001, 002, 003)
   - Increment by 1 to get new feature number (e.g., if 003 exists, new is 004)
   - Create branch name from number + feature description slug (e.g., `004-user-notifications`)
   - Create feature directory: `specs/[branch-name]/`
   - Create git branch with same name

2. Load `.ai/2_templates/spec-template.md` to understand required sections.

3. Write the specification to `specs/[branch-name]/spec.md` using the template structure, replacing placeholders with concrete details derived from the feature description (arguments) while preserving section order and headings.

4. Report completion with branch name, spec file path, and readiness for the next phase.
