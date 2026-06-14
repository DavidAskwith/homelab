# Incus

## Physical Server Installation

1. Download [IncusOS](https://incusos-customizer.linuxcontainers.org/) image
    - Enable "Wipe target drive"
    - Enable the "Degraded boot security (no TPM 2.0 module)" for the m93p since it only has TPM 1.2
2. Follow the install [instructions](https://linuxcontainers.org/incus-os/docs/main/getting-started/installation/physical)
3. Follow connection [instructions](https://linuxcontainers.org/incus-os/docs/main/getting-started/access/) to test and setup the auth for tofu

## Authentication

Default auth is TLS `client.key` and `client.crt` are stored in `~/.config/incus` tofu uses these to auth with the server.
