set -gx PATH $HOME/.cargo/bin $PATH

function tmux
    command tmux -f $HOME/.config/tmux/tmux.conf $argv
end

function pass
    env PASSWORD_STORE_DIR=$HOME/.config/password-store pass $argv
end
