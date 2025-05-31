# Restic + Age Integration

This document describes how our NixOS system uses Restic for backups with Age for secret management.

## Configuration

In our NixOS configuration, we use the following setup to manage Restic backups with Age-encrypted secrets:

```nix
age = {
  identityPaths = [ "$HOME/.ssh/id_ed25519" ];
  secrets = {
    "restic/env".file = ../../../secrets/restic/env.age;
    "restic/bucket".file = ../../../secrets/restic/bucket.age;
    "restic/password".file = ../../../secrets/restic/password.age;
  };
};

services.restic.backups = {
  daily = {
    initialize = true;
    environmentFile = config.age.secrets."restic/env".path;
    repositoryFile = config.age.secrets."restic/bucket".path;
    passwordFile = config.age.secrets."restic/password".path;
    
    paths = [
      "$HOME/dev"
    ];
    
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];
  };
};
```

## Useful Restic Commands

Based on command history, here are some useful restic-daily commands:

| Command | Description |
|---------|-------------|
| `sudo restic-daily snapshots` | List all snapshots |
| `sudo restic-daily check` | Check repository for errors |
| `sudo restic-daily ls latest` | List files in the most recent snapshot |
| `sudo restic-daily diff latest latest~1` | Compare latest snapshot with previous one |
| `sudo restic-daily list --repo nixos-server [path]` | List backup contents for specific repository and path |
| `journalctl -u restic-backups-daily.service` | Check the logs for the restic daily backup service |
| `sudo systemctl start restic-backups-daily.service` | Manually start the backup service |

## Age Secret Management

To edit secrets with agenix:

```bash
agenix -e restic/env.age
agenix -e restic/bucket.age
agenix -e restic/password.age
```

To re-key secrets with a new Age identity:

```bash
agenix -r
```

## Checking Backup Status

```bash
# Check backup status
systemctl status restic-backups-daily.service

# View logs
journalctl -u restic-backups-daily.service
```

## References

- [Restic Backups to B2 with NixOS](https://www.arthurkoziel.com/restic-backups-b2-nixos/)
