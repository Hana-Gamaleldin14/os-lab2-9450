cat << 'EOF' > antivirus-cron.sh
#!/bin/bash

DIR="/tmp/os_lab_dir"
MALICIOUS_DIR="/tmp/os_lab_malicious"
WHITELIST_FILE="/tmp/os_lab_dir/.whitelist"

mkdir -p "$DIR" "$MALICIOUS_DIR"
touch "$WHITELIST_FILE"

EXTENSIONS=("exe" "bat" "vbs" "scr" "ps1")
KEYWORDS=("virus" "trojan" "malware" "worm" "ransomware")

for file in "$DIR"/*; do
    [ -f "$file" ] || continue

    if grep -Fxq "$file" "$WHITELIST_FILE" 2>/dev/null; then
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
        echo "$(date): $filename is malicious and it is DELETED" >> /tmp/antivirus_cron.log
        cp "$file" "$MALICIOUS_DIR/$filename"
        rm -f "$file"
    fi
done
EOF
