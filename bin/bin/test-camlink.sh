#!/usr/bin/env sh

# exec cvlc v4l2:///dev/video4 --transform-type=hflip --video-filter "transform{true}"

exec mpv --vf=hflip /dev/video4
