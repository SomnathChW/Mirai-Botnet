#!/bin/bash
set -e

# =======================================
# build.sh
# Build CNC binary from Mirai-Botnet/CNC/src/ folder
# Usage: ./build.sh [debug|release]
# =======================================

## Check if terminal supports colors
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
    MAGENTA=""
    CYAN=""
    BOLD=""
    RESET=""
fi

# Detect the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function print_help {
    echo -e "${CYAN}==================== HELP ====================${RESET}"
    echo -e "${BOLD}Usage:${RESET} $0 [debug|release]"
    echo
    echo "Builds the CNC binary from the src/ folder."
    echo
    echo -e "${BOLD}Arguments:${RESET}"
    echo -e "  ${YELLOW}debug${RESET}      Build with debug flags (no optimization, includes symbols)"
    echo -e "  ${YELLOW}release${RESET}    Build optimized release binary"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  $0 debug"
    echo "  $0 release"
    echo -e "${CYAN}==============================================${RESET}"
}

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

# Default to debug if no argument is passed
BUILD_TYPE="${1:-debug}"

# Set output directory and build flags
if [[ "$BUILD_TYPE" == "release" ]]; then
    OUTDIR="$SCRIPT_DIR/release"
elif [[ "$BUILD_TYPE" == "debug" ]]; then
    OUTDIR="$SCRIPT_DIR/debug"
else
    echo -e "${RED}==================== ERROR ====================${RESET}"
    echo
    echo -e "${RED}Error:${RESET} Unknown build type '$BUILD_TYPE'"
    echo
    print_help
    exit 1
fi

# Delete old release files
rm -rf "$OUTDIR"

echo -e "${BLUE}==================== BUILD START ====================${RESET}"
echo -e "${CYAN}[*] Building CNC in${RESET} ${YELLOW}$BUILD_TYPE${RESET}${CYAN} mode...${RESET}"
mkdir -p "$OUTDIR"

# Move into src/ where go.mod is located
pushd "$SCRIPT_DIR/src" > /dev/null
echo

echo -e "${BLUE}==================== COMPILATION ====================${RESET}"
# Ensure dependencies are downloaded
go mod tidy

# Build the binary
echo -e "${CYAN}[*] Running go build...${RESET}"
if ! go build -o "$OUTDIR/cnc"; then
    echo "${RED}==================== BUILD FAILED ===================="
    echo "Error: CNC binary could not be built. Check the output above for details."
    echo -e "======================= ERROR ========================${RESET}"
    exit 1
fi
echo -e "${GREEN}[+]${RESET} CNC binary built at ${GREEN}$OUTDIR/cnc${RESET}"
echo

echo -e "${BLUE}==================== PROMPT FILE ====================${RESET}"
# Copy prompt.txt if it exists
if [[ -f "prompt.txt" ]]; then
    cp "prompt.txt" "$OUTDIR/prompt.txt"
    echo -e "[${GREEN}+${RESET}] prompt.txt found, copied to ${GREEN}$OUTDIR/prompt.txt${RESET}"
else
    echo -e "[${YELLOW}!${RESET}] prompt.txt not found, creating default file..."
    echo "I love Chicken Nuggets (Translated from Russian: \"я люблю куриные наггетсы\")" > "$OUTDIR/prompt.txt"
fi
echo

# Return to original directory
popd > /dev/null

echo -e "${YELLOW}==================== BUILD COMPLETE ====================${RESET}"
echo -e "${GREEN}[*] Build completed successfully.${RESET}"
echo -e "${GREEN}[*]${RESET} CNC binary and prompt file are ready in ${GREEN}$OUTDIR${RESET}"
echo -e "${YELLOW}========================================================${RESET}"

# Exit with success
exit 0