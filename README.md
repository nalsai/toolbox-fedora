# My Fedora Toolbox

My personal toolbox/distrobox image.

```sh
distrobox create -Y -n my-distrobox -i ghcr.io/nalsai/toolbox-fedora:latest --init-hooks "bash $HOME/.dotfiles/linux/scripts/distrobox-fedora.sh"
```

```sh
podman image pull toolbox-fedora:latest
```

The init-hooks script is in my [dotfiles](https://github.com/nalsai/dotfiles/): <https://github.com/nalsai/dotfiles/blob/main/linux/scripts/distrobox-fedora.sh>
