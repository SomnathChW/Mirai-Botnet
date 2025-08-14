# Mirai Deployment & Customization Guide (Work In Progress)

This repository provides a **work-in-progress guide and customized Mirai Botnet code** for **educational and research purposes**.

The original Mirai code fails in isolated lab/testbench environments, so this repository includes **modifications to make it compatible for safe study** and **enable scanning in private networks**.

> ⚠️ **Note:** Deployment instructions and code examples are under development. Use this repository strictly for **learning and research purposes**, not for any malicious activity.

---

## Requirements

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
CnC Server IP: <IP_ADDRESS>
Loader Server IP: <IP_ADDRESS>
Private DNS Server IP: <IP_ADDRESS>
```

---

## Setup The Components

> Please follow them in the order given below to ensure everything works correctly.

### 1. Private DNS (Raspberry Pi or Linux Device)

-   Follow the instructions exactly in the [DNS Guide](Documentation/DNS.md) to set up the Private DNS server.
-   This is optional in case you are deploying in a public network but **MANDATORY** for isolated environments to resolve domain names for the bots.

### 2. CnC Server (1st PC or VM)

-   Follow the instructions exactly in the [PC1 Guide](Documentation/PC1.md) to set up the CnC server.

### 3. Loader, DLR, Nginx Server (2nd PC or VM)

-   Follow the instructions exactly in the [PC2 Guide](Documentation/PC2.md) to set up the Loader, DLR, and Nginx server.
-   We will also use this PC to build our bot binaries and host them on the Nginx server.

---

### Deploying and Starting the Botnet

-   After setting up the CnC server, Loader, and Private DNS, you can deploy the botnet by following the instructions in the [Deployment Guide](Documentation/Deployment.md).

---

## Disclaimer

> This guide is for educational purposes only. The Mirai Botnet project is intended for research and learning about cybersecurity, not for malicious use. Always follow ethical guidelines and legal regulations when working with such projects.
