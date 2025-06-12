# Troubleshooting Guide

## Common Issues

### Bootloader Installation Failure

If you encounter this error:

```
Traceback (most recent call last):
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 435, in <module>
    main()
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 418, in main
    install_bootloader(args)
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 342, in install_bootloader
    raise Exception("could not find any previously installed systemd-boot")
Exception: could not find any previously installed systemd-boot
Failed to install bootloader
```

This can be solved by running:

```bash
sudo bootctl install
```

After that, run your nixos-rebuild command again:

```bash
sudo nixos-rebuild switch -I nixos-config=/path/to/configuration.nix
```
