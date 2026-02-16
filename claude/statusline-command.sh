#!/bin/bash

# Claude Code Status Line Command
# Ghostty Vesper Theme Colors

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Vesper theme colors (using ANSI escape codes)
RED='\033[38;2;245;161;145m'      # #f5a191 - salmon (model name)
GREEN='\033[38;2;144;185;159m'    # #90b99f - sage (progress bar & git branch)
YELLOW='\033[38;2;255;199;153m'   # #ffc799 - bright peach (percentage)
TAN='\033[38;2;230;185;157m'      # #e6b99d - warm tan (project name)
DIMGRAY='\033[38;2;126;126;126m'  # #7e7e7e - dim gray (separators)
WHITE='\033[38;2;255;255;255m'    # #ffffff - white (token counts)
RESET='\033[0m'

# Get project name (basename of project directory)
project_name=$(basename "$project_dir")

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
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Build status line
output=""

# Model name in red/salmon
output+=$(printf "${RED}%s${RESET}" "$model")

# Context window info if available
if [[ -n "$used_pct" ]] && [[ "$used_pct" != "null" ]]; then
  # Calculate total tokens used
  total_tokens=$((total_input + total_output))

  # Create progress bar (12 characters wide)
  bar_width=12
  filled=$(printf "%.0f" $(echo "scale=2; $used_pct * $bar_width / 100" | bc 2>/dev/null || echo "0"))
  empty=$((bar_width - filled))

  bar="["
  for ((i=0; i<filled; i++)); do bar="${bar}="; done
  for ((i=0; i<empty; i++)); do bar="${bar} "; done
  bar="${bar}]"

  # Format tokens with k suffix for thousands
  if [[ $total_tokens -ge 1000 ]]; then
    tokens_used=$(printf "%.0fk" $(echo "scale=0; $total_tokens / 1000" | bc))
  else
    tokens_used="${total_tokens}"
  fi

  # Format context size with k suffix
  if [[ $context_size -ge 1000 ]]; then
    tokens_max=$(printf "%.0fk" $(echo "scale=0; $context_size / 1000" | bc))
  else
    tokens_max="${context_size}"
  fi

  # Add progress bar in green
  output+=$(printf " ${GREEN}%s${RESET}" "$bar")

  # Add percentage in yellow
  output+=$(printf " ${YELLOW}%.0f%%${RESET}" "$used_pct")

  # Add separator in dim gray
  output+=$(printf " ${DIMGRAY}|${RESET}")

  # Add token counts in white
  output+=$(printf " ${WHITE}%s/%s${RESET}" "$tokens_used" "$tokens_max")
fi

# Add git branch if available
if [[ -n "$git_branch" ]]; then
  output+=$(printf " ${DIMGRAY}|${RESET} ${GREEN}%s${RESET}" "$git_branch")
fi

# Add project name
output+=$(printf " ${DIMGRAY}|${RESET} ${TAN}%s${RESET}" "$project_name")

printf "%s" "$output"
