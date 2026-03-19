# Homebase Decisions Log

Record of what was done, why, and what was learned.

---

## 2026-03-19 — Initial Core Stack Setup

**What:** Set up Phase 1 core stack with four services: Portainer, Homepage, Uptime Kuma, and Dozzle. All running via Docker Compose on Mac.

**Why:** Wanted a working home server foundation that's manageable, monitorable, and accessible from a browser. Kept it minimal — only services that help manage the server itself.

**Services chosen:**

- Portainer (container management UI) — visual dashboard to manage Docker without terminal
- Homepage (service dashboard) — one page linking to everything, auto-reloads on config change
- Uptime Kuma (monitoring) — pings services every 60 seconds, tracks uptime history
- Dozzle (log viewer) — real-time container logs in browser, read-only access to Docker socket

**Architecture decisions:**

- Single `docker-compose.yml` in `services/core/` for all core services
- `config/` folder for hand-edited configs (git tracked), `volumes/` for app-generated data (gitignored)
- Shared Docker network named `homebase` so containers can find each other by name
- Bind mounts (`./volumes/`) instead of named Docker volumes for easier backup and visibility
- `start.sh` and `stop.sh` scripts at project root

**What was tried and dropped:**

- Nginx Proxy Manager — works but useless without DNS to resolve custom hostnames. Saved for Phase 2.
- AdGuard Home — would solve the DNS problem, but macOS `mDNSResponder` locks port 53 and 5353. No clean workaround on Mac. Saved for Phase 2 on Linux.
- The Tailscale + AdGuard + NPM combo is the proper way to get clean URLs. Requires a Linux host.

**Gotchas:**

- Portainer uses HTTPS with a self-signed cert on port 9443. Browser shows security warning — click through it. Uptime Kuma needs "Ignore TLS/SSL error" toggled on to monitor it.
- Homepage requires `HOMEPAGE_ALLOWED_HOSTS: "*"` in newer versions or it rejects connections.
- Dozzle's internal port is 8080, remapped to 9999 externally to avoid conflicts.
- YAML indentation in compose files matters — misaligned `restart: always` will break things.
- macOS grabs ports 53 and 5353 for mDNSResponder. Cannot run a DNS server in Docker on Mac without hacky workarounds.

**Port map:**

| Port  | Service      |
|-------|-------------|
| 9443  | Portainer   |
| 3000  | Homepage    |
| 3001  | Uptime Kuma |
| 9999  | Dozzle      |

**Next steps:**

- Pick first real service (Immich, Vaultwarden, Ollama, etc.)
- Push repo to private Git remote
- Set up automated backups

---

*Add new entries above this line. Format: date, what, why, gotchas.*
