#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="${1}"
PV_WIDTH="${2}"
PV_HEIGHT="${3}"
IMAGE_CACHE_PATH="${4}"
PV_IMAGE_ENABLED="${5}"

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

# Handle RAW image formats
# Canon: cr2, cr3, crw
# Nikon: nef, nrw
# Sony: arw, srf, sr2
# Olympus: orf
# Fujifilm: raf
# Panasonic: rw2
# Pentax: pef, ptx
# Adobe: dng
# Other: raw, rwl, rwz
case "${FILE_EXTENSION_LOWER}" in
cr2 | cr3 | crw | nef | nrw | arw | srf | sr2 | orf | raf | rw2 | pef | ptx | dng | raw | rwl | rwz)
    # Convert RAW to JPEG for preview using ImageMagick
    # Exit code 6 means: display the cached image at IMAGE_CACHE_PATH
    if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        # Convert character dimensions to approximate pixel dimensions
        # Assuming average terminal font: ~8px width, ~16px height per character
        PX_WIDTH=$((PV_WIDTH * 8))
        PX_HEIGHT=$((PV_HEIGHT * 16))
        magick "${FILE_PATH}" -auto-orient -thumbnail "${PX_WIDTH}x${PX_HEIGHT}>" -quality 85 jpeg:"${IMAGE_CACHE_PATH}" && exit 6
        exit 1
    fi
    ;;
esac

# If we get here, use the default ranger scope script
# This will be at the system location
FALLBACK_SCOPE_PATH=$(dirname "$(readlink -f "$(which ranger)")")/../share/doc/ranger/config/scope.sh
if [[ -f "${FALLBACK_SCOPE_PATH}" ]]; then
    exec "${FALLBACK_SCOPE_PATH}" "$@"
else
    # Fallback: display file type
    echo '----- File Type Classification -----'
    file --dereference --brief -- "${FILE_PATH}"
    exit 5
fi
