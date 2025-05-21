# Docker Configuration

This document explains how to configure Docker rootless.

## Creating a Rootless Docker Context

To use rootless Docker, you need to set up a Docker context that points to the rootless socket:

```bash
docker context create rootless --docker host=unix:///run/user/1000/docker.sock --description "Rootless Docker context"
```

> **Note**: The `1000` in the path should be replaced with your actual user ID if different. You can find your user ID by running `id -u`.

### Using the Rootless Context

Once created, you can switch to the rootless context with:

```bash
docker context use rootless
```

To view all available contexts:

```bash
docker context ls
```
