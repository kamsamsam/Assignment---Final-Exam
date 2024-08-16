#!/bin/bash

# System Monitoring Script
# This script displays basic system information: CPU usage, memory usage, disk usage, and running processes.

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root to get complete information"
  exit 1
fi

# Function to display CPU usage
cpu_usage() {
  echo "CPU Usage:"
  mpstat | awk '$12 ~ /[0-9.]+/ { print "CPU Usage: " 100 - $12 "%"}'
  echo ""
}

# Function to display memory usage
memory_usage() {
  echo "Memory Usage:"
  free -h | awk 'NR==2 {printf "Memory Usage: %.2f%%\n", $3/$2 * 100.0}'
  echo ""
}

# Function to display disk usage
disk_usage() {
  echo "Disk Usage:"
  df -h | awk '$NF=="/"{printf "Disk Usage: %s/%s (%s)\n", $3,$2,$5}'
  echo ""
}

# Function to display top running processes
top_processes() {
  echo "Top 5 Running Processes by CPU Usage:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
  echo ""
}

# Main Menu
while true; do
  echo "System Monitor"
  echo "1. CPU Usage"
  echo "2. Memory Usage"
  echo "3. Disk Usage"
  echo "4. Top Running Processes"
  echo "5. Exit"
  echo -n "Please select an option [1-5]: "
  
  read -r option

  case $option in
    1) cpu_usage ;;
    2) memory_usage ;;
    3) disk_usage ;;
    4) top_processes ;;
    5) echo "Exiting..."; break ;;
    *) echo "Invalid option, please select a number between 1 and 5." ;;
  esac
done
