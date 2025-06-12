# TPM Setup Guide

## Enrolling TPM2 with LUKS2

Enroll the TPM2 chip with the LUKS2 partition. This is required for unlocking the LUKS2 partition at boot time.

```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/disk/by-uuid/<LUKS2 partition>
```

This allows the system to automatically unlock the encrypted boot partition using the TPM module rather than requiring manual password entry during the boot process.