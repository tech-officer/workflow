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
TARGET="" PROJECT="" FOUNDER="" DOMAIN="" DEV_URL="" WEEKDAY="" OVERWRITE="ask"
DEV_URL_SET=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project)   PROJECT="${2:-}"; shift 2 ;;
    --founder)   FOUNDER="${2:-}"; shift 2 ;;
    --domain)    DOMAIN="${2:-}"; shift 2 ;;
    --dev-url)   DEV_URL="${2:-}"; DEV_URL_SET=1; shift 2 ;;
    --weekday)   WEEKDAY="${2:-}"; shift 2 ;;
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
FOUNDER_INITIAL=$(printf '%s' "$FOUNDER" | cut -c1 | tr '[:lower:]' '[:upper:]')
DATE=$(date +%Y-%m-%d)
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)   # fills {ISO-8601-WITH-TIMEZONE} (STATUS.md front matter)

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
  local src="$TPL/$1" rel="$2" dst="$TARGET/$2"
  render < "$src" > "$TMP"
  if [ -e "$dst" ]; then
    if cmp -s "$TMP" "$dst"; then UNCHANGED+=("$rel"); return; fi
    confirm_overwrite "$rel" || { SKIPPED+=("$rel"); return; }
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$TMP" "$dst"
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
  render < "$TPL/$1" > "$dst"
  WROTE+=("$rel")
}

# boot-prompts.md is generated, not a template.
install_boot_prompts() {
  cat > "$TMP" <<EOF
# Boot prompts — $PROJECT (generated by the TechOfficer workflow installer)

> Copy-paste blocks. Every prompt uses the same vendor-neutral read order:
> **AGENTS.md → STATUS.md → FOUNDER.md → your brief** (in \`docs/briefs/\`).
> The prompt says who you are; the repo files are the job. Operating
> procedures live in \`docs/plans/04-operating-model.md\`.

## CTO session — new project (no roadmap yet)

\`\`\`
You are the CTO session for $PROJECT. I am $FOUNDER (founder). Read, in
order: AGENTS.md → STATUS.md → FOUNDER.md — then follow the "CTO boot — new
project" procedure in docs/plans/04-operating-model.md. You write NO feature
code. Start the interview now.
\`\`\`

## CTO session — existing project (repo has real history)

\`\`\`
You are the CTO session for $PROJECT. I am $FOUNDER (founder). Read, in
order: AGENTS.md → STATUS.md → FOUNDER.md — then follow the "CTO boot —
existing project" procedure in docs/plans/04-operating-model.md. You write
NO feature code. Start the audit now.
\`\`\`

## CTO or executor — successor session (a handoff exists)

\`\`\`
You are the {ROLE} session for $PROJECT. I am $FOUNDER (founder). Your
predecessor left a handoff: read the highest-numbered file in docs/handoff/,
then AGENTS.md → STATUS.md → FOUNDER.md, and follow the "CTO boot —
successor session" procedure in docs/plans/04-operating-model.md. Prove
you're oriented before touching the queue.
\`\`\`

## Executor session (one per brief)

\`\`\`
You are an executor session for $PROJECT, assigned brief {BRIEF_ID}. Read,
in order: AGENTS.md → STATUS.md → FOUNDER.md → your brief's FULL text in
docs/briefs/. I am $FOUNDER (founder). Follow the "Executor boot" procedure
in docs/plans/04-operating-model.md: claim in STATUS.md first, one branch,
one PR that proves the acceptance checklist. Start with the claim now.
\`\`\`

## Ask the dying session for a handoff

\`\`\`
Your context is nearly full. Write docs/handoff/NNN-<era>.md (next number,
structure per 000-TEMPLATE.md), including anything we discussed that is NOT
yet written elsewhere in the repo. Commit on your branch and open a PR —
write for a reader with zero chat history.
\`\`\`
EOF
  local rel="docs/ops/boot-prompts.md" dst="$TARGET/docs/ops/boot-prompts.md"
  if [ -e "$dst" ]; then
    if cmp -s "$TMP" "$dst"; then UNCHANGED+=("$rel"); return; fi
    confirm_overwrite "$rel" || { SKIPPED+=("$rel"); return; }
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$TMP" "$dst"
  WROTE+=("$rel")
}

# --- install ------------------------------------------------------------------
printf '\nInstalling the TechOfficer workflow into %s\n' "$TARGET"
printf '  project=%s founder=%s (%s) domain=%s dev=%s reports=%s\n\n' \
  "$PROJECT" "$FOUNDER" "$FOUNDER_INITIAL" "$DOMAIN" "$DEV_URL" "$WEEKDAY"

install_file STATUS.md           STATUS.md
install_agents_md
install_adapter adapters/CLAUDE.md CLAUDE.md
install_adapter adapters/GEMINI.md GEMINI.md
install_file FOUNDER.md          FOUNDER.md
install_file DECISIONS.md        DECISIONS.md
install_file ../docs/appendix/ceo-pack.md docs/appendix/ceo-pack.md
install_file ../docs/appendix/overlays.md docs/appendix/overlays.md
install_file plans-00-INDEX.md   docs/plans/00-INDEX.md
install_file 02-program-plan.md  docs/plans/02-program-plan.md
install_file 04-operating-model.md docs/plans/04-operating-model.md
install_file briefs-README.md    docs/briefs/README.md
install_file handoff-template.md docs/handoff/000-TEMPLATE.md
install_file report-checklist.md docs/reports/README.md
install_boot_prompts

# --- report -------------------------------------------------------------------
report() { local title="$1"; shift; [ $# -gt 0 ] || return 0; printf '%s\n' "$title"; printf '  %s\n' "$@"; }
report "Written:"            ${WROTE[@]+"${WROTE[@]}"}
report "Skipped (existing):" ${SKIPPED[@]+"${SKIPPED[@]}"}
report "Already up to date:" ${UNCHANGED[@]+"${UNCHANGED[@]}"}

cat <<EOF

Done. Next steps:
  1. cd $TARGET && git add -A && git commit -m "chore: TechOfficer workflow scaffold"
     — commit straight to main this ONCE; it's the last direct push to main.
  2. Open an AI coding session on the repo and paste ONE prompt from
     docs/ops/boot-prompts.md:
       - empty/new repo      → "CTO session — new project"
       - repo with history   → "CTO session — existing project"
  3. Everything after that, the CTO session drives.
EOF
