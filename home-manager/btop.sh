#!/usr/bin/env bash
kitty btop &
sleep 2
i3-msg "[class=kitty] move to workspace \"2\""
