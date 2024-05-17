#!/bin/bash

# Function to print with colors
print_color() {
  color=$1
  text=$2
  case $color in
    "red")
      echo -e "\e[31m${text}\e[0m"
      ;;
    "green")
      echo -e "\e[32m${text}\e[0m"
      ;;
    "yellow")
      echo -e "\e[33m${text}\e[0m"
      ;;
    "blue")
      echo -e "\e[34m${text}\e[0m"
      ;;
    *)
      echo "${text}"
      ;;
  esac
}

# Welcome Message
print_color "blue" "Welcome"
sleep 1

# Choose if you're up to the task
print_color "yellow" "Are you ready? (y/n)"
read ready

if [[ $ready == "y" || $ready == "Y" ]]; then 
  print_color "green" "You're awesome"
else 
  print_color "red" "Leave right now! - Bye!"
  exit 0
fi

sleep 1

# First beast battle
beast=$(( RANDOM % 2 ))

print_color "yellow" "Your first beast approaches. Prepare to battle. Pick a number between 0-1. (0/1)"
read tarnished

if [[ $tarnished =~ ^[01]$ ]]; then
  if [[ $beast == $tarnished ]]; then
    print_color "green" "Beast VANQUISHED! Congrats fellow tarnished."
  else 
    print_color "red" "You Died!"
    exit 1
  fi
else
  print_color "red" "Invalid input! You must pick 0 or 1."
  exit 1
fi

sleep 2

# Boss battle
print_color "yellow" "Boss battle! Get ready! It's Margit. Pick a number between 0-9. (0-9)"
read tarnished

beast=$(( RANDOM % 10 ))

if [[ $tarnished =~ ^[0-9]$ || $tarnished == "coffee" ]]; then
  if [[ $beast == $tarnished || $tarnished == "coffee" ]]; then
    print_color "green" "Beast VANQUISHED! Congrats fellow tarnished."
  else 
    print_color "red" "You Died!"
    exit 1
  fi
else
  print_color "red" "Invalid input! You must pick a number between 0-9!"
  exit 1
fi

sleep 2
print_color "green" "Congratulations on your victories!"
