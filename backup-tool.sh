#!/bin/bash
#
# backup.sh - create timestamped backups of a folder
# Usage: backup.sh [-d DEST] [-k KEEP] [-v] SOURCE
# Author: Ama Nkeng, Rebase Code Camp
#
# ---- settings ---------------------------------------------------
DEST="#HOME/backups"

if [[ ! -d "$DEST" ]]; then
    mkdir -p "$HOME/backups"
    echo "Backup has been created in home"
fi
KEEP=5
VERBOSE=false

#archive name
src="/home/Becky/Documents"
tar -czf "Documents-$(date +%Y%m%d-%H%M%S).tar.gz" -C "$(DEST "$src")" "$(basename "$src")"

#list backups newest first, skip the first keep, delete the rest
ls -lt "DEST"/Documents-*.tar.gz | tail -n +$((KEEP +1)) | while IFS= read -r old; do
    rm -- "$old"
done 

#----Helper function------------
Usage(){
    cat <<EOF
Usage: $(basename "$0") [ -d DEST ] [-k KEEP ] [-v] SOURCE

options:
    -d DEST where to store backups (default: $DEST)
    -k KEEP how many backups to keep (default: $KEEP)
    -V      verbose output
    -h      show this help
EOF
}

die() {
    echo "Error: $*" >&2 #$* is all arguments joined in to one
    exit 1
}
log() {
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date +%H:%M:%S)] $*"
    fi
}

#-----------Main Logic---------------------------------------
main(){
    :
}