# Specification: [Script Name]

## Context

<!-- Describe the problem or automation need this script solves -->

## Functional Requirements

### User Stories

1. **As an** [operator/scheduled task/CI step], **I want** [the script to do X], **so that** [benefit].

### Acceptance Criteria (EARS)

<!-- Use EARS notation: WHEN [condition] THE SCRIPT SHALL [behavior] -->

1. **WHEN** invoked with valid arguments **THE SCRIPT SHALL** [expected behavior] and exit with code `0`.
2. **WHEN** invoked with a missing or invalid argument **THE SCRIPT SHALL** print a clear error to stderr and exit with a nonzero code.
3. **WHEN** [a specific failure condition, e.g. target path locked/inaccessible] **THE SCRIPT SHALL** [expected recovery/failure behavior] and clean up any partial state.

## Non-Functional Requirements

- **Unattended-safety:** no command may block on interactive input if this script will run scheduled or in CI.
- **Idempotency:** [does running it twice in a row need to be safe? state explicitly]
- **Logging:** [console only, or also to a log file via `/LOG:` or redirection?]

## Arguments

| Position/Flag | Required? | Description |
|---|---|---|
| `%1` | [Yes/No] | [what it is] |

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | [specific failure meaning] |

## Business Rules

1. [Rule 1]
2. [Rule 2]

## Out of Scope

- [What this script will NOT do]
