---
description: Execute the implementation planning workflow using the plan template to generate design artifacts.
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Given the implementation details provided as an argument, do this:

1. Determine feature context:
   - If user provided feature path (e.g., `specs/003-user-auth`), use it
   - Otherwise, check current git branch for feature name pattern (NNN-feature-name)
   - Derive: FEATURE_DIR = `specs/[branch-name]/`, FEATURE_SPEC = `specs/[branch-name]/spec.md`, IMPL_PLAN = `specs/[branch-name]/plan.md`
   - BEFORE proceeding, inspect FEATURE_SPEC for a `## Clarifications` section with at least one `Session` subheading. If missing or clearly ambiguous areas remain (vague adjectives, unresolved critical choices), PAUSE and instruct the user to run `/clarify` first to reduce rework. Only continue if: (a) Clarifications exist OR (b) an explicit user override is provided (e.g., "proceed without clarification"). Do not attempt to fabricate clarifications yourself.

2. Read and analyze the feature specification to understand:
   - The feature requirements and user stories
   - Functional and non-functional requirements
   - Success criteria and acceptance criteria
   - Any technical constraints or dependencies mentioned

3. Read the constitution at `constitution.md` to understand constitutional requirements.

4. Execute the implementation plan template:
   - Load `.ai/2_templates/plan-template.md` as reference
   - Copy template to IMPL_PLAN path
   - Set Input path to FEATURE_SPEC
   - Run the Execution Flow (main) function steps 1-9
   - The template is self-contained and executable
   - Follow error handling and gate checks as specified
   - Let the template guide artifact generation in FEATURE_DIR:
     * Phase 0 generates research.md
     * Phase 1 generates data-model.md, contracts/, quickstart.md, and updates AGENTS.md at project root
     * Phase 2 describes task generation approach (do NOT create tasks.md)
   - Incorporate user-provided details from arguments into Technical Context: {ARGS}
   - Update Progress Tracking as you complete each phase

5. Verify execution completed:
   - Check Progress Tracking shows Phase 0 and Phase 1 complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution
   - Phase 2 should only describe approach, not execute

6. Report results with branch name, file paths, and generated artifacts.

Use absolute paths with the repository root for all file operations to avoid path issues.
