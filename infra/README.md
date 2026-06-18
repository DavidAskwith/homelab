# Incus

## Physical Server Installation

1. Download [IncusOS](https://incusos-customizer.linuxcontainers.org/) image
    - Enable "Wipe target drive"
    - Enable the "Degraded boot security (no TPM 2.0 module)" for the m93p since it only has TPM 1.2
2. Follow the install [instructions](https://linuxcontainers.org/incus-os/docs/main/getting-started/installation/physical)
3. Follow connection [instructions](https://linuxcontainers.org/incus-os/docs/main/getting-started/access/) to test and setup the auth for tofu

## Authenticateing a new client

1. On an authenticated client, run `incus config trust add <hostname>:<new-client-name>`
2. Add the host on the new client `incus remote add <hostname> <ip>`
3. Alternatively, you can copy the `client.key` and `client.crt` from the authenticated client to the new client in `~/.config/incus` to authenticate with the server.

## Authentication

Default auth is TLS `client.key` and `client.crt` are stored in `~/.config/incus` tofu uses these to auth with the server.

## Common Commands

- `incus image list images: type=virtual-machine` - List available VM images

# Naming and IP Standards

## Physical Server
- Host Name: `virt-<0-91-9>`
- IP: `10.0.0.1<0-9>`

## Virtual Server Nodes
- Host Name: `node-<type>-<0-91-9>`
- IP: `10.0.0.2{0-9}`

## Virtual Server Nodes
- Host Name:
- IP: `10.0.0.<3-91-9>`
