#!/usr/bin/env bash
firefox &
sleep 2
i3-msg "[class=firefox] move to workspace \"2\""
