# The CnC (Command and Control) Server

The CnC (Command and Control) server is a crucial component of the Mirai Botnet project, responsible for managing and controlling the botnet.

All the bots in the network connect to the CnC server to receive commands like `attack`.

This document provides a step-by-step guide to building the CnC server, including instructions for installing Go, building the CnC, and handling common errors.

## Quick Links

-   [Install Go](#installing-go-manual-method-recommended)
-   [Install MySQL](#installing-mysql)
-   [Building the CnC](#building-the-cnc)
-   [Additional Notes](#additional-notes)
-   [Disclaimer](#disclaimer)

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

## Installing MySQL

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

---

## Disclaimer

> This guide is for educational purposes only. The Mirai Botnet project is intended for research and learning about cybersecurity, not for malicious use. Always follow ethical guidelines and legal regulations when working with such projects.
