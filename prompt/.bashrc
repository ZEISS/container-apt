POWERLINE_ENABLED=0
export POWERLINE_ROOT="$(pip show powerline-status | sed -En 's/^.*Location:.(.*)$/\1/p' || '')"
if [ ! -z "$POWERLINE_ROOT" -a $POWERLINE_ENABLED -eq 1 ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    ${POWERLINE_ROOT}/powerline/bindings/bash/powerline.sh
fi

STARSHIP_ENABLED=1
if [ ${STARSHIP_ENABLED} -eq 1 ]; then
    eval "$(starship init bash)"
fi

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
fi