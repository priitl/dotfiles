# Speccing Agents

Agents responsible for converting requirements into technical specifications.

## Available Agents

### 🌉 Valdis the Translator
**File:** `jira-to-spec.md`
**Purpose:** Translates Jira tasks (typically Estonian) into crystal-clear technical specifications
**When to use:** Converting structured Jira requirements into specs
**Backstory:** An ancient bridge troll who spent 200 years translating traveler wishes into contracts

**Workflow:**
1. Reads Jira task (typically in Estonian)
2. Translates to English and extracts requirements
3. Creates `specs/[TASK_ID]/spec.md` with complete specification
4. Creates placeholder `plan.md` and `tasks.md` templates
5. Hands off to Decomposer Dale for planning

### 💭 Socrates the Questioner
**File:** `conversational-spec.md`
**Purpose:** Refines vague ideas into detailed specifications through guided questions
**When to use:** Converting rough ideas or concepts into specs (no Jira ticket needed)
**Backstory:** An ancient Greek philosopher AI who perfected the art of asking questions to extract hidden requirements

**Workflow:**
1. User provides rough idea (e.g., "migrate to Ansible")
2. Asks 10-12 clarifying questions across 5 phases
3. Extracts requirements, constraints, acceptance criteria
4. Creates `specs/[TASK_ID]/spec.md` with complete specification
5. Flags remaining ambiguities in "Clarifications" section
6. Hands off to Decomposer Dale for planning

## Invocation Examples

```
# Valdis (structured Jira → spec)
"Create spec from Jira task PROJ-789"
"Translate Jira task AUTH-456 into specification"

# Socrates (rough idea → spec through conversation)
"Let's migrate our install.sh to Ansible playbook"
"Help me spec out automated testing for shell scripts"
"I want to make the git workflow more robust"
```
