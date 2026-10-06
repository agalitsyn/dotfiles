source ~/.config/agterm/agent-status/shell/integration.sh

# Tint the scratch terminal so it can't be mistaken for the main pane (umputun/agterm#239).
# p10k rebuilds PROMPT on every precmd, so the marker is a p10k segment rather than a PROMPT edit.
if [[ $AGTERM_PANE == scratch ]]; then
  printf '\e]11;#2a1f33\a'   # OSC 11: set this pane's background color
  function prompt_agterm_scratch() { p10k segment -f magenta -t '[scratch]' }
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(agterm_scratch $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS)
fi
