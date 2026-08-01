# Codex account and connector boundaries

## Development account

Use one primary ChatGPT account for every VM project Codex home, the IDE, Codex
CLI, GitHub plugin, and Codex cloud tasks. The image config sets
`forced_login_method = "chatgpt"`; it intentionally has no API key and does not
pin a model.

After opening each project container for the first time:

```bash
codex login
codex plugin add github@openai-curated
codex doctor
```

Confirm the primary development account during the browser login. Plugin catalog
installation is deliberately performed only after authentication, so credentials
or another Codex home's plugin cache are never copied.

## Personal account

Use the personal ChatGPT account only on the Windows desktop app and its native
`%USERPROFILE%\.codex`. Keep email, calendar, Drive, personal memories, and
personal files off the VM. If occasional development-account access is needed on
Windows, use a separate browser profile instead of changing the desktop app's
account.

## Third account

Export anything worth keeping, sign the account out of Codex, and reserve or
retire it. Do not rotate accounts to extend limits. If the development account
needs more capacity, change its plan or use separately budgeted API access only
for an explicitly programmatic workload.
