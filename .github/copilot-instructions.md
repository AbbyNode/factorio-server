# Copilot Instructions

# Documentation Guidelines

* Keep documentation concise and actionable.
* Document only project-specific instructions.
* Include only essential, non-obvious implementation details.
* Exclude generic or redundant sections like “Features” or “Benefits.”
* Focus on how to run and use features; omit obvious information.

# Docker Guidelines

* Prefer official or popular Docker images when functionality can be achieved easily with them.
* Create custom images only when necessary for specific custom functionality.
* Never put code execution logic directly in compose files.
* Never bind mount files directly as this interferes with first time creation.
    * Bind mounts should only be used for directories.
    * Use `ln` inside containers to isolate to-be-bound files into bound directories.
* End user must never need to run bash scripts on the host machine.
    * All scripts the end user needs must run inside containers, ideally through a docker-compose profile.

## Style

### Commits
* When creating new commits in automatic agent mode, always prefix commit with `[COPILOT]`.

### Cohesion with Existing Code
* New work should be cohesive with existing code.
* Use similar approaches to existing implementations.
* Refer to the same files across containers when possible instead of duplicating them.
