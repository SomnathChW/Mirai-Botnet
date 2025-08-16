#!/bin/bash
set -e

# =======================================
# cross_compiler_download.sh
# Download, extract, and organize cross-compilers for Mirai botnet builds
# Usage: sudo ./cross_compiler_download.sh [all|compiler1 [compiler2 ...]]
# Example: sudo ./cross_compiler_download.sh i586 mips
# =======================================

# Color setup
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function print_help {
    echo -e "${CYAN}==================== HELP ====================${RESET}"
    echo -e "${BOLD}Usage:${RESET} sudo $0 [all|compiler1 [compiler2 ...]]"
    echo
    echo "Downloads, extracts, and organizes cross-compiler toolchains."
    echo
    echo -e "${BOLD}Arguments:${RESET}"
    echo -e "  ${YELLOW}all${RESET}              Download and extract all compilers (default)"
    echo -e "  ${YELLOW}i486${RESET}             Only process i486"
    echo -e "  ${YELLOW}i586${RESET}             Only process i586"
    echo -e "  ${YELLOW}i686${RESET}             Only process i686"
    echo -e "  ${YELLOW}m68k${RESET}             Only process m68k"
    echo -e "  ${YELLOW}mips${RESET}             Only process mips"
    echo -e "  ${YELLOW}mipsel${RESET}           Only process mipsel"
    echo -e "  ${YELLOW}powerpc${RESET}          Only process powerpc"
    echo -e "  ${YELLOW}powerpc-440fp${RESET}    Only process powerpc-440fp"
    echo -e "  ${YELLOW}sh4${RESET}              Only process sh4"
    echo -e "  ${YELLOW}sparc${RESET}            Only process sparc"
    echo -e "  ${YELLOW}armv4l${RESET}           Only process armv4l"
    echo -e "  ${YELLOW}armv5l${RESET}           Only process armv5l"
    echo -e "  ${YELLOW}armv6l${RESET}           Only process armv6l"
    echo -e "  ${YELLOW}armv7l${RESET}           Only process armv7l"
    echo -e "  ${YELLOW}x86_64${RESET}           Only process x86_64"
    echo -e "  ${YELLOW}arc${RESET}              Only process arc"
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

# Ensure bzip2 is installed
if ! command -v bzip2 >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] bzip2 not found. Installing...${RESET}"
    if apt-get update -qq >/dev/null 2>&1 && apt-get install -y -qq bzip2 >/dev/null 2>&1; then
        echo -e "${GREEN}[+] bzip2 installed successfully.${RESET}"
    else
        echo -e "${RED}[!] Failed to install bzip2. Please install it manually and rerun the script.${RESET}"
        exit 1
    fi
fi

OUTDIR="/etc/xcompile"
BASE_URL="https://mirailovers.io/HELL-ARCHIVE/COMPILERS"

# If xcompile already exists, delete it and show a message
if [ -d "$OUTDIR" ]; then
    echo -e "${YELLOW}[!] Directory $OUTDIR already exists. Deleting it before proceeding...${RESET}"
    rm -rf "$OUTDIR"
fi

declare -A ARCHIVES
ARCHIVES["i486"]="cross-compiler-i486.tar.gz"
ARCHIVES["i586"]="cross-compiler-i586.tar.bz2"
ARCHIVES["i686"]="cross-compiler-i686.tar.bz2"
ARCHIVES["m68k"]="cross-compiler-m68k.tar.bz2"
ARCHIVES["mips"]="cross-compiler-mips.tar.bz2"
ARCHIVES["mipsel"]="cross-compiler-mipsel.tar.bz2"
ARCHIVES["powerpc"]="cross-compiler-powerpc.tar.bz2"
ARCHIVES["powerpc-440fp"]="cross-compiler-powerpc-440fp.tar.bz2"
ARCHIVES["sh4"]="cross-compiler-sh4.tar.bz2"
ARCHIVES["sparc"]="cross-compiler-sparc.tar.bz2"
ARCHIVES["armv4l"]="cross-compiler-armv4l.tar.bz2"
ARCHIVES["armv5l"]="cross-compiler-armv5l.tar.bz2"
ARCHIVES["armv6l"]="cross-compiler-armv6l.tar.bz2"
ARCHIVES["armv7l"]="cross-compiler-armv7l.tar.bz2"
ARCHIVES["x86_64"]="cross-compiler-x86_64.tar.bz2"
ARCHIVES["arc"]="arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install.tar.gz"

declare -A EXTRACT
EXTRACT["i486"]="tar -xf cross-compiler-i486.tar.gz"
EXTRACT["i586"]="tar -jxf cross-compiler-i586.tar.bz2"
EXTRACT["i686"]="tar -jxf cross-compiler-i686.tar.bz2"
EXTRACT["m68k"]="tar -jxf cross-compiler-m68k.tar.bz2"
EXTRACT["mips"]="tar -jxf cross-compiler-mips.tar.bz2"
EXTRACT["mipsel"]="tar -jxf cross-compiler-mipsel.tar.bz2"
EXTRACT["powerpc"]="tar -jxf cross-compiler-powerpc.tar.bz2"
EXTRACT["powerpc-440fp"]="tar -jxf cross-compiler-powerpc-440fp.tar.bz2"
EXTRACT["sh4"]="tar -jxf cross-compiler-sh4.tar.bz2"
EXTRACT["sparc"]="tar -jxf cross-compiler-sparc.tar.bz2"
EXTRACT["armv4l"]="tar -jxf cross-compiler-armv4l.tar.bz2"
EXTRACT["armv5l"]="tar -jxf cross-compiler-armv5l.tar.bz2"
EXTRACT["armv6l"]="tar -jxf cross-compiler-armv6l.tar.bz2"
EXTRACT["armv7l"]="tar -jxf cross-compiler-armv7l.tar.bz2"
EXTRACT["x86_64"]="tar -jxf cross-compiler-x86_64.tar.bz2"
EXTRACT["arc"]="tar -xf arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install.tar.gz"

declare -A RENAME
RENAME["i486"]="mv cross-compiler-i486 i486"
RENAME["i586"]="mv cross-compiler-i586 i586"
RENAME["i686"]="mv cross-compiler-i686 i686"
RENAME["m68k"]="mv cross-compiler-m68k m68k"
RENAME["mips"]="mv cross-compiler-mips mips"
RENAME["mipsel"]="mv cross-compiler-mipsel mipsel"
RENAME["powerpc"]="mv cross-compiler-powerpc powerpc"
RENAME["powerpc-440fp"]="mv cross-compiler-powerpc-440fp powerpc-440fp"
RENAME["sh4"]="mv cross-compiler-sh4 sh4"
RENAME["sparc"]="mv cross-compiler-sparc sparc"
RENAME["armv4l"]="mv cross-compiler-armv4l armv4l"
RENAME["armv5l"]="mv cross-compiler-armv5l armv5l"
RENAME["armv6l"]="mv cross-compiler-armv6l armv6l"
RENAME["armv7l"]="mv cross-compiler-armv7l armv7l"
RENAME["x86_64"]="mv cross-compiler-x86_64 x86_64"
RENAME["arc"]="mv arc_gnu_2017.09_prebuilt_uclibc_le_arc700_linux_install arc"

# Build the list to process
if [[ $# -eq 0 || "$1" == "all" ]]; then
    TO_PROCESS=("${!ARCHIVES[@]}")
else
    TO_PROCESS=()
    for arg in "$@"; do
        if [[ -n "${ARCHIVES[$arg]}" ]]; then
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

SUCCEEDED=()
FAILED=()

for key in "${TO_PROCESS[@]}"; do
    archive="${ARCHIVES[$key]}"
    extract_cmd="${EXTRACT[$key]}"
    rename_cmd="${RENAME[$key]}"
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
        SUCCEEDED+=("$key")
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

# -------- PERMANENT PATH SETUP (user only, successful compilers) --------

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
if [ -z "$USER_HOME" ]; then
    # fallback (if not run under sudo)
    USER_HOME="$HOME"
fi
USER_PROFILE="$USER_HOME/.bashrc"

# Remove previous xcompile path entries
sed -i '/# xcompile cross-compiler paths BEGIN/,/# xcompile cross-compiler paths END/d' "$USER_PROFILE" 2>/dev/null || true

bin_paths=()
for compiler in "${SUCCEEDED[@]}"; do
    bin_dir="$OUTDIR/$compiler/bin"
    if [[ -d "$bin_dir" ]]; then
        bin_paths+=("$bin_dir")
    fi
done

if [[ ${#bin_paths[@]} -gt 0 ]]; then
    {
        echo "# xcompile cross-compiler paths BEGIN"
        # JOIN WITH COLON INSTEAD OF SPACE:
        echo "export PATH=\"$(IFS=:; echo "${bin_paths[*]}"):\$PATH\""
        echo "# xcompile cross-compiler paths END"
    } >> "$USER_PROFILE"
    echo -e "${GREEN}[+] PATH for these compilers has been permanently added to ${RESET}${BOLD}${YELLOW}$USER_PROFILE${RESET}"
    echo -e "${CYAN}[*] Please run ${BOLD}${YELLOW}\`source $USER_PROFILE\`${RESET}${CYAN} or open a new shell to use the cross-compilers in your PATH.${RESET}"
    echo
fi

# -------- TEST COMPILERS --------

if [[ ${#SUCCEEDED[@]} -gt 0 ]]; then
    echo -e "${CYAN}[*] Checking installed cross-compilers...${RESET}"
    # For the session and subsequent checks, prepend each bin to PATH
    for bin_dir in "${bin_paths[@]}"; do
        PATH="$bin_dir:$PATH"
    done

    echo -e "${CYAN}==================== COMPILER TESTS ====================${RESET}"
    for compiler in "${SUCCEEDED[@]}"; do
        comp_bin="$OUTDIR/$compiler/bin"
        if [[ -d "$comp_bin" ]]; then
            cross_gcc="$(ls "$comp_bin"/*gcc 2>/dev/null | head -n 1)"
            if [[ -x "$cross_gcc" ]]; then
                if "$cross_gcc" --version >/dev/null 2>&1; then
                    echo -e "[${GREEN}+${RESET}] ${BOLD}${compiler}${RESET}: gcc found and works (${YELLOW}$(basename "$cross_gcc")${RESET})"
                else
                    echo -e "[${RED}- ${RESET}] ${BOLD}${compiler}${RESET}: gcc found but failed to run"
                fi
            else
                echo -e "[${RED}- ${RESET}] ${BOLD}${compiler}${RESET}: no gcc found in bin/"
            fi
        else
            echo -e "[${RED}- ${RESET}] ${BOLD}${compiler}${RESET}: bin directory not found"
        fi
    done
    echo
fi

# -------- SUMMARY --------

if [[ ${#SUCCEEDED[@]} -gt 0 && ${#FAILED[@]} -gt 0 ]]; then
    echo -e "${YELLOW}==================== PARTIAL SUCCESS ====================${RESET}"
    for key in "${TO_PROCESS[@]}"; do
        if [[ " ${SUCCEEDED[*]} " == *" $key "* ]]; then
            echo -e "${GREEN}[+] Succeeded:${RESET} ${BOLD}$key${RESET}"
        elif [[ " ${FAILED[*]} " == *" $key "* ]]; then
            echo -e "${RED}[-] Failed:   ${RESET} ${BOLD}$key${RESET}"
        fi
    done
    echo
    echo -e "${YELLOW}To retry failed compilers, run:${RESET}"
    echo -e "    sudo $0 ${FAILED[*]}"
    echo
elif [[ ${#FAILED[@]} -gt 0 ]]; then
    echo -e "${RED}==================== FAILED ====================${RESET}"
    for key in "${FAILED[@]}"; do
        echo -e "${RED}[!] Failed:${RESET} ${BOLD}$key${RESET}"
    done
    echo
    echo -e "${YELLOW}To retry failed compilers, run:${RESET}"
    echo -e "    sudo $0 ${FAILED[*]}"
    echo
elif [[ ${#SUCCEEDED[@]} -gt 0 ]]; then
    echo -e "${GREEN}==================== SUCCESS ====================${RESET}"
    for key in "${SUCCEEDED[@]}"; do
        echo -e "${GREEN}[+] Installed:${RESET} ${BOLD}$key${RESET}"
    done
    echo
    echo -e "${GREEN}[*] All selected cross-compilers are ready in ${GREEN}$OUTDIR${RESET}"
fi

echo -e "${YELLOW}==================== SETUP COMPLETE ====================${RESET}"
exit 0