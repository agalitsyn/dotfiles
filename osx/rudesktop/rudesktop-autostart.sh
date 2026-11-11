#!/bin/bash
# Turn RuDesktop autostart off or back on.
#
#   sudo ./rudesktop-autostart.sh disable   # disable launchd jobs, move plists to backup
#   sudo ./rudesktop-autostart.sh enable    # restore plists, enable and load jobs
#        ./rudesktop-autostart.sh status
#
# `launchctl disable` keeps the jobs off even if a RuDesktop update reinstalls the plists.
set -u

daemon=ru.desktop.RuDesktop_dispatcher
agents=(ru.desktop.RuDesktop_launcher ru.desktop.RuDesktop_session ru.desktop.RuDesktop_settings_launcher)
backup="/Library/Application Support/RuDesktop-launchd-backup"

need_root() {
  [ "$(id -u)" -eq 0 ] || { echo "run with sudo" >&2; exit 1; }
  uid="${SUDO_UID:?run via sudo from your user, not as root}"
}

status() {
  local uid="${SUDO_UID:-$(id -u)}"
  echo "--- plists:"
  ls /Library/LaunchDaemons/ru.desktop.RuDesktop_* /Library/LaunchAgents/ru.desktop.RuDesktop_* 2>/dev/null
  echo "--- backup:"
  ls "$backup" 2>/dev/null
  echo "--- disabled overrides:"
  launchctl print-disabled system | grep -i rudesk
  launchctl print-disabled "gui/$uid" | grep -i rudesk
}

disable() {
  need_root
  mkdir -p "$backup"
  launchctl disable "system/$daemon"
  for a in "${agents[@]}"; do launchctl disable "gui/$uid/$a"; done
  mv -v /Library/LaunchDaemons/ru.desktop.RuDesktop_*.plist "$backup"/ 2>/dev/null
  mv -v /Library/LaunchAgents/ru.desktop.RuDesktop_*.plist "$backup"/ 2>/dev/null
  echo "running RuDesktop processes stay up until reboot or logout"
}

enable() {
  need_root
  [ -f "$backup/$daemon.plist" ] && mv -v "$backup/$daemon.plist" /Library/LaunchDaemons/
  for a in "${agents[@]}"; do
    [ -f "$backup/$a.plist" ] && mv -v "$backup/$a.plist" /Library/LaunchAgents/
  done
  rmdir "$backup" 2>/dev/null

  launchctl enable "system/$daemon"
  launchctl bootstrap system "/Library/LaunchDaemons/$daemon.plist" 2>/dev/null
  for a in "${agents[@]}"; do
    launchctl enable "gui/$uid/$a"
    launchctl bootstrap "gui/$uid" "/Library/LaunchAgents/$a.plist" 2>/dev/null
  done
}

case "${1:-}" in
  disable) disable; status ;;
  enable) enable; status ;;
  status) status ;;
  *) echo "usage: $0 disable|enable|status" >&2; exit 2 ;;
esac
