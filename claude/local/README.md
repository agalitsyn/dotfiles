# Per project configuration

## Subscription routing

### Per project

Claude Code has two built-in mechanisms that solve this:
1. claude setup-token — generates a 1-year account-specific OAuth token (sk-ant-oat01-...)
2. CLAUDE_CODE_OAUTH_TOKEN env var — overrides stored credentials per-session

So first run `claude login` and then `claude setup-token` and put token into `<prj-root>/.claude/settings.local.json`


### Globally

1. Generate a claude setup-token for each account (valid 1 year)
2. Store tokens in macOS Keychain
3. Export env variable
```sh
export CLAUDE_CODE_OAUTH_TOKEN=$(security find-generic-password -s "claude-token" -a "$USER" -w)
```

### Per folder

use previous approach with `direnv`

