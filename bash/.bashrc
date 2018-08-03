[ -d "$HOME/Code/Go" ] && export GOPATH=$HOME/Code/Go
[ -d "$HOME/Code/Go/bin" ] && export PATH=$PATH:$GOPATH/bin
[ -d "$HOME/Code/Scripts" ] && export PATH=$PATH:$HOME/Code/Scripts
[ -d "$HOME/.cargo/bin" ] && export PATH=$PATH:$HOME/.cargo.bin

[ "$(command -v fd >/dev/null)" ] && [ "$(command -v fzf >/dev/null)" ] && export FZF_DEFAULT_COMMAND="fd"

[ "$(command -v fd >/dev/null)" ] && [ "$(command -v sk >/dev/null)" ] && export SKIM_DEFAULT_COMMAND="fd"

if command -v sk-share >/dev/null; then
    # shellcheck source=/dev/null
    . "$HOME/.config/sk-share/key-bindings.bash"
    # shellcheck source=/dev/null
    . "$HOME/.config/sk-share/completion.bash"
elif command -v fzf-share >/dev/null; then
    # shellcheck source=/dev/null
    . "$(fzf-share)/key-bindings.bash"
    # shellcheck source=/dev/null
    . "$(fzf-share)/completion.bash"
fi

# shellcheck source=/home/stu/.travis/travis.sh
[ -f "$HOME/.travis/travis.sh" ] && . "$HOME/.travis/travis.sh"

if command -v pass >/dev/null; then
    export PASSWORD_STORE_DIR="$HOME/.config/password-store"
fi

# ======================= Aliases ======================= #

if command -v hub >/dev/null; then
    alias git='hub'
fi

if command -v docker >/dev/null; then
    alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'
fi

if command -v tmux >/dev/null; then
    alias tmux='tmux -f "$HOME/.config/tmux/tmux.conf"'
fi

if command -v exa >/dev/null; then
  alias ls='exa'
  alias la='exa -aghl --git'
fi
