alias godoc-http='echo "Starting webserver on port: 6060" && godoc -http=:6060'

# Alias for git. Used for version-controlling the dotfiles in the home dir
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias dc='docker compose'

alias gitlog='git log --oneline --all --graph'
alias git-add-ignore-whitespace='git diff -U0 -w --no-color --src-prefix=a/ --dst-prefix=b/ | git apply --cached --ignore-whitespace --unidiff-zero -'

alias myip="curl -sS https://ifconfig.io"

alias sshuttle_home='sshuttle --dns -r jumpbox 0.0.0.0/0'

alias local_http='echo "Serving files in current dir on http://localhost:8127/" && webfsd -F -i 127.0.0.1 -p 8127 -r ./'

# Copy stdin to clipboard
alias cb="fish_clipboard_copy"

# Copy contents of a file
function cbf
    cat "$argv[1]" | fish_clipboard_copy
end

# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"

# Copy current working directory
alias cbwd="pwd | fish_clipboard_copy"

# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | fish_clipboard_copy"

function cert_info
    echo -n | openssl s_client -showcerts -servername "$argv[1]" -connect "$argv[1]":443 2>/dev/null | openssl x509 -inform pem -noout -text
end

alias userctl="systemctl --user"

alias brownnoise="sox -q -c 2 -r 32000 -n -d -D synth 12:00:00 brownnoise vol 0.5 tremolo 0.0625 50 fade t 3"

# alias gemini-cli="npx https://github.com/google-gemini/gemini-cli"

if test "$TERM" = xterm-kitty
    # alias ssh="TERM=xterm-256color ssh"
    alias ssh="kitty +kitten ssh"
end

alias worldtime='curl -sS -H "x-rapidapi-host: world-time-api3.p.rapidapi.com" -H "x-rapidapi-key: $WORLDTIME_API_KEY" https://world-time-api3.p.rapidapi.com/ip | jq -r .datetime'
