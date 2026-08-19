#!/bin/bash

# Claude Code Status Line Command
# Ghostty Vesper Theme Colors

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')

# Vesper theme colors (using ANSI escape codes)
RED='\033[38;2;245;161;145m'      # #f5a191 - salmon (model name)
GREEN='\033[38;2;144;185;159m'    # #90b99f - sage (progress bar & git branch)
YELLOW='\033[38;2;255;199;153m'   # #ffc799 - bright peach (percentage)
TAN='\033[38;2;230;185;157m'      # #e6b99d - warm tan (project name)
LAVENDER='\033[38;2;172;161;207m' # #aca1cf - lavender (login name)
DIMGRAY='\033[38;2;126;126;126m'  # #7e7e7e - dim gray (separators)
RESET='\033[0m'

# Context bar shape. BAR_FILLED/BAR_EMPTY are the glyphs, BAR_WIDTH the length.
BAR_WIDTH=12
BAR_FILLED='⣿'
BAR_EMPTY='⣀'

# Usage-window tuning. RATE_WARN_AT/RATE_CRIT_AT drive the colour of the
# percentage; RATE_RESET_HINT_AT is the point past which the "resets in"
# countdown earns its screen space (0 = always show it, 101 = never).
RATE_WARN_AT=50
RATE_CRIT_AT=80
RATE_RESET_HINT_AT=50

# Pick a palette colour for a 0-100 usage percentage: calm while there is room,
# warm past the halfway mark, alarming once the window is nearly spent.
usage_color() {
  local pct=${1%%.*}
  if [[ $pct -ge $RATE_CRIT_AT ]]; then
    printf '%s' "$RED"
  elif [[ $pct -ge $RATE_WARN_AT ]]; then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$GREEN"
  fi
}

# Render seconds-until-reset as a compact "2h05m" / "43m".
fmt_countdown() {
  local target=${1%%.*} now remain hours mins
  now=$(date +%s)
  remain=$((target - now))
  [[ $remain -lt 0 ]] && remain=0
  hours=$((remain / 3600))
  mins=$(((remain % 3600) / 60))
  if [[ $hours -gt 0 ]]; then
    printf '%dh%02dm' "$hours" "$mins"
  else
    printf '%dm' "$mins"
  fi
}

# Get project name (basename of project directory)
project_name=$(basename "$project_dir")

# Get Claude account login (OAuth email) from ~/.claude.json
account_login=""
if [[ -r "$HOME/.claude.json" ]]; then
  account_login=$(jq -r '.oauthAccount.emailAddress // empty' "$HOME/.claude.json" 2>/dev/null)
fi

# Get git branch if in a git repository
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    git_branch="$branch"
  fi
fi

# Get context window information
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Get Claude.ai subscription usage windows. Absent for API-key auth and until the
# first API response of a session, so every consumer below must tolerate empty.
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# Build status line
output=""

# Model name in red/salmon
output+=$(printf "${RED}%s${RESET}" "$model")

# Reasoning effort, colored by intensity so overrides stand out
if [[ -n "$effort" ]]; then
  case "$effort" in
    xhigh|max) effort_color="$RED" ;;
    high)      effort_color="$YELLOW" ;;
    *)         effort_color="$DIMGRAY" ;;
  esac
  output+=$(printf "${DIMGRAY}:${RESET}${effort_color}%s${RESET}" "$effort")
fi

# Context window, as a single indicator: progress bar plus percentage
if [[ -n "$used_pct" ]] && [[ "$used_pct" != "null" ]]; then
  filled=$(printf "%.0f" $(echo "scale=2; $used_pct * $BAR_WIDTH / 100" | bc 2>/dev/null || echo "0"))
  empty=$((BAR_WIDTH - filled))

  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}${BAR_FILLED}"; done
  for ((i=0; i<empty; i++)); do bar="${bar}${BAR_EMPTY}"; done

  output+=$(printf " ${GREEN}%s${RESET}" "$bar")
  output+=$(printf " ${YELLOW}%.0f%%${RESET}" "$used_pct")
fi

# 5-hour session window usage, next to the context figures it competes with
if [[ -n "$five_pct" ]]; then
  five_color=$(usage_color "$five_pct")
  output+=$(printf " ${DIMGRAY}|${RESET} ${DIMGRAY}5h${RESET} ${five_color}%.0f%%${RESET}" "$five_pct")

  if [[ -n "$five_reset" ]] && [[ ${five_pct%%.*} -ge $RATE_RESET_HINT_AT ]]; then
    output+=$(printf " ${DIMGRAY}(%s)${RESET}" "$(fmt_countdown "$five_reset")")
  fi
fi

# Add project name
output+=$(printf " ${DIMGRAY}|${RESET} ${TAN}%s${RESET}" "$project_name")

# Add git branch if available
if [[ -n "$git_branch" ]]; then
  output+=$(printf " ${DIMGRAY}|${RESET} ${GREEN}%s${RESET}" "$git_branch")
fi

# Add Claude account login
if [[ -n "$account_login" ]]; then
  output+=$(printf " ${DIMGRAY}|${RESET} ${LAVENDER}%s${RESET}" "$account_login")
fi

printf "%s" "$output"
