# DNS Server Guide - Setting Up a Private DNS for Local Network

To set up a DNS server for your botnet infrastructure, we will use Pi-hole, a popular network-wide ad blocker and DNS server. This guide provides step-by-step instructions for setting up a **Pi-hole DNS server** in your local private network. Pi-hole will act as a DNS server, and we'll also configure custom domain mappings for your botnet infrastructure.

> **Note:** It is not mandatory to use Pi-hole, but it is highly recommended for its ease of use and powerful features. You can also use other DNS server software like dnsmasq or BIND, but for simplicity, we will focus on Pi-hole.

> **Note:** Configuring the Pi or Linux Machine as the DNS server is easier if using dnsmasq or BIND, but Pi-hole provides a user-friendly web interface and additional features like network monitoring, which might come in handy for analysis of the bot communications.

## Pre-requisites

-   A dedicated machine (PC, Raspberry Pi, or VM) for the DNS server with a static IP address (Same as DNS Server IP from [Here](../README.md#requirements))
-   Ubuntu/Debian-based Linux distribution (recommended)

## What You'll Accomplish

-   Install and configure Pi-hole as your network DNS server
-   Set up custom domain resolution for your botnet infrastructure

## Quick Links

-   [Install Pi-hole](#installing-pi-hole)
-   [Initial Configuration](#initial-configuration)
-   [Adding Custom Domains](#adding-custom-domains)
-   [Network Configuration](#configuring-network-devices)
-   [Testing and Verification](#testing-and-verification)
-   [Next Steps](#next-steps)

---

## Installing Pi-hole

> This section explains how to install Pi-hole using the official automated installer.

<details>
<summary>Expand for installation methods</summary>

### Method 1: One-Step Automated Install (Recommended)

The easiest way to install Pi-hole is using the automated installer:

```bash
curl -sSL https://install.pi-hole.net | bash
```

### Method 2: Manual Download and Install

If you prefer to review the installation script before running:

```bash
wget -O basic-install.sh https://install.pi-hole.net
sudo bash basic-install.sh
```

### Installation Process

During installation, you'll be prompted to configure:

1. **Interface Selection**: Choose your network interface (usually `eth0` or `wlan0`)
2. **Static IP Configuration**: Confirm or set a static IP address. This will be the **Private DNS server IP** that you saved in the previous [Requirements](../README.md#requirements).

3. **Upstream DNS Provider**: Choose from providers like Google (8.8.8.8), Cloudflare (1.1.1.1), or OpenDNS
4. **Blocklists**: Select default blocklists for ad/malware blocking
5. **Admin Interface**: Choose to install the web admin interface (recommended)
6. **Web Server**: Install lighttpd web server (recommended)
7. **Logging**: Enable query logging (recommended for monitoring)

**Important**: Note down the admin password displayed at the end of installation!

</details>

---

## Initial Configuration

> After installation, you need to perform some initial configuration steps.

<details>
<summary>Expand for initial configuration steps</summary>

### 1. Access the Web Interface

After installation, access the Pi-hole admin interface:

```
http://YOUR_PI_HOLE_IP/admin
```

Replace `YOUR_PI_HOLE_IP` with your Pi-hole server's IP address. (Same as the DNS Server IP from [Here](../README.md#requirements))

### 2. Login to Admin Panel

Use the password provided during installation. If you lost it, reset it with:

```bash
sudo pihole -a -p
```

Save this in the template you created in the [Requirements](../README.md#requirements) section of the README file. (Pi-hole Password)

### 3. Configure Basic Settings

In the admin interface:

1. Go to **Settings** → **DNS**
2. Configure upstream DNS servers (recommended: Cloudflare 1.1.1.1 and Google 8.8.8.8)
3. Enable DNSSEC if desired
4. Configure conditional forwarding for local network resolution

</details>

---

## Adding Custom Domains

### Method 1: Using Local DNS Records (Recommended)

For adding custom domains that point to specific IP addresses in your network:

1. Access the Pi-hole admin interface
2. Go to **System** → **Settings** → **Local DNS Records**
3. Add your custom domains in the list of Local DNS Records:

**Configuration for Botnet Infrastructure:**

| Domain                                                                              | IP Address                                                  |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `cnc.mirai.local` (CnC Server Domain from [Here](../README.md#requirements) )       | `<CNC_Server_IP>` from [Here](../README.md#requirements)    |
| `loader.mirai.local` (Loader Server Domain from [Here](../README.md#requirements) ) | `<LOADER_Server_IP>` from [Here](../README.md#requirements) |

## Configuring Network Devices

### Router Configuration

Configure your router to use Pi-hole as the primary DNS server:

1. Access your router's admin interface
2. Navigate to **DHCP Settings** or **Network Settings**
3. Set the **Primary DNS** to your Pi-hole IP address
4. Set **Secondary DNS** to a backup (like `8.8.8.8`) or leave blank
5. Save and restart the router

### Manual Device Configuration

For individual devices, set DNS manually:

> You have to set the DNS server IP address to the Pi-hole IP address in the network settings of each device (PC1, PC2, Raspberry Pi, etc.) that will be part of your network if you dont want to configure the router.

**Linux:**

1. **GUI Method** (Recommended for desktop environments):

    - Open **Network Settings**.
    - Select your connection (**Wired** or **Wireless**).
    - Go to **IPv4 Settings**.
    - Set the **DNS** field to your Pi-hole IP address.
    - Save and reconnect.

2. **Command Line Method**:

    - Edit the `/etc/resolv.conf` file:

        ```bash
        sudo nano /etc/resolv.conf
        ```

    - Add your Pi-hole IP address as a nameserver:

        ```
        nameserver <PI_HOLE_IP>
        ```

    - (Optional) Restart networking to apply changes:

        ```bash
        sudo systemctl restart networking
        ```

> **Note:** On some systems, `/etc/resolv.conf` may be overwritten by network managers. For persistent changes, configure your network manager or use `/etc/netplan/` or `/etc/network/interfaces` as appropriate for your distribution.

---

## Testing and Verification

### Testing and Verification

To verify that your custom domains are resolving correctly through your Pi-hole DNS server:

#### 1. Test from PC1

Open a terminal and run:

```bash
ping loader.mirai.local
```

#### 2. Test from PC2

Open a terminal and run:

```bash
ping cnc.mirai.local
```

If the DNS is configured properly, each command should resolve the domain to the correct internal IP address you set in Pi-hole.

> **Tip:** You can also use `nslookup` or `dig` for more detailed DNS query information.

## Next Steps

Now that you have set up your private DNS server, you can proceed with the next steps in your botnet infrastructure setup. Go back to [README](../README.md#setup-the-components) and follow guide for PC1.
