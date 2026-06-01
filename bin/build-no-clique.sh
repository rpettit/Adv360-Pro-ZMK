#!/usr/bin/env bash

set -eu

PWD=$(pwd)
TIMESTAMP="${TIMESTAMP:-$(date -u +"%Y%m%d%H%M")}"
COMMIT="${COMMIT:-$(echo xxxxxx)}"

west build -s zmk/app -p -d build/left -b adv360_left -- -DZMK_CONFIG="${PWD}/config"
grep -vE '(^#|^$)' build/left/zephyr/.config
cp build/left/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2"

if [ "${BUILD_RIGHT}" = true ]; then
    west build -s zmk/app -p -d build/right -b adv360_right -- -DZMK_CONFIG="${PWD}/config"
    grep -vE '(^#|^$)' build/right/zephyr/.config
    cp build/right/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2"
fi
