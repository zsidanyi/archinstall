#!/bin/sh

# Ask for confiramtion and return OK when true
ask() {

  if [[ true = $noconfirm ]]; then
    return
  fi

  read -p "$1 (Y/n): " resp
  if [[ -z "$resp" ]]; then
    response_lc="y" # empty is Yes
  else
    response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
  fi

  [[ "$response_lc" = "y" ]]
}

# Provide meaningful error message before exiting
fatal() { echo "FATAL: $1"; exit 1; }
warning() { echo "WARNING: $1";}
info() { echo "INFO: $1";}
