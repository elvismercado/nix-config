---
description: "Diagnose and fix issues from a log. Use when troubleshooting NixOS rebuild output, install logs, journal output, or any error log."
agent: "Plan"
argument-hint: "Paste log output, or provide a log file path"
---

Analyze the provided log and propose fixes. Follow the [project conventions](../copilot-instructions.md).

## 1. Parse the log

Extract every distinct message from the log:

- Errors, failures, and stack traces
- Warnings
- Informational messages that look unusual

## 2. Research each message

For each message:

- Search the codebase for the relevant file, function, or config that produced it
- Determine whether it is a real problem or known harmless noise
- Check if the issue has been seen before in this project (e.g., os-prober `lsblk` noise, dirty git tree warnings during install)

## 3. Classify findings

Present a findings table sorted by severity:

| #   | Severity | Message (short) | Verdict                          |
| --- | -------- | --------------- | -------------------------------- |
| 1   | Error    | `<message>`     | Must fix — `<one-line reason>`   |
| 2   | Warning  | `<message>`     | Should fix — `<one-line reason>` |
| 3   | Info     | `<message>`     | Harmless — `<one-line reason>`   |

Severity levels:

- **Error**: Broke or will break something — must fix
- **Warning**: Suboptimal but functional — should investigate
- **Info**: Harmless noise — explain why it can be ignored

## 4. Diagnose each Error and Warning

For each Error or Warning, provide:

- **Root cause**: Why this happened
- **File**: The file responsible (link to it)
- **Fix**: The specific change needed

## 5. Propose fixes

Group all proposed fixes by file:

```
<file path>
  - Fix #1: <description>
  - Fix #2: <description>

<file path>
  - Fix #3: <description>
```

**Do not apply fixes.** Present the plan and wait for explicit approval before implementing any changes.

## 6. Considerations

After the fix list, note any:

- Upstream issues (bugs in dependencies, not fixable in this repo)
- Performance improvements worth considering
- Follow-up actions the user should take on the machine (e.g., `nix flake update`, `nixos-rebuild switch`)
