#!/usr/bin/env bash
# install.sh — install the TechOfficer workflow into a target repo.
#
#   ./install.sh /path/to/your-repo
#
# Asks for the placeholder values (or takes them from flags), then writes:
#   AGENTS.md                 the operating-protocol block (created, or appended
#                             if AGENTS.md exists; never duplicated)
#   CLAUDE.md, GEMINI.md      thin adapters pointing at AGENTS.md — written ONLY
#                             if absent (an existing adapter is never clobbered)
#   STATUS.md                 the board, WITH Contract-v2.1 YAML front matter
#   FOUNDER.md                the founder → session channel
#   DECISIONS.md              the append-only decision ledger (rejected
#                             options, accepted risks, cross-cutting rulings)
#   docs/appendix/ceo-pack.md the strategy-advisor pack procedure (🧪
#                             unproven; installed from the kit's own appendix)
#   docs/appendix/overlays.md the overlay pattern (process-only layer on a
#                             repo you don't own; installed from the kit)
#   docs/ skeleton            plans, briefs, handoff, ops, reports
#   docs/ops/boot-prompts.md  ready-to-paste session prompts (vendor-neutral
#                             read order: AGENTS.md → STATUS.md → FOUNDER.md → brief)
# Never overwrites an existing file without asking.
#
# Windows: run under Git Bash (ships with Git for Windows) or WSL:
#   bash install.sh C:/path/to/your-repo
#
# Flags (any value not given is asked interactively):
#   --project NAME     project name            (fills {PROJECT})
#   --founder NAME     founder's name          (fills {FOUNDER}, {FOUNDER_INITIAL})
#   --domain TEXT      product area            (fills {DOMAIN})
#   --dev-url URL      dev environment URL     (fills {DEV_URL}; empty = "—")
#   --weekday DAY      bi-weekly report day    (fills {WEEKDAY}; default Monday)
#   --render-time UTC   explicit YYYY-MM-DDTHH:MM:SSZ for reproducible installs
#   --overwrite MODE   ask (default) | skip | force   — for existing files
#   -h | --help        this text

set -euo pipefail

die() { printf 'install.sh: %s\n' "$*" >&2; exit 1; }

usage() { awk 'NR>1 && !/^#/{exit} NR>1{sub(/^# ?/,""); print}' "$0"; }

lc() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# --- locate the kit ---------------------------------------------------------
KIT_DIR=$(cd "$(dirname "$0")" && pwd)
TPL="$KIT_DIR/templates"
[ -d "$TPL" ] || die "templates/ not found next to install.sh ($TPL). Run the script from a full copy of the kit."

# --- parse args --------------------------------------------------------------
TARGET="" PROJECT="" FOUNDER="" DOMAIN="" DEV_URL="" WEEKDAY="" OVERWRITE="ask" RENDER_TIME=""
DEV_URL_SET=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project)   PROJECT="${2:-}"; shift 2 ;;
    --founder)   FOUNDER="${2:-}"; shift 2 ;;
    --domain)    DOMAIN="${2:-}"; shift 2 ;;
    --dev-url)   DEV_URL="${2:-}"; DEV_URL_SET=1; shift 2 ;;
    --weekday)   WEEKDAY="${2:-}"; shift 2 ;;
    --render-time) RENDER_TIME="${2:-}"; shift 2 ;;
    --overwrite) OVERWRITE="${2:-}"; shift 2 ;;
    -h|--help)   usage; exit 0 ;;
    -*)          die "unknown flag: $1 (see --help)" ;;
    *)           [ -z "$TARGET" ] && TARGET="$1" || die "unexpected extra argument: $1"; shift ;;
  esac
done
case "$OVERWRITE" in ask|skip|force) ;; *) die "--overwrite must be ask, skip or force" ;; esac

# --- target ------------------------------------------------------------------
if [ -z "$TARGET" ]; then
  [ -t 0 ] || die "no target path given (usage: ./install.sh /path/to/repo)"
  read -r -p "Target repo path: " TARGET
fi
TARGET=$(cd "$TARGET" 2>/dev/null && pwd) || die "target is not an existing directory: use 'git init <dir>' first"
[ -d "$TARGET/.git" ] || printf 'note: %s is not a git repo (no .git). Installing anyway.\n' "$TARGET"

# --- collect answers ----------------------------------------------------------
ask() { # ask VAR "question" "default"
  local var="$1" q="$2" def="${3-}" val
  val="${!var}"
  if [ -z "$val" ]; then
    if [ ! -t 0 ]; then
      [ -n "$def" ] && { printf -v "$var" '%s' "$def"; return; }
      die "missing value for $var and no terminal to ask on (see --help for the flag)"
    fi
    if [ -n "$def" ]; then read -r -p "$q [$def]: " val; val="${val:-$def}"
    else while [ -z "$val" ]; do read -r -p "$q: " val; done; fi
    printf -v "$var" '%s' "$val"
  fi
}
ask PROJECT "Project name (e.g. gollai)"
ask FOUNDER "Your name (the founder)"
ask DOMAIN  "Product domain (e.g. 'e-commerce for Turkish SMEs')"
if [ "$DEV_URL_SET" -eq 0 ] && [ -z "$DEV_URL" ]; then
  if [ -t 0 ]; then read -r -p "Dev environment URL (Enter if none yet): " DEV_URL; fi
fi
[ -z "$DEV_URL" ] && DEV_URL="—"
ask WEEKDAY "Bi-weekly report weekday" "Monday"
# Reject values that would be interpreted by later render passes or break records.
for value in "$PROJECT" "$FOUNDER" "$DOMAIN" "$DEV_URL" "$WEEKDAY"; do
  [ "${#value}" -le 500 ] || die "render value exceeds 500 characters"
  [[ "$value" != *$'\n'* ]] || die "newline in render value"
  [[ "$value" != *'{'* && "$value" != *'}'* ]] || die "ambiguous render token in value"
  if printf '%s' "$value" | LC_ALL=C grep -q '[[:cntrl:]]'; then die "control character in render value"; fi
done
[[ "$PROJECT" != *'"'* && "$PROJECT" != *'\'* ]] || die "project cannot contain quote or backslash"
FOUNDER_INITIAL=$(printf '%s' "${FOUNDER:0:1}" | tr '[:lower:]' '[:upper:]')
NOW="${RENDER_TIME:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
[[ "$NOW" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]] || die "invalid render time"
year=$((10#${NOW:0:4})); month=$((10#${NOW:5:2})); day=$((10#${NOW:8:2}))
hour=$((10#${NOW:11:2})); minute=$((10#${NOW:14:2})); second=$((10#${NOW:17:2}))
[ "$year" -ge 1 ] && [ "$month" -ge 1 ] && [ "$month" -le 12 ] && [ "$hour" -lt 24 ] && [ "$minute" -lt 60 ] && [ "$second" -lt 60 ] || die "invalid render time"
days=31
case "$month" in 4|6|9|11) days=30 ;; 2) days=28; if (( year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) )); then days=29; fi ;; esac
[ "$day" -ge 1 ] && [ "$day" -le "$days" ] || die "invalid render time"
DATE="${NOW%%T*}"

# --- rendering ----------------------------------------------------------------
esc() { printf '%s' "$1" | sed -e 's/[\\&]/\\&/g'; }
SEP=$(printf '\001')
render() { # render < src > dst
  sed -e "s${SEP}{PROJECT}${SEP}$(esc "$PROJECT")${SEP}g" \
      -e "s${SEP}{FOUNDER_INITIAL}${SEP}$(esc "$FOUNDER_INITIAL")${SEP}g" \
      -e "s${SEP}{FOUNDER}${SEP}$(esc "$FOUNDER")${SEP}g" \
      -e "s${SEP}{DOMAIN}${SEP}$(esc "$DOMAIN")${SEP}g" \
      -e "s${SEP}{DEV_URL}${SEP}$(esc "$DEV_URL")${SEP}g" \
      -e "s${SEP}{WEEKDAY}${SEP}$(esc "$WEEKDAY")${SEP}g" \
      -e "s${SEP}{DATE}${SEP}$(esc "$DATE")${SEP}g" \
      -e "s${SEP}{ISO-8601-WITH-TIMEZONE}${SEP}$(esc "$NOW")${SEP}g"
}

WROTE=() SKIPPED=() UNCHANGED=()
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

check_destination() {
  local rel="$1" part current="$TARGET"
  [[ "$rel" =~ ^[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)*$ ]] || die "unsafe destination"
  local oldifs="$IFS"; IFS='/'; read -r -a parts <<< "$rel"; IFS="$oldifs"
  for part in "${parts[@]}"; do
    [[ "$part" != '.' && "$part" != '..' && "$part" != '.git' ]] || die "unsafe destination"
    current="$current/$part"
    [ ! -L "$current" ] || die "symlink destination refused"
  done
  [ ! -e "$current" ] || [ -f "$current" ] || die "nonregular destination refused"
}

confirm_overwrite() { # confirm_overwrite <relative-path> -> 0 write, 1 skip
  case "$OVERWRITE" in
    force) return 0 ;;
    skip)  return 1 ;;
  esac
  [ -t 0 ] || { printf '  exists, skipping (no terminal to ask; use --overwrite force): %s\n' "$1"; return 1; }
  local a; read -r -p "  $1 exists and differs — overwrite? [y/N] " a
  [ "$(lc "$a")" = "y" ]
}

install_file() { # install_file <template-file> <relative-dest>
  local src="$KIT_DIR/$1" rel="$2" dst="$TARGET/$2"
  render < "$src" > "$TMP"
  if [ -e "$dst" ]; then
    if cmp -s "$TMP" "$dst"; then UNCHANGED+=("$rel"); return; fi
    confirm_overwrite "$rel" || { SKIPPED+=("$rel"); return; }
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$TMP" "$dst"
  chmod 644 "$dst"
  WROTE+=("$rel")
}

# AGENTS.md is special: strip the leading how-to comment; append if one exists.
install_agents_md() {
  local rel="AGENTS.md" dst="$TARGET/AGENTS.md"
  render < "$TPL/AGENTS-section.md" | awk 'BEGIN{skip=1} skip&&/-->/{skip=0;next} !skip' | sed -e '/./,$!d' > "$TMP"
  if [ -e "$dst" ]; then
    if grep -q '## Team & status protocol' "$dst"; then
      UNCHANGED+=("$rel (protocol block already present)"); return
    fi
    if [ "$OVERWRITE" = "skip" ]; then SKIPPED+=("$rel"); return; fi
    if [ "$OVERWRITE" = "ask" ] && [ -t 0 ]; then
      local a; read -r -p "  AGENTS.md exists — append the workflow protocol block to it? [Y/n] " a
      [ "$(lc "$a")" = "n" ] && { SKIPPED+=("$rel"); return; }
    fi
    { printf '\n'; cat "$TMP"; } >> "$dst"
    WROTE+=("$rel (protocol block appended)")
  else
    cp "$TMP" "$dst"
  chmod 644 "$dst"
    WROTE+=("$rel")
  fi
}

# Adapters (CLAUDE.md, GEMINI.md) are written ONLY if absent: an existing
# adapter may be load-bearing for someone's setup, so it is never clobbered —
# not even asked about, and --overwrite force does not apply.
install_adapter() { # install_adapter <template-file> <relative-dest>
  local rel="$2" dst="$TARGET/$2"
  if [ -e "$dst" ]; then SKIPPED+=("$rel (exists — adapters are never overwritten)"); return; fi
  mkdir -p "$(dirname "$dst")"
  render < "$KIT_DIR/$1" > "$dst"
  chmod 644 "$dst"
  WROTE+=("$rel")
}

# --- install ------------------------------------------------------------------
printf '\nInstalling the TechOfficer workflow into %s\n' "$TARGET"
printf '  project=%s founder=%s (%s) domain=%s dev=%s reports=%s\n\n' \
  "$PROJECT" "$FOUNDER" "$FOUNDER_INITIAL" "$DOMAIN" "$DEV_URL" "$WEEKDAY"

# A bounded declarative map is shared with the offline candidate exporter.
# Preflight every destination before any write; never follow adopter links.
while IFS='|' read -r source destination policy action; do
  [ -n "$source" ] || continue
  [[ "$source" != \#* ]] || continue
  check_destination "$destination"
done < "$KIT_DIR/managed-files.tsv"
while IFS='|' read -r source destination policy action; do
  [ -n "$source" ] || continue
  [[ "$source" != \#* ]] || continue
  case "$action" in
    file) install_file "$source" "$destination" ;;
    agents) install_agents_md ;;
    adapter) install_adapter "$source" "$destination" ;;
    *) die "invalid installation action" ;;
  esac
done < "$KIT_DIR/managed-files.tsv"

# --- report -------------------------------------------------------------------
report() { local title="$1"; shift; [ $# -gt 0 ] || return 0; printf '%s\n' "$title"; printf '  %s\n' "$@"; }
report "Written:"            ${WROTE[@]+"${WROTE[@]}"}
report "Skipped (existing):" ${SKIPPED[@]+"${SKIPPED[@]}"}
report "Already up to date:" ${UNCHANGED[@]+"${UNCHANGED[@]}"}

cat <<EOF

Installation report only: skipped files are not verified current; no installed release is certified.

Done. Next steps:
  1. cd $TARGET && git add -A && git commit -m "chore: TechOfficer workflow scaffold"
     — commit straight to main this ONCE; it's the last direct push to main.
  2. Open an AI coding session on the repo and paste ONE prompt from
     docs/ops/boot-prompts.md:
       - empty/new repo      → "CTO session — new project"
       - repo with history   → "CTO session — existing project"
  3. Everything after that, the CTO session drives.
EOF
