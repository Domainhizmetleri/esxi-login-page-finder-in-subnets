# ESXi Login Page Scanner

This repository contains a Bash script designed to scan specified subnets for ESXi login pages. It checks each IP in the subnets for an open 443 port and attempts to identify web pages that include the "esxUiApp" marker, indicating an ESXi login page.

## Prerequisites

Before running this script, make sure you have `curl` installed on your system as it is used for making HTTP requests to the IPs.

## Installation

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/yourusername/esxi-login-scanner.git
cd esxi-login-scanner
