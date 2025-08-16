#!/bin/bash
set -e

# =======================================
# generate_ip_ranges.sh
# Generate IP ranges header file from ip_ranges.txt
# Usage: ./generate_ip_ranges.sh
# =======================================

# Terminal colors
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    CYAN="$(tput setaf 6)"
    BOLD="$(tput bold)"
    RESET="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    CYAN=""
    BOLD=""
    RESET=""
fi

# Configuration
INPUT_FILE="ip_ranges.txt"
TEMP_FILE="$(mktemp)"
OUTPUT_FILE="../src/ip_ranges.h"

echo "${BOLD}${BLUE}IP Range Generator${RESET}"
echo "Converting IP ranges to header file..."
echo
echo -e "${BLUE}==================== GENERATION START ====================${RESET}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "${RED}Error: $INPUT_FILE not found!${RESET}"
    exit 1
fi

# Normalize line endings (Windows CRLF -> LF)
tr -d '\r' < "$INPUT_FILE" > "$TEMP_FILE"
INPUT_FILE="$TEMP_FILE"

# Remove old output
if [ -f "$OUTPUT_FILE" ]; then
    echo "${YELLOW}Removing existing $OUTPUT_FILE${RESET}"
    rm "$OUTPUT_FILE"
fi

# Function to convert IP to hex
ip_to_hex() {
    local ip=$1
    local IFS='.'
    local parts=($ip)
    printf "0x%02x%02x%02x%02x" "${parts[0]}" "${parts[1]}" "${parts[2]}" "${parts[3]}"
}

# Start generating the header file
cat > "$OUTPUT_FILE" << 'EOF'
#ifndef IP_RANGES_H
#define IP_RANGES_H

#include "includes.h"

#ifdef IP_MODE_CUSTOM

struct ip_range custom_ip_ranges[] = {
EOF

# Process each line
range_count=0
while IFS= read -r line || [ -n "$line" ]; do
    # Trim leading/trailing whitespace
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # Skip empty lines or comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Remove trailing comma and whitespace
    line="$(echo "$line" | sed 's/[[:space:]]*,[[:space:]]*$//')"

    # Regex: Match start_ip - end_ip (with optional spaces), now with no trailing comma
    if [[ "$line" =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*-[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*$ ]]; then
        start_ip="${BASH_REMATCH[1]}"
        end_ip="${BASH_REMATCH[2]}"

        start_hex=$(ip_to_hex "$start_ip")
        end_hex=$(ip_to_hex "$end_ip")

        echo "    {$start_hex, $end_hex}," >> "$OUTPUT_FILE"
        echo "${GREEN}Added:${RESET} $start_ip - $end_ip"
        range_count=$((range_count + 1))
    else
        echo "${YELLOW}Skipping invalid line:${RESET} $line"
    fi
done < "$INPUT_FILE"

# Finish header file
cat >> "$OUTPUT_FILE" << 'EOF'
};

int custom_ip_ranges_len = sizeof(custom_ip_ranges) / sizeof(struct ip_range);

#endif

#endif
EOF

# Clean up temp file
rm "$TEMP_FILE"

echo
echo -e "${GREEN}==================== GENERATION COMPLETE ====================${RESET}"
echo "${GREEN}Success!${RESET} Generated $OUTPUT_FILE"
echo "Processed $range_count IP ranges"