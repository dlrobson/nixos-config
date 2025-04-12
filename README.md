# nixos-config

## Manual Machine Configuration

1. Configure ssh-keys + Add to GitHub
2. To allow vscode-server service to run:
```
systemctl --user enable auto-fix-vscode-server.service
systemctl --user start auto-fix-vscode-server.service
```