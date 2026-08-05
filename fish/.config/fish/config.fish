if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

set -gx PAGER less
set -gx EDITOR vim
set -gx VISUAL vim

# Set my workspace path for Go code
set -gx GOPATH $HOME/go
set -gx GOBIN $GOPATH/bin

set -gx ANSIBLE_NOCOWS 1

fish_add_path -P $HOME/bin $GOBIN $HOME/.local/bin $HOME/.poetry/bin $HOME/.cargo/bin /usr/local/games /usr/games

kubectl completion fish | source

direnv hook fish | source

# set -g direnv_fish_mode eval_on_arrow    # trigger direnv at prompt, and on every arrow-based directory change (default)
# set -g direnv_fish_mode eval_after_arrow # trigger direnv at prompt, and only after arrow-based directory changes before executing command
# set -g direnv_fish_mode disable_arrow    # trigger direnv at prompt only, this is similar functionality to the original behavior

set -g nvm_default_version lts

function __nvm_auto --on-variable PWD
    if test -e .nvmrc -o -e .node-version
        nvm use
    end
end

__nvm_auto
