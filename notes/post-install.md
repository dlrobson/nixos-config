# Post-Installation Steps

## Tailscale serve services

To serve syncthing at `https://<tailscale-hostname>/syncthing/`, you can use the following command:

```
sudo tailscale serve --bg --set-path=/syncthing/ 127.0.0.1:8384
```

To serve forgejo

```
sudo tailscale serve --bg --set-path=/forgejo/ 127.0.0.1:3000

## Manual Configuration

After installing NixOS, complete these manual steps:

1. Configure ssh-keys + Add to GitHub