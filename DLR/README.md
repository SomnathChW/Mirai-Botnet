# The DLR (Downloader)

This document provides an Overview as to what the DLR is and how to build it if needed **(Not Recommended)**.

## Quick Links

-   [What is the DLR](#what-is-the-dlr)
-   [Building the DLR (Not Recommended)](#building-the-dlr-not-recommended)
-   [Missing Compilers While Building](#missing-compilers-while-building)
-   [Additional Notes](#additional-notes)
-   [Disclaimer](#disclaimer)

---

## What is the DLR?

> This section explains what the DLR is and its purpose in the Mirai Botnet project.

<details>
<summary>Click to See Detailed Overview</summary>

> The DLR stands for **DOWNLOADER**. It is a component of the Mirai Botnet project that is used to download the bot binary from a server when the loader component cannot use `wget` or `tftp` to do so.

The DLR (Downloader) works alongside the **loader** component of the Mirai Botnet project. When the **loader** tries to infect a bot, it first connects to the bot using the credentials received, then it tries to use `wget` and `tftp` to download the bot binary from the apache server that is mentioned in the loader's code into the vulnerable device. If the bot does not have `wget` or `tftp` installed, it will try to use the DLR to download the bot binary.

The DLR is a simple downloader written in `c` that can be used in environments where `wget` or `tftp` is not available.

The DLR binaries are built for various architectures and stripped to be as small as possible so that they can be loaded into the vulnerable device without taking up too much space or resources.

</details>

## Building the DLR (Not Recommended)

> This section provides instructions on how to build the DLR from source code.

<details>
<summary>Click to See Build Instructions</summary>
The DLR is built using the build.sh script located in the `Mirai-Botnet/DLR` directory. The script is designed to build the DLR for various architectures and output the binaries to the `Mirai-Botnet/DLR/bin` directory.

However, building the DLR is not recommended as it is already built and available in the `Mirai-Botnet/DLR/bin` directory. The binaries are stripped to be as small as possible and are ready to be used.

If you still want to build the DLR, you can follow these steps:

### 1. Navigate to the DLR Directory

```bash
cd Mirai-Botnet/DLR
```

### 2. Run the Build Script

```bash
./build.sh
```

### 3. Confirm that the Binaries will be overwritten

```bash
echo "Bins directory already exists. Do you want to delete it and rebuild ? (y/N)"
```

Answer `y` to delete the existing `bins` directory and rebuild the DLR, or `N` to keep the existing binaries.

This is a safety measure to prevent accidental overwriting of existing binaries since building them needs extra compilers which are very hard to find.

### 4. Move the Binaries to the Loader Directory

If you want to use the DLR with the loader component, you can copy the binaries from the `Mirai-Botnet/DLR/bin` directory to the `Mirai-Botnet/LOADER/debug/bins` directory:

Only do this if the `Mirai-Botnet/LOADER/debug/bins` directory does not have the DLR binaries after building the loader.

```bash
cp Mirai-Botnet/DLR/bin/* Mirai-Botnet/LOADER/debug/bins/
```

</details>

## Missing Compilers While Building

> This section explains how to handle missing compilers while building the DLR.

<details>
<summary>Click to See Compiler Requirements</summary>

The DLR is built using various compilers for different architectures. If you encounter errors related to missing compilers while building the DLR, you can manually download and install them in your system and add them to your `PATH` environment variable.

Currently most of the compilers are incompatible and discontinued, so you will have to find them manually. The following compilers are required to build the DLR:
| Compiler | Output Binary | Target Architecture/Device |
|-----------------|----------------|----------------------------|
| `armv4l-gcc` | `dlr.arm` | armv4l devices |
| `armv6l-gcc` | `dlr.arm7` | armv6l devices |
| `i686-gcc` | `dlr.x86` | i686 devices |
| `m68k-gcc` | `dlr.m68k` | m68k devices |
| `mips-gcc` | `dlr.mips` | mips devices |
| `mipsel-gcc` | `dlr.mpsl` | mipsel devices |
| `powerpc-gcc` | `dlr.ppc` | powerpc devices |
| `sh4-gcc` | `dlr.sh4` | sh4 devices |
| `sparc-gcc` | `dlr.sparc` | sparc devices |

If you are missing any of these compilers, you can try to find them online or use a package manager to install them. Once you have installed the required compilers, you can run the build script to build the DLR.

**WE DONOT RECOMMEND DOING THIS AS IT IS VERY HARD TO FIND THE COMPILERS AND THEY ARE NOT MAINTAINED ANYMORE.**

</details>

---

## Additional Notes

> This section provides additional information about the DLR and its usage.

-   We recommend using the pre-built binaries available in the `Mirai-Botnet/DLR/bin` directory instead of building the DLR from source code.
-   The DLR is designed to be used alongside the loader component of the Mirai Botnet project.
-   If the `Mirai-Botnet/LOADER/debug/bins` directory does not have the DLR binaries after building the loader, you can copy the binaries from the `Mirai-Botnet/DLR/bin` directory to the `Mirai-Botnet/LOADER/debug/bins` directory.

---

## Disclaimer

> This guide is for educational purposes only. The Mirai Botnet project is intended for research and learning about cybersecurity, not for malicious use. Always follow ethical guidelines and legal regulations when working with such projects.
