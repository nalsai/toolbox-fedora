ARG FEDORA_VERSION=40
ARG FROM=registry.fedoraproject.org/fedora-toolbox:${FEDORA_VERSION}

FROM ${FROM}

# xdg-open wrapper allows seamlessly opening links in the host browser
RUN echo "Adding xdg-open wrapper ..." \
    && echo -e "if [[ -f \"/run/.containerenv\" ]]; then\n\tflatpak-spawn --host /usr/bin/xdg-open \"\$@\"\nelse\n\t/usr/bin/xdg-open \"\$@\"\nfi" | tee /usr/local/bin/xdg-open \
    && chmod +x /usr/local/bin/xdg-open

RUN echo "Installing RPM Fusion..." \
    && dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf -y groupupdate core

RUN echo "Installing packages..." \
    && dnf -y install bat cargo curl dotnet-sdk-8.0 eza fastfetch ffmpeg fish flatpak-builder git ghostscript gnome-tweaks htop hugo \
    librsvg2-tools neovim optipng ocrmypdf pandoc perl-Image-ExifTool pngquant poppler-utils ripgrep rust rustfmt rust-analyzer \
    tesseract-langpack-deu tesseract-langpack-eng tesseract-langpack-jpn tesseract-langpack-jpn_vert tesseract-osd \
    unpaper unrar unzip which yt-dlp zopfli flac

# TODO: replace ocrmypdf with pip version

RUN echo "Installing packages for resolve..." \
    && dnf -y install alsa-lib apr apr-util fontconfig freetype libglvnd-egl librsvg2 libXcursor libXi libXinerama libxkbcommon-x11 libXrandr libXrender libXtst mtdev pulseaudio-libs \
                      mesa-libGLU xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm \
    && dnf -y install alsa-plugins-pulseaudio libxcrypt-compat rocm-opencl

RUN echo "Installing VSCode..." \
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && sh -c "echo -e '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc' > /etc/yum.repos.d/vscode.repo" \
    && dnf -y install code

#RUN echo "Installing PowerShell..." \
#    && curl https://packages.microsoft.com/config/rhel/9/prod.repo | tee /etc/yum.repos.d/microsoft.repo \
#    && dnf -y install powershell

RUN echo "Installing gotop..." \
    && curl -Ss https://raw.githubusercontent.com/nalsai/dotfiles/main/linux/scripts/install_gotop.sh | bash

RUN echo "Compiling and installing jbig2enc..." \
    && dnf -y install automake libtool leptonica-devel zlib-devel gcc-c++ \
    && git clone https://github.com/agl/jbig2enc /tmp/jbig2enc \
    && cd /tmp/jbig2enc \
    && ./autogen.sh \
    && ./configure && make \
    && make install

RUN echo "Compiling and installing imgname..." \
    && mkdir -p /tmp/imgname \
    && cargo install --git https://github.com/nalsai/imgname --target-dir /tmp/imgname \
    && mv ~/.cargo/bin/imgname /usr/local/bin/ \
    && mkdir -p /usr/share/bash-completion/completions \
    && mkdir -p /usr/share/fish/completions \
    && mkdir -p /usr/share/zsh/site-functions \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/imgname.bash /usr/share/bash-completion/completions/imgname \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/imgname.fish /usr/share/fish/completions/imgname.fish \
    && install -m644 /tmp/imgname/release/build/imgname-*/out/_imgname /usr/share/zsh/site-functions/_imgname

RUN echo "Compiling and installing ripgrep-all..." \
    && cargo install --git https://github.com/phiresky/ripgrep-all --tag v1.0.0-alpha.5 \
    && mv ~/.cargo/bin/rga /usr/local/bin/ \
    && mv ~/.cargo/bin/rga-fzf /usr/local/bin/ \
    && mv ~/.cargo/bin/rga-fzf-open /usr/local/bin/ \
    && mv ~/.cargo/bin/rga-preproc /usr/local/bin/
