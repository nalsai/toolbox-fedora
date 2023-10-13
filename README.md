# My Fedora Toolbox

My personal toolbox/distrobox image.

```sh
podman image pull toolbox-fedora:latest
distrobox rm my-distrobox -f
distrobox create -Y -n my-distrobox -i ghcr.io/nalsai/toolbox-fedora:latest --init-hooks "bash $HOME/.dotfiles/linux/scripts/distrobox-fedora.sh"
```

The init-hooks script is in my [dotfiles](https://github.com/nalsai/dotfiles/): <https://github.com/nalsai/dotfiles/blob/main/linux/scripts/distrobox-fedora.sh>
