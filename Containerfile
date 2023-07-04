ARG FEDORA_VERSION=38
ARG FROM=registry.fedoraproject.org/fedora-toolbox:${FEDORA_VERSION}

FROM ${FROM}

RUN echo "Installing RPM Fusion..." \
    && dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf -y groupupdate core

RUN echo "Installing packages..." \
    && dnf -y install bat cargo curl dotnet-sdk-7.0 exa fastfetch ffmpeg fish flatpak-builder git gnome-tweaks htop hugo \
    librsvg2-tools neovim optipng ocrmypdf pandoc perl-Image-ExifTool poppler-utils ripgrep rust rustfmt \
    tesseract-langpack-deu tesseract-langpack-eng tesseract-langpack-jpn tesseract-osd \
    unrar unzip which yt-dlp zopfli

RUN echo "Installing packages for resolve..." \
    && dnf -y install mesa-libGLU xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm libxcrypt-compat rocm-opencl

RUN echo "Installing host-spawn..." \
    && host_spawn_version="1.4.1" \
    && curl -L "https://github.com/1player/host-spawn/releases/download/${host_spawn_version}/host-spawn-$(uname -m)" -o /usr/bin/host-spawn \
    && chmod +x /usr/bin/host-spawn

RUN echo "Installing jbig2enc..." \
    && dnf -y install automake libtool leptonica-devel zlib-devel gcc-c++ \
    && git clone https://github.com/agl/jbig2enc /tmp/jbig2enc \
    && cd /tmp/jbig2enc \
    && ./autogen.sh \
    && ./configure && make \
    && make install

RUN echo "Installing VSCode..." \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && sh -c "echo -e '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc' > /etc/yum.repos.d/vscode.repo" \
    && dnf -y install code

RUN echo "Adding xdg-open wrapper ..." \
    && echo -e "if [[ -f \"/run/.containerenv\" ]]; then\n\tflatpak-spawn --host /usr/bin/xdg-open \"\$@\"\nelse\n\t/usr/bin/xdg-open \"\$@\"\nfi" | tee /usr/local/bin/xdg-open \
    && chmod +x /usr/local/bin/xdg-open

RUN echo "Installing PowerShell..." \
    && curl https://packages.microsoft.com/config/rhel/8/prod.repo | tee /etc/yum.repos.d/microsoft.repo \
    && dnf -y install powershell

RUN curl -Ss https://raw.githubusercontent.com/nalsai/dotfiles/main/linux/scripts/install_gotop.sh | bash

RUN echo "Installing imgname..." \
    && mkdir -p /tmp/imgname \
    && CARGO_TARGET_DIR=/tmp/imgname cargo install --git https://github.com/nalsai/imgname \
    && mkdir -p /usr/share/bash-completion/completions \
    && mkdir -p /usr/share/fish/completions \
    && mkdir -p /usr/share/zsh/site-functions \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/imgname.bash /usr/share/bash-completion/completions/imgname \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/imgname.fish /usr/share/fish/completions/imgname.fish \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/_imgname /usr/share/zsh/site-functions/_imgname

RUN echo "Installing ripgrep-all..." \
    && cargo install --git https://github.com/phiresky/ripgrep-all --tag v1.0.0-alpha.5
