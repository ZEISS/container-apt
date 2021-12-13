
if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
fi

if [ -f /usr/local/bin/starship ]; then
    eval "$(starship init bash)"
fi
