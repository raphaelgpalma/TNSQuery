#!/bin/bash

# Setup script for Oracle Instant Client
# Automates download, extraction, and configuration for cx_Oracle

# Exit on any error
set -e

# Define variables
INSTANT_CLIENT_VERSION="21.8.0.0.0"
INSTANT_CLIENT_ZIP="instantclient-basic-linux.x64-${INSTANT_CLIENT_VERSION}dbru.zip"
INSTANT_CLIENT_URL="https://download.oracle.com/otn_software/linux/instantclient/218000/${INSTANT_CLIENT_ZIP}"
INSTALL_DIR="/opt/oracle"
INSTANT_CLIENT_DIR="${INSTALL_DIR}/instantclient_21_8"

# Check if running as root (optional, depending on permissions)
if [ "$EUID" -eq 0 ]; then
    echo "[✔] Running as root"
else
    echo "[!] Not running as root, may need sudo for some operations"
fi

# Create installation directory
echo "[+] Creating directory: ${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

# Check if Instant Client is already installed
if [ -d "${INSTANT_CLIENT_DIR}" ]; then
    echo "[✔] Oracle Instant Client already installed at ${INSTANT_CLIENT_DIR}"
else
    # Download Instant Client
    echo "[+] Downloading Oracle Instant Client ${INSTANT_CLIENT_VERSION}"
    if ! command -v wget &> /dev/null; then
        echo "[✖] wget not found. Please install wget."
        exit 1
    fi
    wget -O "${INSTALL_DIR}/${INSTANT_CLIENT_ZIP}" "${INSTANT_CLIENT_URL}" || {
        echo "[✖] Failed to download Instant Client"
        exit 1
    }

    # Extract Instant Client
    echo "[+] Extracting Instant Client"
    unzip "${INSTALL_DIR}/${INSTANT_CLIENT_ZIP}" -d "${INSTALL_DIR}" || {
        echo "[✖] Failed to extract Instant Client"
        exit 1
    }

    # Clean up zip file
    rm "${INSTALL_DIR}/${INSTANT_CLIENT_ZIP}"
fi

# Set LD_LIBRARY_PATH
echo "[+] Configuring LD_LIBRARY_PATH"
if [ -z "${LD_LIBRARY_PATH}" ]; then
    echo "export LD_LIBRARY_PATH=${INSTANT_CLIENT_DIR}:\$LD_LIBRARY_PATH" >> ~/.bashrc
else
    if ! echo "${LD_LIBRARY_PATH}" | grep -q "${INSTANT_CLIENT_DIR}"; then
        echo "export LD_LIBRARY_PATH=${INSTANT_CLIENT_DIR}:\$LD_LIBRARY_PATH" >> ~/.bashrc
    fi
fi
export LD_LIBRARY_PATH="${INSTANT_CLIENT_DIR}:${LD_LIBRARY_PATH}"

# Verify Instant Client
if [ -f "${INSTANT_CLIENT_DIR}/libclntsh.so" ]; then
    echo "[✔] Oracle Instant Client configured successfully"
else
    echo "[✖] Oracle Instant Client library not found"
    exit 1
fi

# Check and install cx_Oracle
echo "[+] Checking for cx_Oracle"
if ! pip3 show cx_Oracle &> /dev/null; then
    echo "[+] Installing cx_Oracle"
    pip3 install cx_Oracle || {
        echo "[✖] Failed to install cx_Oracle"
        exit 1
    }
else
    echo "[✔] cx_Oracle already installed"
fi

# Final instructions
echo "[✔] Setup complete!"
echo "Run 'source ~/.bashrc' to apply LD_LIBRARY_PATH or restart your terminal."
echo "You can now use OraShell: python3 orashell.py"
