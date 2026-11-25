# Scripting Task

## Overview
This folder contains a script that processes a list of email addresses. It validates the email format, checks if the associated ID is valid (and if the ID is odd or even), and outputs results based on the validation.

## Files

- `E-MAIL-SCRIPT.sh`: A Bash script that validates and processes email data.
- `emails.txt`: A sample text file containing name, email, and ID information.

## Script Functionality

The `E-MAIL-SCRIPT.sh` performs the following tasks:

1. **Validate email addresses**: It checks if the email addresses are valid and properly formatted using a simple regex pattern.
2. **Process each entry**: The script reads a CSV-like format from the `emails.txt` file, trims whitespace, and processes each user entry based on their ID.
3. **Odd/Even ID check**: For valid IDs (numerical), it checks if the ID is odd or even and outputs the result.
4. **Error handling**: The script provides warnings for invalid email addresses and entries without a valid ID.

## Run

From this directory:

```bash
chmod +x E-MAIL-SCRIPT.sh
./E-MAIL-SCRIPT.sh
```

The script expects `emails.txt` in the current working directory. It is a learning exercise: the regular expression performs basic format checking only and does not prove that an email address exists or can receive mail.

## Example Output

```bash
The 325 of john_j123@domain.com is odd number.
Warning: Invalid email address for user 'Susan'.
The 131 of jane_j121@domain.com is odd number.
Warning: Invalid parameters for user 'Karl'.
