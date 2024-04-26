# ESXi Login Page Scanner

This Bash script is designed to scan subnets listed in a file for ESXi login pages by checking each IP address for an open 443 port and attempting to identify pages that include the "esxUiApp" marker. This script operates asynchronously to efficiently handle multiple IPs at once.

## Prerequisites

- `bash`
- `curl`
- Access to network utilities like `/dev/tcp/`
  
## Installation

To use this script, clone this repository to your machine:

```bash
git clone https://github.com/Domainhizmetleri/esxi-login-page-finder-in-subnets.git
cd esxi-login-page-finder-in-subnets
```

## Configuration
Before running the script, ensure you have a subnets.txt file in the root directory of this repository. This file should contain all subnets you want to scan, one per line, in CIDR format. Example of subnets.txt:

```bash
1.2.3.4/24
4.5.6.7/19
etc.

```

## Usage
Execute the script from the command line:

```bash
bash esxi_scanner.sh
```
The script scans each subnet asynchronously, checks for open 443 ports, and attempts to find ESXi login pages. IPs with ESXi login pages are saved to esxi_login_pages.txt.

## Output
The script outputs the results to esxi_login_pages.txt, which will contain the IPs of servers where an ESXi login page was detected. Additionally, it prints the total count of found IPs to the terminal after the completion of the scan.

## Contributing
Contributions to improve the script are welcome. Feel free to fork the repository, make changes, and submit a pull request. If you encounter any issues or have suggestions, please open an issue in this repository.

## Thanks
Special thanks to ChatGPT for assisting in the scripting and documentation process of this project.
