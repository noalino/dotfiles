FROM alpine:3.13

LABEL maintainer "https://github.com/benoitgelineau"

ENV LANG 'en_US.UTF8'

# Common packages
RUN apk update && apk add --no-cache \
      bash \
      curl \
      git \
      neovim \
      nodejs=14.15.4-r0 \
      tmux \
      tzdata \
      yarn>1.22.10 \
      zsh

# Symlink a lib to make golang work
RUN mkdir /lib64 \
      && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Setup timezone
ENV TZ 'Europe/Paris'
RUN echo $TZ > /etc/timezone

# Create a user to run Docker as non-root
ARG USER_ID
ARG USER_NAME
RUN adduser --uid $USER_ID --disabled-password --shell /bin/zsh $USER_NAME $USER_NAME
USER $USER_NAME
ENV HOME /home/$USER_NAME

# Install golang with user permission to install packages
RUN mkdir $HOME/lib
RUN wget -O $HOME/go.tar.gz https://golang.org/dl/go1.15.8.linux-amd64.tar.gz
RUN tar -C $HOME/lib -xzf $HOME/go.tar.gz
RUN rm $HOME/go.tar.gz

# Install oh-my-zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Create dir to handle user permissions
RUN mkdir $HOME/.config
RUN mkdir $HOME/go

# Add dotfiles
COPY --chown=$USER_NAME:$USER_NAME ./zsh/* $HOME/
COPY --chown=$USER_NAME:$USER_NAME ./tmux/* $HOME/
COPY --chown=$USER_NAME:$USER_NAME ./nvim/ $HOME/.config/nvim/

# Install oh-my-zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install Tmux plugins 
RUN git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
RUN git clone https://github.com/wfxr/tmux-power $HOME/.tmux/plugins/tmux-power

# Install neovim plugin manager
RUN curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
RUN nvim --headless +PlugInstall +qall

# Enable colors
ENV TERM=xterm-256color

ENTRYPOINT ["tmux"]
