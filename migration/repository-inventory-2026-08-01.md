# Repository inventory — 2026-08-01

This is a metadata-only inventory. Dirty repositories were not modified and
their file contents were not copied. `tracked` and `untracked` are porcelain
status entry counts; one untracked directory can contain multiple files.

| Repository | Branch | State | Remote/upstream | Disposition |
| --- | --- | --- | --- | --- |
| `ansible` outer repository | `main` | dirty: 3 tracked, 6 untracked | `origin/main`, synchronized | Legacy wrapper; history and tracked changes are already archived. Keep until collection migration is complete. |
| `ansible/.../community/zabbix` | `remove-zabbix60` | dirty: 7 tracked, 2 untracked | `origin/remove-zabbix60`, synchronized | Active changes; defer until committed or separately backed up. |
| `ansible/.../pyrodie18/splunk` | `main` | dirty: 5 tracked, 7 untracked | `origin/main`, synchronized | Active changes; defer until committed or separately backed up. |
| `ansible/.../sausage_sensor/ss` | `main` | dirty: untracked `roles/` tree containing 25 files | `origin/main`, synchronized | Recommended next Ansible migration after the role tree is committed or archived. Flatten to `~/devel/ansible/sausage_sensor.ss`. |
| `ansible/pyrodie18.utils` | `main` | clean | `origin/main`, synchronized | Migrated pilot; keep as reference. |
| `dev-environments` | `main` | clean after this inventory commit | `origin/main`, synchronized | Canonical environment definitions. |
| `python/AdventOfCode` | `main` | dirty: 15 tracked, 27 untracked | `origin/main`, synchronized | Large active/archive tree; defer. |
| `python/gmail_mcp` | `main` | clean | `origin/main`, synchronized | Migrated pilot; keep as reference. |
| `python/log_generator` | `main` | dirty: 2 tracked, 1 untracked | no remote/upstream | Back up and establish a remote before migration. |
| `python/splunk-ai-operator` | `main` | clean | `origin/main`, synchronized | Go/Kubernetes project, not Python. Design a separate Go/container environment rather than using the Python template. |
| `python/splunk-conf-docs` | `main` | dirty: 15 tracked, 1 untracked | no remote/upstream | Back up and establish a remote before migration. |
| `python/splunk_config_files` | `10.0.0` | clean | `origin/10.0.0`, synchronized | Content-only repository; do not add a Python environment without a concrete tool workflow. |
| `python/zeek_generator` | `main` | no commits; 5 untracked entries | no remote/upstream | Preserve as an uncommitted new project before migration. |
| `python/zeek_log_gen` | — | invalid empty `.git` directory | none | Confirm whether the directory contains project data, then remove only the empty `.git` marker or initialize intentionally. |
| `ss/containers` | `main` | clean | `origin/main`, synchronized | Container definitions outside the current Python/Ansible migration scope. |
| `ss/ss` | `main` | dirty: 2 untracked entries | `origin/main`, synchronized | Clarify relationship to `sausage_sensor/ss` before touching either repository. |

The empty `~/devel/.git` directory is not a valid repository and contains no
configuration or objects. `~/devel/python/.git` is no longer present.

## Next candidate

`sausage_sensor/ss` is the smallest real Ansible candidate and exercises the
collection template without introducing a third language environment. Before
relocation, choose one of these evidence-preserving options:

1. review and commit the 25 files under `roles/`; or
2. create a timestamped archive outside all Git repositories and verify its
   checksum.

Do not relocate or alter that repository until the user selects the preservation
method.
