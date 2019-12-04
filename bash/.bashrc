[ -d "$HOME/Code/Go" ] && export GOPATH=$HOME/Code/Go
[ -d "$HOME/Code/Go/bin" ] && export PATH=$PATH:$GOPATH/bin
[ -d "$HOME/Code/Scripts" ] && export PATH=$PATH:$HOME/Code/Scripts
[ -d "$HOME/.cargo/bin" ] && export PATH=$PATH:$HOME/.cargo.bin

if command -v fzf-share >/dev/null; then
    # shellcheck source=/dev/null
    . "$(fzf-share)/key-bindings.bash"
    # shellcheck source=/dev/null
    . "$(fzf-share)/completion.bash"

    [ "$(command -v rg >/dev/null)" ] && export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob "!.git/*""
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

if command -v remind >/dev/null; then
    alias remind='remind -m'
fi

alias dotfiles='git --git-dir=/home/stu/.cfg/ --work-tree=/home/stu'
