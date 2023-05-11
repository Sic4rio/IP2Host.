# IP2Host.
a re-make of @adon90s dirty bash script that can turn IP address to domain names. Does a lookup using a bunch of APIs with added functionality - can do multiple IP addresses - taking input from a .txt file and also added progress bar. 
<p align="center">
  <img src="https://github.com/Sic4rio/IP2Host./blob/main/ip2host.gif?raw=true" width="600" height="400" />
</p>


    The script starts with a check to ensure that the script is called with an IP address as an argument. If the argument count is not 1, it displays a message indicating the correct usage and exits.

    The ip2hosts() function is defined, which performs the scanning operations for each IP address.

    Inside the ip2hosts() function:
        It first retrieves the total number of lines (IP addresses) in the input file using the wc -l command.
        Then, it starts a loop that reads each IP address from the input file.
        For each IP address:
            It clears the previous scan results by removing the /tmp/domains.txt file.
            It performs a series of curl commands and other operations to retrieve information related to the IP address and append the results to the /tmp/domains.txt file.
            The results are then appended to the output.txt file using >> redirection.
            It updates the progress bar by calculating the current progress based on the current line and the total lines, and prints the progress using printf.

    After the loop completes, the script prints a completion message and exits.

To use the script:

    Make sure you have a text file (e.g., input.txt) containing the IP addresses you want to scan, with each IP address on a separate line.

    Save the script in a file (e.g., scan_ips.sh).

    Open a terminal and navigate to the directory where the script and the input file are located.

    Make the script executable by running the following command: chmod +x scan_ips.sh.

    Run the script by executing: ./scan_ips.sh.

    The script will start scanning each IP address in the input.txt file and display a progress bar indicating the current progress.

    Once the scan is completed, the results will be saved to the output.txt file in the same directory.

Please note that the script assumes that the required commands (curl, grep, sed, nmap, etc.) are available in your system's environment. If any of these commands are missing, you may need to install the necessary packages or adjust the script accordingly.
