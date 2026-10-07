#!/bin/bash

DIR="${1:-./dir}"
MALICIOUS_DIR="${2:-./malicious_dir}"
INTERVAL="${3:-5}"

LAST_INFO="directory-info.last"
NEW_INFO="directory-info.new"
WHITELIST_FILE=".whitelist"

mkdir -p "$MALICIOUS_DIR"
touch "$WHITELIST_FILE"

EXTENSIONS=("exe" "bat" "vbs" "scr" "ps1")
KEYWORDS=("virus" "trojan" "malware" "worm" "ransomware")

is_whitelisted() {
    local filepath="$1"
    grep -Fxq "$filepath" "$WHITELIST_FILE" 2>/dev/null
}

scan_directory() {
    for file in "$DIR"/*; do
        [ -f "$file" ] || continue

        if is_whitelisted "$file"; then
            continue
        fi

        is_malicious=0

        filename=$(basename "$file")
        ext="${filename##*.}"
        if [ "$filename" != "$ext" ]; then
            for bad_ext in "${EXTENSIONS[@]}"; do
                if [ "$ext" == "$bad_ext" ]; then
                    is_malicious=1
                    break
                fi
            done
        fi

        if [ $is_malicious -eq 0 ]; then
            for kw in "${KEYWORDS[@]}"; do
                if grep -iq "$kw" "$file" 2>/dev/null; then
                    is_malicious=1
                    break
                fi
            done
        fi

        if [ $is_malicious -eq 1 ]; then
            echo "$filename is malicious and it is DELETED"
            cp "$file" "$MALICIOUS_DIR/$filename"
            rm -f "$file"
        fi
    done
}

echo "Starting Antivirus Daemon monitoring '$DIR' every $INTERVAL seconds..."

scan_directory
ls -l "$DIR" > "$LAST_INFO"

while true; do
    sleep "$INTERVAL"
    ls -l "$DIR" > "$NEW_INFO"

    if ! cmp -s "$LAST_INFO" "$NEW_INFO"; then
        scan_directory
        cp "$NEW_INFO" "$LAST_INFO"
    fi
done
