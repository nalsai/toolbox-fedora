# My Fedora Toolbox

My personal toolbox/distrobox image.

```fish
distrobox rm my-distrobox --force
distrobox create -Y -n my-distrobox -i ghcr.io/nalsai/toolbox-fedora:latest --init-hooks "bash /home/nalsai/.dotfiles/linux/scripts/distrobox-fedora.sh"
```

The init-hooks script is in my dotfiles: <https://github.com/Nalsai/dotfiles/>
