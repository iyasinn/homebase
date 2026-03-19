# Homebase Guide

How to use, manage, and maintain your home server.

---

## Quick Reference

| Service | URL | What it does |
|---------|-----|-------------|
| Homepage | `http://localhost:3000` | Dashboard with links to all services |
| Portainer | `https://localhost:9443` | Manage containers (start, stop, inspect) |
| Uptime Kuma | `http://localhost:3001` | Monitor service uptime and get alerts |
| Dozzle | `http://localhost:9999` | View real-time container logs |

Bookmark `localhost:3000` — that's your home page for everything.

---

## Starting and Stopping

**Start all services:**

```bash
cd ~/homebase
./start.sh
```

**Stop all services:**

```bash
./stop.sh
```

**Restart a single service** (without touching others):

```bash
cd ~/homebase/services/core
docker compose restart homepage
```

**Check what's running:**

```bash
docker ps
```

Services have `restart: always` set, so they come back automatically after a machine reboot. If they don't, just run `./start.sh`.

---

## Homepage

**What it is:** Your dashboard. One page with clickable cards linking to every service.

**How to access:** `http://localhost:3000`

**How to edit:** Open `services/core/config/homepage/services.yaml` in any text editor. Add or remove service cards. Save the file — Homepage auto-reloads, just refresh your browser.

**Config files:**

| File | Purpose |
|------|---------|
| `services.yaml` | Service cards and links (the main one) |
| `widgets.yaml` | Top-of-page widgets (CPU, memory, weather) |
| `settings.yaml` | Theme, layout, title |
| `bookmarks.yaml` | Quick link sections |
| `docker.yaml` | Docker integration settings |

**Adding a new service card:**

```yaml
- Category Name:
    - Service Name:
        href: http://localhost:PORT
        description: Short description
        icon: icon-name
```

Icons are automatically pulled from the Dashboard Icons project. Most popular self-hosted apps have icons available by name (e.g., `portainer`, `uptime-kuma`, `dozzle`, `jellyfin`, `immich`).

**Docker auto-discovery:** Homepage can see your containers because it has read-only access to the Docker socket. You can configure it to show container status automatically — check the Homepage docs for Docker widget setup.

---

## Portainer

**What it is:** A web UI for managing your Docker containers. Start, stop, restart, inspect settings, view logs, check resource usage.

**How to access:** `https://localhost:9443`

Your browser will show a security warning because Portainer uses a self-signed SSL certificate. Click "Advanced" then "Proceed to localhost" — this is safe.

**Common tasks:**

- **See all containers:** Click on your "local" environment, then "Containers" in the sidebar.
- **Restart a container:** Click the container, then the "Restart" button at the top.
- **View logs:** Click a container, then "Logs" at the top. Useful for quick checks, but Dozzle is better for real-time log watching.
- **Check resource usage:** Click a container, then "Stats" to see CPU and memory usage.
- **See your compose stack:** Click "Stacks" in the sidebar. Your core stack shows up as "core" (created outside Portainer, so control is limited — manage it via compose commands instead).

**Things to know:**

- Portainer sees ALL Docker containers on your machine, not just Homebase ones. Dev containers, random test containers, everything.
- Don't use Portainer to create new containers for Homebase services — always add them to your compose file instead. This keeps everything reproducible.
- The "Upgrade to Business Edition" banner can be ignored. Community Edition does everything you need.

---

## Uptime Kuma

**What it is:** Monitors your services and tells you if something goes down. Pings each service every 60 seconds and keeps a history.

**How to access:** `http://localhost:3001`

**Adding a new monitor:**

1. Click "Add New Monitor"
2. Set Monitor Type to "HTTP(s)"
3. Give it a Friendly Name
4. Enter the URL using the **internal container name and port** (e.g., `http://homepage:3000`)
5. For Portainer, toggle on "Ignore TLS/SSL error" because of the self-signed cert
6. Click Save

**Current monitors:**

| Name | URL | Notes |
|------|-----|-------|
| Portainer | `https://portainer:9443` | TLS/SSL error ignored |
| Homepage | `http://homepage:3000` | |
| Dozzle | `http://dozzle:8080` | Uses internal port (8080), not external (9999) |

**Setting up notifications:** Go to Settings → Notifications. You can connect to email, Discord, Telegram, Slack, and many others. Uptime Kuma will alert you when a service goes down and again when it comes back up.

**Status pages:** You can create a public-facing status page showing your services. Click "Status Pages" in the sidebar. Not needed now, but useful if others use your services later.

---

## Dozzle

**What it is:** Real-time container log viewer in your browser. Shows logs from all containers at once, with search and filtering.

**How to access:** `http://localhost:9999`

**How to use:**

- All your running containers are listed on the left sidebar
- Click a container to see its logs streaming in real-time
- Use the search bar at the top to filter log output
- Click multiple containers to view logs side by side

**When to use it:** When something breaks and you need to see error messages. When you just deployed a new service and want to watch it start up. When you're curious what your containers are doing.

**Zero maintenance required.** No config, no database, no setup. It just reads Docker logs.

---

## File Structure

```
~/homebase/
  ├── start.sh                          # Start all services
  ├── stop.sh                           # Stop all services
  ├── services/
  │   └── core/
  │       ├── docker-compose.yml        # Service definitions
  │       ├── config/                   # Hand-edited configs (git tracked)
  │       │   └── homepage/             # Homepage YAML configs
  │       └── volumes/                  # App-generated data (gitignored)
  │           ├── portainer/
  │           ├── uptime-kuma/
  │           └── dozzle/
  ├── docs/
  │   ├── decisions.md                  # Why you made each choice
  │   └── guide.md                      # This file
  └── backups/
```

**Rule:** `config/` = your stuff, goes in Git. `volumes/` = app data, gitignored.

---

## Adding a New Service

Every time you want to add something:

1. Find the official Docker image and read its docs
2. Add the service block to the appropriate `docker-compose.yml`
3. If it needs hand-edited config files, create `config/[service-name]/`
4. Run `docker compose up -d [service-name]`
5. Test it locally, then add it to Homepage and Uptime Kuma
6. `git add -A && git commit -m "Add [service-name]"`
7. Add a line to `docs/decisions.md`

**To remove a service:** Remove it from the compose file, run `docker compose up -d` (Docker removes the orphaned container), delete its config/volumes folders if you want.

---

## Backup

**What to back up:**

| Data | Method |
|------|--------|
| Compose files + configs (`~/homebase/` minus volumes) | Git push to private remote |
| Volume data | `tar -czf backup.tar.gz services/core/volumes/` |
| .env files (when you add them) | Encrypted copy in password manager |

**Quick backup command:**

```bash
cd ~/homebase
tar -czf ~/homebase-backup-$(date +%Y-%m-%d).tar.gz services/core/volumes/
```

**To restore on a new machine:**

1. Clone your Git repo
2. Extract the volumes backup into place
3. Run `./start.sh`
4. Everything comes back — services, data, configs

---

## Troubleshooting

**A service won't start:**

```bash
docker logs [container-name]
```

Or open Dozzle at `localhost:9999` and check the logs there.

**Port conflict:**

```bash
sudo lsof -i :[port-number]
```

Shows what's using that port. Change the external port mapping in your compose file.

**Container keeps restarting:**

Check logs first. Common causes: missing volume directory, bad config file, port conflict. Fix the issue, then `docker compose up -d` to recreate.

**Everything broke:**

```bash
cd ~/homebase/services/core
docker compose down
docker compose up -d
```

Nuclear option — stops and recreates all containers. Your data in `volumes/` is safe.

**Need to start fresh:**

```bash
docker compose down -v  # Warning: this deletes named volumes too
```

Then `docker compose up -d` for a clean slate. You'll need to redo Portainer and Uptime Kuma account setup.

---

## Phase 2 Prep

When you're ready for a dedicated Linux server, you'll add:

- **AdGuard Home** — DNS server for custom hostnames + ad blocking
- **Nginx Proxy Manager** — reverse proxy for clean URLs (no more port numbers)
- **Tailscale integration** — access everything from anywhere with proper DNS

These are saved in `docs/phase2-services.md`. They don't work well on macOS due to port 53 conflicts but run perfectly on Linux.
