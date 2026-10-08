#!/bin/bash

DIR="${1:-./dir}"
MALICIOUS_DIR="${2:-./malicious_dir}"
WHITELIST_FILE=".whitelist"

touch "$WHITELIST_FILE"

while true; do
    shopt -s nullglob
    files=("$MALICIOUS_DIR"/*)
    shopt -u nullglob

    if [ ${#files[@]} -eq 0 ]; then
        echo "No malicious files to review."
        exit 0
    fi

    echo ""
    echo "Quarantined Files"
    i=1
    for f in "${files[@]}"; do
        echo "$i) $(basename "$f")"
        ((i++))
    done
    echo "$i) Exit"

    read -rp "Select a file by number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$i" ]; then
        echo "Invalid choice"
        continue
    fi

    if [ "$choice" -eq "$i" ]; then
        echo "Exiting review"
        exit 0
    fi

    selected_file="${files[$((choice-1))]}"
    filename=$(basename "$selected_file")

    echo "Selected: $filename"
    echo "1) Restore this file back into $DIR"
    echo "2) Permanently delete this file from $MALICIOUS_DIR"
    echo "3) Leave this file as it is and go back to list"
    read -rp "Option: " opt

    case "$opt" in
        1)
            mv "$selected_file" "$DIR/$filename"
            echo "$DIR/$filename" >> "$WHITELIST_FILE"
            echo "Restored $filename to $DIR."
            ;;
        2)
            rm -f "$selected_file"
            echo "$filename permanently deleted."
            ;;
        3)
            continue
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
