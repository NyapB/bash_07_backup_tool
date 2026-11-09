#!/bin/bash

# SETTINGS / DEFAULTS
DEST="$HOME/backups"
KEEP=5


# FUNCTIONS

# Display usage instructions and exit
usage() {
    cat << EOF
Usage: $(basename "$0") [-d DEST] [-k KEEP] SOURCE

Options:
  -d DEST    Backup destination directory (default: ~/backups)
  -k KEEP    Number of newest backups to keep (default: 5)
  -h         Show this help message and exit
EOF
    exit 0
}

# Print error message to stderr and exit with a code
die() {
    local msg="$1"
    local code="${2:-1}"
    echo "Error: $msg" >&2
    exit "$code"
}

# Create the compressed tarball archive
create_backup() {
    local src="$1"
    local dest="$2"
    
    # Extract just the folder name (e.g., /path/to/project -> project)
    local folder_name
    folder_name=$(basename "$src")
    
    # Generate timestamped filename
    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    local archive_name="${folder_name}-${timestamp}.tar.gz"
    local full_dest_path="${dest}/${archive_name}"
    
    # Get parent directory and target folder name for clean path extraction (-C)
    local parent_dir
    parent_dir=$(dirname "$src")
    
    # Execute backup using -C to change directory and strip absolute paths
    if tar -czf "$full_dest_path" -C "$parent_dir" "$folder_name"; then
        echo "Successfully created backup: $archive_name"
    else
        die "Tar compression failed" 1
    fi
}

# Clean up old backups exceeding the KEEP limit
rotate_backups() {
    local src="$1"
    local dest="$2"
    local keep="$3"
    
    local folder
    folder=$(basename "$src")
    
    # Enforce precise structural matching on the timestamp segment to prevent over-matching similar prefixes
    # e.g., prevents folder "proj" matching "proj-foo"
    local pattern="${folder}-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9].tar.gz"
    
    # Find matching files, sort cleanly by filename descending (newest timestamp first), and prune
    local count=0
    while IFS= read -r -d '' file; do
        ((count++))
        if (( count > keep )); then
            rm -f "$file"
        fi
    done < <(find "$dest" -maxdepth 1 -name "$pattern" -type f -print0 | sort -z -r)
}

# Main 
main() {
    # 1. Parse options using getopts
    local opt
    while getopts "d:k:h" opt; do
        case "$opt" in
            d) DEST="$OPTARG" ;;
            k) KEEP="$OPTARG" ;;
            h) usage ;;
            *) die "Invalid option specified" 2 ;;
        esac
    done
    shift $((OPTIND - 1))

    # 2. Extract and validate SOURCE positional argument
    local source_dir="$1"
    if [[ -z "$source_dir" ]]; then
        die "Missing SOURCE directory argument" 2
    fi

    # 3. Defensive Input Validation
    if [[ ! -d "$source_dir" ]]; then
        die "SOURCE path '$source_dir' does not exist or is not a folder" 2
    fi

    # Resolve relative sources (like "." or "../") into a real canonical absolute folder name before backup execution
    source_dir=$(cd "$source_dir" && pwd)

    if [[ ! "$KEEP" =~ ^[1-9][0-9]*$ ]]; then
        die "KEEP value (-k) must be a positive whole number (got: '$KEEP')" 2
    fi

    # 4. Prepare Destination Environment
    if [[ ! -d "$DEST" ]]; then
        mkdir -p "$DEST" || die "Failed to create destination directory '$DEST'" 1
    fi

    # 5. Run Workflow Actions
    create_backup "$source_dir" "$DEST"
    rotate_backups "$source_dir" "$DEST" "$KEEP"
}


main "$@"
