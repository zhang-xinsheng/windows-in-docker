# DONT FORK IT IM NOT DONE WHY YOU FORK

# IT DOESNT WORK RIGHT NOW

# Windows in Docker | WIND

Browser > VNC > Docker > KVM > Windows

## WHY?

QEMU + KVM has a bunch of moving parts, not very user friendly.

This image is super user friendly, it comes with:

1. Browser UI

2. Networking out of the box

3. Literally single line install

4. Built-in Windows drivers

5. Crazy easy customizations, ie. `--cpus=9 --memory=6024 --size=120`

## Instructions

### Prerequisites

You hardware must be able to run `KVM`. (Most computer can run at least 1 layer of virtualization now days.)

### Install

Run the command below, and head to the noVNC at `-p 65080` to finish installation

```sh
docker -it --rm \
  -v /vm_image_dir:/config \
  -v /iso_dir:/install \
  msjpq/kvm-windows new <windows.iso>
```

Once you shutdown Windows. You will find the generated libvirt manifest under `/config`

#### Customization

Additional flags to pass onto `new <image name> <flag> <flag> ...`

| Flag        | Default  | Option                                                                    |
| ----------- | -------- | ------------------------------------------------------------------------- |
| `--bios`    | `False`  | Use `bios` instead of `uefi`                                              |
| `-os`       | `win10`  | Windows distro                                                            |
| `--cpus`    | `#cores` | Number of virtual cpus                                                    |
| `--memory`  | `4000`   | (MB)                                                                      |
| `--vram`    | `256`    | (MB)                                                                      |
| `--size`    | `100`    | (GB)                                                                      |
| `--dry-run` | `False`  | Dry run                                                                   |
| `--extra`   | `None`   | Extra args for [`virt-install`](https://linux.die.net/man/1/virt-install) |

### Environmental Variables

#### noVNC UI

- `-e PATH_PREFIX=/`
- `-e VNC_RESIZE=scale|off`
- `-e RECON_DELAY=250` reconnection delay (ms)
- `-e PAGE_TITLE=KVM`

#### Virtualization

Libvirt look for `VM_NAME.xml` to boot.

- `-e VM_NAME=wind`

### Ports

- `-p 80:65080` noVNC web UI

- `-p 5900:65059` VNC

### Volumes

Libvirt manifests are stored in`/config`, along with VM images.

- `-v ./vm_data:/config`

You need to supply your own `windows.iso`, for obvious reasons.

- `-v ./install_media:/install`

### Disclaimer

Works on my machine ™.

