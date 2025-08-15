# The ScanListener

The scanListener is a component of botnet that listens for incoming bruted credentials from bots and handles scanning tasks. This guide provides instructions on how to build the ScanListener.

## Quick Links

-   [Building the ScanListener](#building-the-scanlistener)
-   [Moving the ScanListener](#moving-the-scanlistener)
-   [Additional Notes](#additional-notes)

---

## Building the ScanListener

> Note: All the commands below should be run in the SCANLISTENER directory of the project. (Mirai-Botnet/SCANLISTENER/)

<details>
<summary>Click to See Detailed Steps</summary>

### 1. Making the Build Script Executable

```bash
chmod +x build.sh
```

### 2. Running the Build Script

```bash
./build.sh <port>
```

-   It is not recommended to specify the port, but if you want to do so, make sure the port is between `12500` and `65535`. The default port is `48101` if no port is specified.

-   If you specify a port, then note that down in the template present in the [Requirements](../README.md#requirements) section of the README file.

### 3. Verify the build:

After running the build script, you might not receive a message indicating that the ScanListener has been built successfully but to verify, the binary should be located in the `bins` directory within the `Mirai-Botnet/SCANLISTENER` folder.

</details>

---

## Moving the ScanListener

> After building the ScanListener, you need to move it to the Loader PC (2nd PC or VM) where it will be used.

<details>
<summary>Click to See Instructions</summary>

-   Copy the built ScanListener binary from `Mirai-Botnet/SCANLISTENER/bins/` to the Loader PC (2nd PC or VM) where you have set up the Loader and Nginx server.

-   We just built the ScanListener in the CnC server PC (1st PC or VM) because we already have `go` installed there, but you can also build it in the Loader PC if you prefer by installing `go` there and following the same build steps.

</details>

---

## Additional Notes

> This section provides additional information about the ScanListener build process.

-   Usually, you should not need to specify the port when running the build script, but if you decide to do so, make sure the port is between `12500` and `65535`. The default port is `48101`.

-   Save the port number in the template you created in the [Requirements](../README.md#requirements) section of the README file if you specified a port.

## Next Steps

If you are following the guide in order then you can now move on to the PC2 guide mentioned in the [README](../README.md#setup-the-components) file to set up the Loader, DLR, and Nginx server on the Loader PC (2nd PC or VM).
