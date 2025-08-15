# PC1 Guide - Setting Up the CnC Server Machine

This guide provides step-by-step instructions for setting up the first PC or VM in the Mirai Botnet project, which will serve as the **CnC server** (Command and Control server) for the botnet.

## Pre-requisites

-   Make sure you have the `Mirai-Botnet/CNC` and the `Mirai-Botnet/SCANLISTENER` directory ready in this machine.

-   Make sure this PC has a proper **STATIC** IP address. This can be private or public, but it should not change. The **DNS server** IP address should also be set up if you are deploying in an isolated environment.

> **Note:** You should have this DNS IP stored in the [Requirements](../README.md#requirements) section of the main README file.

-   You can follow instructions from the internet to know how to put a static IP address and DNS resolver address for your Linux machine (PC1).

## Quick Links

-   [Install Go](#installing-go-manual-method-recommended)
-   [Install and Setup MySQL](#installing-and-setting-up-mysql)
-   [Next Steps](#next-steps)

---

## Installing Go (Manual Method) (Recommended)

> This section explains how to manually install Go from the official tarball.

> This is the recomended method because with this you can install the specific version we used that is compatible with the project. **( Version 1.25.0 )**

<details>
<summary>Click to See Detailed Installation Steps</summary>

### 1. Remove Any Existing Go Installation

If you previously installed Go in `/usr/local/go`, remove it to avoid conflicts:

```bash
sudo rm -rf /usr/local/go
```

### 2. Download and Extract Go

Download the Go archive from [https://go.dev/dl/](https://go.dev/dl/).
You need to check and manually set the version you want to install in the below link example.

Example for Go **1.25.0** on Linux (64-bit):

```bash
wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz
```

Extract it into `/usr/local`:

```bash
sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
```

> **Note:** Do **not** extract the new Go tarball into an existing `/usr/local/go` directory. This can cause a broken Go installation.

### 3. Update Your PATH

Add Go’s binary directory to your `PATH` so you can run `go` from any terminal.

For **current user only**:

```bash
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile
```

### 4. Verify Installation

Check that Go is installed and available:

```bash
go version
```

Example output:

```
go version go1.25.0 linux/amd64
```

> If you see the version output, Go is successfully installed! and you can proceed with the CnC Build.

### References

-   [Go Downloads](https://go.dev/dl/)
-   [Official Install Docs](https://go.dev/doc/install)

</details>

---

## Installing and Setting up MySQL

> This section explains how to install MySQL, which is required for the CnC server to store bot and user data.

<details>
<summary>Click to See MySQL Installation and Setup Steps</summary>

### 1. Install MySQL Server

```bash
sudo apt-get update
sudo apt-get install mysql-server
```

### 2. Make a MySQL User

```bash
sudo mysql -u root -p
```

Inside the MySQL shell, run:

```sql
CREATE USER 'mirai'@'localhost' IDENTIFIED BY 'password';
```

> **Note:** This is the `CnC Server MySQL Database Credentials` shown in the [Requirements](../README.md#requirements) section of the README file.

### 3. Grant Permissions to the User

```sql
GRANT ALL PRIVILEGES ON mirai.* TO 'mirai'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Create the Database

Inside the MySQL shell, run:

```sql
CREATE DATABASE mirai;

CREATE TABLE `history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `time_sent` int(10) unsigned NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  `command` text NOT NULL,
  `max_bots` int(11) DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
);

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `duration_limit` int(10) unsigned DEFAULT NULL,
  `cooldown` int(10) unsigned NOT NULL,
  `wrc` int(10) unsigned DEFAULT NULL,
  `last_paid` int(10) unsigned NOT NULL,
  `max_bots` int(11) DEFAULT '-1',
  `admin` int(10) unsigned DEFAULT '0',
  `intvl` int(10) unsigned DEFAULT '30',
  `api_key` text,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
);

CREATE TABLE `whitelist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` varchar(16) DEFAULT NULL,
  `netmask` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prefix` (`prefix`)
);
```

### 5. Create a user in the user table

Inside the MySQL shell, run:

```sql
INSERT INTO users (username, password, duration_limit, cooldown, wrc, last_paid, max_bots, admin, intvl, api_key)
VALUES ('mirai', 'password', NULL, 0, NULL, UNIX_TIMESTAMP(), -1, 1, 30, 'your_api_key_here');
```

This is the default user that will be used to connect to the CnC server. You can change the username and password as needed.

When connecting to the CnC, when asked for the username and password, use the ones you set in the users table.

Default values are:

-   Username: `mirai`
-   Password: `password`

> **Note:** This is the `CnC Login Credientials` shown in the [Requirements](../README.md#requirements) section of the README file.

### 6. Exit MySQL Shell

```sql
EXIT;
```

### 7. Verify MySQL Installation

You can verify that MySQL is running by checking its status:

```bash
sudo systemctl status mysql
```

If MySQL is running, you should see an output indicating that the service is active (running).

</details>

---

## Next Steps

> After setting up Go and MySQL, you can proceed to build the **CnC server** and the **ScanListener**.

<details>
<summary>Click to See Instructions</summary>

-   You can follow the instructions in the [CnC Build Guide](../CNC/README.md) to build the CnC server.
-   Since We already have `go` installed in this PC, we will also use this PC to build the scanListener even though we will use it in the 2nd PC (The Loader PC). Follow the instructions in the [ScanListener Build Guide](../SCANLISTENER/README.md) to build the scanListener.

</details>
