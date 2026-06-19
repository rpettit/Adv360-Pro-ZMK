#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIRMWARE_DIR="${REPO_ROOT}/firmware"

latest_firmware() {
    local side="$1"
    local firmware

    firmware="$(ls -t "${FIRMWARE_DIR}"/*-"${side}".uf2 2>/dev/null | head -n 1 || true)"
    if [[ -z "${firmware}" ]]; then
        echo "No ${side} firmware found in ${FIRMWARE_DIR}. Run make first." >&2
        exit 1
    fi

    printf '%s\n' "${firmware}"
}

mount_roots() {
    if [[ -n "${FLASH_MOUNT:-}" ]]; then
        dirname "${FLASH_MOUNT}"
        return
    fi

    case "$(uname -s)" in
        Darwin)
            printf '%s\n' /Volumes
            ;;
        Linux)
            printf '%s\n' "/media/${USER}" "/run/media/${USER}"
            ;;
        *)
            printf '%s\n' /Volumes "/media/${USER}" "/run/media/${USER}"
            ;;
    esac
}

uf2_mounts() {
    if [[ -n "${FLASH_MOUNT:-}" ]]; then
        if [[ -d "${FLASH_MOUNT}" ]]; then
            printf '%s\n' "${FLASH_MOUNT}"
        fi
        return
    fi

    while IFS= read -r root; do
        [[ -d "${root}" ]] || continue

        find "${root}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r mount; do
            if [[ -f "${mount}/INFO_UF2.TXT" || -f "${mount}/UF2_INFO.TXT" || -f "${mount}/CURRENT.UF2" ]]; then
                printf '%s\n' "${mount}"
            fi
        done
    done < <(mount_roots)
}

is_uf2_mount() {
    local mount="$1"

    [[ -d "${mount}" && ( -f "${mount}/INFO_UF2.TXT" || -f "${mount}/UF2_INFO.TXT" || -f "${mount}/CURRENT.UF2" ) ]]
}

wait_for_mount() {
    local side="$1"
    local mounts=()
    local mount

    echo >&2
    echo "Reset the ${side} half into bootloader mode now." >&2

    while true; do
        mounts=()
        while IFS= read -r mount; do
            mounts+=("${mount}")
        done < <(uf2_mounts)

        if [[ "${#mounts[@]}" -eq 1 ]]; then
            printf '%s\n' "${mounts[0]}"
            return
        fi

        if [[ "${#mounts[@]}" -gt 1 ]]; then
            echo "Multiple UF2 bootloader drives are mounted; waiting for only one:" >&2
            printf '  %s\n' "${mounts[@]}" >&2
        fi

        sleep 1
    done
}

wait_for_unmount() {
    local mount="$1"
    local timeout="${2:-0}"
    local elapsed=0

    while is_uf2_mount "${mount}"; do
        if [[ "${timeout}" -gt 0 && "${elapsed}" -ge "${timeout}" ]]; then
            return 1
        fi

        sleep 1
        elapsed=$((elapsed + 1))
    done
}

flash_half() {
    local side="$1"
    local firmware="$2"
    local mount
    local copy_status=0
    local copy_error

    mount="$(wait_for_mount "${side}")"
    copy_error="$(mktemp "${TMPDIR:-/tmp}/adv360-flash.XXXXXX")"

    echo "Copying $(basename "${firmware}") to ${mount}"
    cp "${firmware}" "${mount}/" 2>"${copy_error}" || copy_status=$?

    if [[ "${copy_status}" -ne 0 ]]; then
        if ! wait_for_unmount "${mount}" 10; then
            cat "${copy_error}" >&2
            rm -f "${copy_error}"
            echo "Copy failed and ${mount} stayed mounted." >&2
            return "${copy_status}"
        fi

        rm -f "${copy_error}"
        echo "${side} half reset during copy; assuming flash was accepted."
        return 0
    fi

    rm -f "${copy_error}"
    sync

    echo "Waiting for ${side} half to reboot..."
    wait_for_unmount "${mount}"
}

left_firmware="$(latest_firmware left)"
right_firmware="$(latest_firmware right)"

echo "Left firmware:  ${left_firmware}"
echo "Right firmware: ${right_firmware}"

flash_half left "${left_firmware}"
echo
echo "Left half flashed. Plug in or reset the right half when ready."
flash_half right "${right_firmware}"

echo
echo "Both halves flashed."
