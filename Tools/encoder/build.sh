#!/bin/bash
set -e

# =======================================
# build.sh
# Simple build script for encoder project
# =======================================

# =======================================
# Colors
# =======================================
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    RED="$(tput setaf 1)"
    CYAN="$(tput setaf 6)"
    BOLD="$(tput bold)"
    RESET="$(tput sgr0)"
else
    GREEN=""
    YELLOW=""
    RED=""
    CYAN=""
    BOLD=""
    RESET=""
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FILE="$SCRIPT_DIR/src/encoder.c"
OUTDIR="$SCRIPT_DIR/bins"
OUTFILE="$OUTDIR/encoder"

function print_help {
    echo -e "${CYAN}==================== HELP ====================${RESET}"
    echo
    echo -e "${BOLD}Description:${RESET}"
    echo "This script compiles the encoder source code into a binary."
    echo "This encoder is used to encode various IP addresses, ports, brute credentials,"
    echo "and the actual communication and loader server domains."
    echo
    echo -e "${BOLD}Usage:${RESET} $0"
    echo
    echo "Compiles src/enc.c into bins/encoder using gcc -std=c99."
    echo
    echo -e "${BOLD}Options:${RESET}"
    echo -e "  ${YELLOW}-h, --help${RESET}    Show this help message and exit"
    echo
    echo -e "${BOLD}Example:${RESET}"
    echo "  $0"
    echo
    echo -e "${CYAN}==============================================${RESET}"
}

# =======================================
# Show help if requested
# =======================================
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

echo -e "${CYAN}==================== BUILD START ====================${RESET}"

# =======================================
# Check for source file
# =======================================
if [[ ! -f "$SRC_FILE" ]]; then
    echo -e "${RED}[!] Source file not found: $SRC_FILE${RESET}"
    echo -e "${RED}==================== BUILD ABORTED ====================${RESET}"
    exit 1
fi

# =======================================
# Prepare output directory
# =======================================
if [[ ! -d "$OUTDIR" ]]; then
    mkdir -p "$OUTDIR"
    echo -e "${GREEN}[+] Created output directory: $OUTDIR${RESET}"
fi

# =======================================
# Build
# =======================================
echo -e "${CYAN}[*] Compiling with: gcc -std=c99 \"$SRC_FILE\" -g -o \"$OUTFILE\"${RESET}"
if gcc -std=c99 "$SRC_FILE" -g -o "$OUTFILE"; then
    echo -e "${GREEN}[+] Build successful! Binary at $OUTFILE${RESET}"
    echo -e "${YELLOW}==================== BUILD COMPLETE ====================${RESET}"
else
    echo -e "${RED}[!] Build failed.${RESET}"
    echo -e "${RED}==================== BUILD ABORTED ====================${RESET}"
    exit 1
fi

exit 0