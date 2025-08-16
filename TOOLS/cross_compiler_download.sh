#!/bin/bash
set -e

# =======================================
# setup_cross_compilers.sh
# Download, extract, and organize cross-compilers for Mirai botnet builds
# Usage: sudo ./setup_cross_compilers.sh [all|compiler1 [compiler2 ...]]
# Example: sudo ./setup_cross_compilers.sh i586 mips
# =======================================

## Color setup
if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGENTA="$(tput setaf 5)"
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

# Script Directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function print_help {
    echo -e "${CYAN}==================== HELP ====================${RESET}"
    echo -e "${BOLD}Usage:${RESET} sudo $0 [all|compiler1 [compiler2 ...]]"
    echo
    echo "Downloads, extracts, and organizes cross-compiler toolchains."
    echo
    echo -e "${BOLD}Arguments:${RESET}"
    echo -e "  ${YELLOW}all${RESET}        Download and extract all compilers (default)"
    echo -e "  ${YELLOW}i486${RESET}       Only process i486"
    echo -e "  ${YELLOW}i586${RESET}       Only process i586"
    echo -e "  ${YELLOW}i686${RESET}       Only process i686"
    echo -e "  ${YELLOW}m68k${RESET}       Only process m68k"
    echo -e "  ${YELLOW}mips${RESET}       Only process mips"
    echo -e "  ${YELLOW}mipsel${RESET}     Only process mipsel"
    echo -e "  ${YELLOW}powerpc${RESET}    Only process powerpc"
    echo -e "  ${YELLOW}powerpc-440fp${RESET}    Only process powerpc-440fp"
    echo -e "  ${YELLOW}sh4${RESET}        Only process sh4"
    echo -e "  ${YELLOW}sparc${RESET}      Only process sparc"
    echo -e "  ${YELLOW}armv4l${RESET}     Only process armv4l"
    echo -e "  ${YELLOW}armv5l${RESET}     Only process armv5l"
    echo -e "  ${YELLOW}armv6l${RESET}     Only process armv6l"
    echo -e "  ${YELLOW}armv7l${RESET}     Only process armv7l"
    echo -e "  ${YELLOW}x86_64${RESET}     Only process x86_64"
    echo -e "  ${YELLOW}arc${RESET}        Only process arc"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  sudo $0 all"
    echo "  sudo $0 i586 mipsel arc"
    echo
    echo -e "${BOLD}If any part fails, you can retry just that one:${RESET}"
    echo "  sudo $0 arc"
    echo -e "${CYAN}==============================================${RESET}"
}

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

# Must be root!
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] This script must be run with sudo or as root.${RESET}"
    echo -e "${YELLOW}    Try: sudo $0${RESET}"
    exit 1
fi

OUTDIR="/etc/xcompile"
BASE_URL="https://mirailovers.io/HELL-ARCHIVE/COMPILERS"

# Maps: short name -> [archive extraction rename]
declare -A COMPILERS
COMPILERS["i486"]="cross-compiler-i486.tar.gz   'tar -xvf cross-compiler-i486.tar.gz'        'mv cross-compiler-i486 i486'"
COMPILERS["i586"]="cross-compiler-i586.tar.bz2  'tar -jxf cross-compiler-i586.tar.bz2'       'mv cross-compiler-i586 i586'"
COMPILERS["i686"]="cross-compiler-i686.tar.bz2  'tar -jxf cross-compiler-i686.tar.bz2'       'mv cross-compiler-i686 i686'"
COMPILERS["m68k"]="cross-compiler-m68k.tar.bz2  'tar -jxf cross-compiler-m68k.tar.bz2'       'mv cross-compiler-m68k m68k'"
COMPILERS["mips"]="cross-compiler-mips.tar.bz2  'tar -jxf cross-compiler-mips.tar.bz2'       'mv cross-compiler-mips mips'"
COMPILERS["mipsel"]="cross-compiler-mipsel.tar.bz2  'tar -jxf cross-compiler-mipsel.tar.bz2'  'mv cross-compiler-mipsel mipsel'"
COMPILERS["powerpc"]="cross-compiler-powerpc.tar.bz2  'tar -jxf cross-compiler-powerpc.tar.bz2'  'mv cross-compiler-powerpc powerpc'"
COMPILERS["powerpc-440fp"]="cross-compiler-powerpc-440fp.tar.bz2  'tar -jxf cross-compiler-powerpc-440fp.tar.bz2'  'mv cross-compiler-powerpc-440fp powerpc-440fp'"
COMPILERS["sh4"]="cross-compiler-sh4.tar.bz2    'tar -jxf cross-compiler-sh4.tar.bz2'        'mv cross-compiler-sh4 sh4'"
COMPILERS["sparc"]="cross-compiler-sparc.tar.bz2    'tar -jxf cross-compiler-sparc.tar.bz2'   'mv cross-compiler-sparc sparc'"
COMPILERS["armv4l"]="cross-compiler-armv4l.tar.bz2    'tar -jxf cross-compiler-armv4l.tar.bz2' 'mv cross-compiler-armv4l armv4l'"
COMPILERS["armv5l"]="cross-compiler-armv5l.tar.bz2    'tar -jxf cross-compiler-armv5l.tar.bz2' 'mv cross-compiler-armv5l armv5l'"
COMPILERS["armv6l"]="cross-compiler-armv6l.tar.bz2    'tar -jxf cross-compiler-armv6l.tar.bz2' 'mv cross-compiler-armv6l armv6l'"
COMPILERS["armv7l"]="cross-compiler-armv7l.tar.bz2    'tar -jxf cross-compiler-armv7l.tar.bz2' 'mv cross-compiler-armv7l armv7l'"
COMPILERS["x86_64"]="cross-compiler-x86_64.tar.bz2    'tar -jxf cross-compiler-x86_64.tar.bz2' 'mv cross-compiler-x86_64 x86_64'"
COMPILERS["arc"]="arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install.tar.gz   'tar -vxf arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install.tar.gz'   'mv arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install arc'"

# Build the list to process
if [[ $# -eq 0 || "$1" == "all" ]]; then
    TO_PROCESS=("${!COMPILERS[@]}")
else
    TO_PROCESS=()
    for arg in "$@"; do
        if [[ -n "${COMPILERS[$arg]}" ]]; then
            TO_PROCESS+=("$arg")
        else
            echo -e "${RED}[!] Unknown compiler: $arg${RESET}"
            echo -e "${CYAN}Run with --help for usage.${RESET}"
            exit 1
        fi
    done
fi

echo -e "${BLUE}==================== COMPILER SETUP ====================${RESET}"
echo -e "${CYAN}[*] Target directory:${RESET} ${YELLOW}$OUTDIR${RESET}"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

FAILED=()
for key in "${TO_PROCESS[@]}"; do
    IFS=" " read -r archive extract_cmd rename_cmd <<<"${COMPILERS[$key]}"
    echo -e "${BLUE}-------------------- ${BOLD}${key}${RESET}${BLUE} --------------------${RESET}"
    # Download
    if [[ -f "$archive" ]]; then
        echo -e "[${YELLOW}!${RESET}] ${archive} already exists, skipping download."
    else
        echo -e "[${CYAN}*${RESET}] Downloading ${GREEN}${archive}${RESET}..."
        if ! wget -q --show-progress "$BASE_URL/$archive"; then
            echo -e "${RED}[!] Failed to download ${archive}${RESET}"
            FAILED+=("$key")
            continue
        fi
    fi
    # Extract
    echo -e "[${CYAN}*${RESET}] Extracting ${YELLOW}${archive}${RESET}..."
    if ! eval "$extract_cmd"; then
        echo -e "${RED}[!] Extraction failed for ${archive}${RESET}"
        FAILED+=("$key")
        continue
    fi
    # Rename
    src=$(echo "$rename_cmd" | awk '{print $2}')
    dst=$(echo "$rename_cmd" | awk '{print $3}')
    if [[ -d "$src" ]]; then
        echo -e "[${CYAN}*${RESET}] Renaming ${YELLOW}${src}${RESET} → ${YELLOW}${dst}${RESET}"
        eval "$rename_cmd"
    else
        echo -e "[${YELLOW}!${RESET}] Directory ${src} not found, skipping rename."
        FAILED+=("$key")
        continue
    fi
done

echo -e "${BLUE}==================== CLEANING UP ====================${RESET}"
rm -rf *.tar.bz2 *.tar.gz *.tar *.tar.xz 2>/dev/null || true
echo -e "[${GREEN}+${RESET}] Archives removed."
echo

if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo -e "${RED}==================== FAILED ====================${RESET}"
    for key in "${FAILED[@]}"; do
        echo -e "${RED}[!] Failed to setup: ${BOLD}$key${RESET}"
    done
    echo
    echo -e "${YELLOW}To retry a failed compiler, run:${RESET}"
    echo -e "    sudo $0 ${FAILED[*]}"
    echo
else
    echo -e "${GREEN}[*] All selected cross-compilers are ready in ${GREEN}$OUTDIR${RESET}"
fi

echo -e "${YELLOW}==================== SETUP COMPLETE ====================${RESET}"
exit 0