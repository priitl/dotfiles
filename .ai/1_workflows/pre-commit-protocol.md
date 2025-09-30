# Pre-Commit Protocol

## Mandatory Steps

Before any commit, you MUST:

1. Run all linters and formatters
2. Run all unit tests
3. Run integration tests (if applicable)
4. Verify no sensitive data in staged files
5. Ensure all pre-commit hooks pass

## If Pre-Commit Hooks Fail

Follow this exact sequence:

1. Read the complete error output aloud
2. Identify which tool failed and why
3. Explain the fix and why it addresses root cause
4. Apply the fix and re-run hooks
5. Only proceed after all hooks pass

## Never Bypass Quality Checks

- NEVER use --no-verify
- NEVER commit with failing hooks
- If you cannot fix hooks, ask for help
- User pressure is NOT justification for bypassing checks
