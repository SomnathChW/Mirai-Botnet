# Mirai Deployment & Customization Guide (Work In Progress)

This repository provides a **work-in-progress guide and customized Mirai Botnet code** for **educational and research purposes**.

The original Mirai code fails in isolated lab/testbench environments, so this repository includes **modifications to make it compatible for safe study** and **enable scanning in private networks**.

> ⚠️ **Note:** Deployment instructions and code examples are under development. Use this repository strictly for **learning and research purposes**, not for any malicious activity.

## Quick Links

-   [Requirements](#requirements)
-   [Setup The Components](#setup-the-components)
    -   [1. Private DNS (Raspberry Pi or Linux Device)](#1-private-dns-raspberry-pi-or-linux-device)
    -   [2. CnC Server (1st PC or VM)](#2-cnc-server-1st-pc-or-vm)
    -   [3. Loader, DLR, Nginx Server (2nd PC or VM)](#3-loader-dlr-nginx-server-2nd-pc-or-vm)
-   [Deploying and Starting the Botnet](#deploying-and-starting-the-botnet)
-   [Disclaimer](#disclaimer)

---

## Requirements

<details>
<summary>Click to See Requirements (Mandatory Read)</summary>

-   1 PC or VM with **Linux(Ubuntu 24.04.2 LTS or later recommended)** This will be the **CnC server** (Command and Control server) for the botnet.

    > This Will be used as the CnC server to control the bots.

    -   Ensure this has a proper **STATIC** IP address. This can be private or public, but it should not change.

-   1 PC or VM with **Linux(Ubuntu 24.04.2 LTS or later recommended)** This will be the **Loader** as well as the `http` and `tftp` server to host the bots and the dlr.

    > This will be used as the Loader and the `http` and `tftp` server to host the bots and the dlr.

    -   Ensure this has a proper **STATIC** IP address. This can be private or public, but it should not change.

-   1 Raspberry Pi or any other **Linux-based device** to run a **Private DNS** in case you want to set this up in an isolated private network.
    > This will be used as the Private DNS to resolve domain names for the bots since isolated environment may not have access to public DNS servers.
    -   Ensure this has a proper **STATIC** IP address. This can be private or public, but it should not change.

Note down all the IP addresses of the above devices as you will need them in the future steps.

-   Use this template to note down the IP addresses of the devices:

```
1st PC or VM:
    CnC Server IP: <IP_ADDRESS of 1st PC or VM>

2nd PC or VM:
    Loader Server IP: <IP_ADDRESS of 2nd PC or VM>

Raspberry Pi or Linux Device:
    Private DNS Server IP: <IP_ADDRESS of Raspberry Pi or Linux Device>

# The values below will make sense once you move forward with the entire setup.

1st PC or VM:
    CNC Server Domain: cnc.mirai.local
    CNC Server Port: 23

    CnC Server MySQL Database Credentials:
        Username: mirai
        Password: password

    CnC Login Credentials:
        Username: mirai
        Password: password

2nd PC or VM:
    Loader Server Domain: loader.mirai.local
    ScanListener Port: 48101 (This might change if you change it while building the ScanListener)

Raspberry Pi or Linux Device:
    Pi-hole Password: <PASSWORD you set during Pihole installation>

```

</details>

---

## Setup The Components

> Please follow them in the order given below to ensure everything works correctly.

<details>   
<summary>Click to See Setup Steps (Mandatory Read)</summary>

### 1. Private DNS (Raspberry Pi or Linux Device)

-   Follow the instructions in the [DNS Guide](Documentation/DNS.md) to set up the Private DNS server.
-   This is optional in case you are deploying in a public network but **MANDATORY** for isolated environments to resolve domain names for the bots.

### 2. CnC Server (1st PC or VM)

-   Follow the instructions exactly in the [PC1 Guide](Documentation/PC1.md) to set up the CnC server.

### 3. Loader, DLR, Nginx Server (2nd PC or VM)

-   Follow the instructions exactly in the [PC2 Guide](Documentation/PC2.md) to set up the Loader, DLR, and Nginx server.
-   We will also use this PC to build our bot binaries and host them on the Nginx server.

</details>

---

### Deploying and Starting the Botnet

-   After setting up the CnC server, Loader, and Private DNS, you can deploy the botnet by following the instructions in the [Deployment Guide](Documentation/Deployment.md).

---

## Disclaimer

> This guide is for educational purposes only. The Mirai Botnet project is intended for research and learning about cybersecurity, not for malicious use. Always follow ethical guidelines and legal regulations when working with such projects.
