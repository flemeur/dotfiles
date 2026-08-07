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

fish_add_path -P $HOME/bin $GOBIN $HOME/.cargo/bin

devenv hook fish | source

kubectl completion fish | source
