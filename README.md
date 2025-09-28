# My Fedora Toolbox

My personal toolbox/distrobox image.

```sh
podman pull ghcr.io/nalsai/toolbox-fedora:latest
distrobox rm my-distrobox -f
distrobox create -Y -n my-distrobox -i ghcr.io/nalsai/toolbox-fedora:latest

distrobox enter my-distrobox -- bash -c 'distrobox-export --app code'
distrobox enter my-distrobox -- bash -c 'distrobox-export --app gnome-tweaks'
```

The init-hooks script is in my [dotfiles](https://github.com/nalsai/dotfiles/): <https://github.com/nalsai/dotfiles/blob/main/linux/scripts/distrobox-fedora.sh>
