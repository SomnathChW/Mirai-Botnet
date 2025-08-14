# The CnC (Command and Control) Server

The CnC (Command and Control) server is a crucial component of the Mirai Botnet project, responsible for managing and controlling the botnet.

All the bots in the network connect to the CnC server to receive commands like `attack`.

This document provides a step-by-step guide to building the CnC server, including instructions for installing Go, building the CnC, and handling common errors.

## Quick Links

-   [Building the CnC](#building-the-cnc)
-   [Additional Notes](#additional-notes)

---

## Building the CnC

> This section provides guidance on how to initialize the go project after installing Go.

> Note: All the commands below should be run in the CNC directory of the project. (Mirai-Botnet/CNC/)

<details>
<summary>Click to See Detailed Steps</summary>

### 1. Making the Build Script Executable

```bash
chmod +x build.sh
```

### 2. Running the Build Script

```bash
./build.sh [debug|release]
```

-   Use `debug` for a debug build (default if no argument is passed).
-   Use `release` for a release build.

> Currently, the script builds the same binary for both debug and release modes. this is the usual behaviour in the original Mirai Botnet.

### 3. Expected Output

The binary and `prompt.txt` will appear in the corresponding output folder (`debug/` or `release/`).

---

### Handling Dependency Errors While Building

If you encounter errors related to missing dependencies while building, you can manually install them using the following commands:

```bash
go get github.com/mattn/go-shellwords
go get github.com/go-sql-driver/mysql
```

> **Note:**
> If dependencies like `github.com/mattn/go-shellwords` or `github.com/go-sql-driver/mysql` are missing or the original repos are deleted, you can use the copies available in this repository.
> (Links to copies are a work in progress.)

</details>

---

## Additional Notes

> Usually you don't need to change anything in the build script, but if you do, here are some notes:

-   Ensure you have the necessary permissions to run the build script.
-   Ensure that this entire project (`Mirai-Botnet`) is in a directory where you have write access, as it will create output directories and files.
-   We built the CnC using `Go version 1.25.0`, which is compatible with the project, In future if newer versions fail you can try using this version.
-   If you encounter any issues, check the script for any hardcoded paths or environment variables that may need adjustment based on your system configuration.
-   **For example:** If you have Go installed in a non-standard location, you may need to update the `GOPATH` or `GOROOT` variables.
