#!/bin/bash

# Claude Code Status Line Command
# Based on Powerlevel10k configuration (lean style)

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Get relative path for display
if [[ "$cwd" == "$HOME" ]]; then
  display_path="~"
else
  display_path="${cwd#$HOME/}"
  if [[ "$display_path" == "$cwd" ]]; then
    display_path="$cwd"
  else
    display_path="~/$display_path"
  fi
fi

# Get git branch if in a git repository
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    git_branch=" ($branch)"
  fi
fi

# Get context window information
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Build context info string
context_info=""
if [[ -n "$used_pct" ]] && [[ "$used_pct" != "null" ]]; then
  # Calculate total tokens used
  total_tokens=$((total_input + total_output))

  # Create progress bar (10 characters wide)
  bar_width=10
  filled=$(printf "%.0f" $(echo "scale=2; $used_pct * $bar_width / 100" | bc))
  empty=$((bar_width - filled))

  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done

  # Format tokens with K suffix for thousands
  if [[ $total_tokens -ge 1000 ]]; then
    tokens_used=$(printf "%.1fK" $(echo "scale=1; $total_tokens / 1000" | bc))
  else
    tokens_used="${total_tokens}"
  fi

  # Format context size with K suffix
  if [[ $context_size -ge 1000 ]]; then
    tokens_max=$(printf "%.0fK" $(echo "scale=0; $context_size / 1000" | bc))
  else
    tokens_max="${context_size}"
  fi

  context_info=$(printf " \033[2m[%s]\033[0m \033[2m%.0f%%\033[0m \033[2m%s/%s\033[0m" \
    "$bar" "$used_pct" "$tokens_used" "$tokens_max")
fi

# Build the status line with dimmed colors
printf "\033[2m%s%s\033[0m \033[2m%s\033[0m%s" \
  "$display_path" "$git_branch" "$model" "$context_info"
