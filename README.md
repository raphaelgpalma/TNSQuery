# OraShell

OraShell is a Python-based command-line tool designed for interacting with Oracle databases via TNS (Transparent Network Substrate) without requiring the installation of `sqlplus`. It provides an interactive SQL shell.

## Features
- Interactive SQL shell for Oracle databases.
- Supports custom credentials and TNS connection details (host, port, service name).
- Built-in commands like `tables` to list user tables.
- No dependency on `sqlplus`, only requires Oracle Instant Client and `cx_Oracle`.
- Error handling for connection and query issues.
- Pentest-friendly, with a focus on simplicity and portability.

## Prerequisites
- Python 3.6+
- `cx_Oracle` (version 8.3.0 recommended, specified in `requirements.txt`)
- Oracle Instant Client (version 21.8 recommended)
- Linux environment with `wget`, `unzip`, and `pip3` installed

## Installation

#### Step 1: Clone the Repository
```bash
git clone https://github.com/raphaelgpalma/OraShell.git
cd OraShell
```

#### Step 2: Install Python Dependencies

Install the required Python library (cx_Oracle):

```bash
pip3 install -r requirements.txt
```

#### Step 3: Run orashell.py

```bash
python3 orashell.py
```
