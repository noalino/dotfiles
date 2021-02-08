FROM ubuntu:latest
# Be unobstrusive for automatic installs
ENV DEBIAN_FRONTEND noninteractive

# Update and upgrade repo
RUN apt-get update -y -q \
    && apt-get upgrade -y -q

# Locales
RUN apt-get update -y && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG 'en_US.utf8'

# Common packages
RUN apt-get update -y && apt-get install -y \
      build-essential \
      curl \
      git \
      neovim \
      tmux \
      tzdata \
      zsh

# Install Node.js LTS (useful for cocvim)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Setup timezone
ENV TZ 'Europe/Paris'
RUN echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Create a user to run Docker as non-root
ARG USER_ID
ARG USER_NAME
RUN useradd -u $USER_ID -U -ms /usr/bin/zsh $USER_NAME
USER $USER_NAME

# Install oh-my-zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Create dir to handle permissions
RUN mkdir /home/$USER_NAME/.config
# Add dotfiles
COPY --chown=$USER_NAME:$USER_NAME ./zsh/* /home/$USER_NAME/
COPY --chown=$USER_NAME:$USER_NAME ./tmux/* /home/$USER_NAME/
COPY --chown=$USER_NAME:$USER_NAME ./nvim/ /home/$USER_NAME/.config/nvim/

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
