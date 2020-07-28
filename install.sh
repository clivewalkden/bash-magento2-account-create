#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #

  install_dir() {
    printf %s "${HOME}/.sozo/account-create"
  }

  latest_version() {
    echo "master"
  }

  #
  # Outputs the location to DB Sync depending on:
  # * The availability of $GIT_SOURCE
  #
  code_source() {
    local METHOD
    METHOD="$1"
    local SOURCE_URL
    SOURCE_URL="https://github.com/clivewalkden/bash-magento2-account-create.git"
    echo "$SOURCE_URL"
  }

  do_install() {
    local INSTALL_DIR
    INSTALL_DIR="$(install_dir)"

    # Downloading to $INSTALL_DIR
    mkdir -p "$INSTALL_DIR"
    if [ -f "$INSTALL_DIR/account_create" ]; then
      echo "=> account_create is already installed in $INSTALL_DIR, trying to update the script"
    else
      echo "=> Downloading account_create to '$INSTALL_DIR'"
    fi

    if [ -d "$INSTALL_DIR/.git" ]; then
      echo "=> account_create is already installed in $INSTALL_DIR, trying to update using git"
      command printf '\r=> '
      command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" fetch origin tag "$(latest_version)" --depth=1 2>/dev/null || {
        echo >&2 "Failed to update account_create, run 'git fetch' in $INSTALL_DIR yourself."
        exit 1
      }
    else
      # Cloning to $INSTALL_DIR
      echo "=> Downloading account_create from git to '$INSTALL_DIR'"
      command printf '\r=> '
      mkdir -p "${INSTALL_DIR}"
      if [ "$(ls -A "${INSTALL_DIR}")" ]; then
        command git init "${INSTALL_DIR}" || {
          echo >&2 'Failed to initialize account_create repo. Please report this!'
          exit 2
        }
        command git --git-dir="${INSTALL_DIR}/.git" remote add origin "$(code_source)" 2>/dev/null ||
          command git --git-dir="${INSTALL_DIR}/.git" remote set-url origin "$(code_source)" || {
          echo >&2 'Failed to add remote "origin" (or set the URL). Please report this!'
          exit 2
        }
        command git --git-dir="${INSTALL_DIR}/.git" fetch origin tag "$(latest_version)" --depth=1 || {
          echo >&2 'Failed to fetch origin with tags. Please report this!'
          exit 2
        }
      else
        command git -c advice.detachedHead=false clone "$(code_source)" -b "$(latest_version)" --depth=1 "${INSTALL_DIR}" || {
          echo >&2 'Failed to clone account_create repo. Please report this!'
          exit 2
        }
      fi
    fi
    command git -c advice.detachedHead=false --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" checkout -f --quiet "$(latest_version)"
    if [ -n "$(command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" show-ref refs/heads/master)" ]; then
      if command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch --quiet 2>/dev/null; then
        command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch --quiet -D master >/dev/null 2>&1
      else
        echo >&2 "Your version of git is out of date. Please update it!"
        command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch -D master >/dev/null 2>&1
      fi
    fi

    echo "=> Compressing and cleaning up git repository"
    if ! command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" reflog expire --expire=now --all; then
      echo >&2 "Your version of git is out of date. Please update it!"
    fi
    if ! command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" gc --auto --aggressive --prune=now; then
      echo >&2 "Your version of git is out of date. Please update it!"
    fi

    local PROFILE_INSTALL_DIR
    PROFILE_INSTALL_DIR="$(install_dir | command sed "s:^$HOME:\$HOME:")"
    SOURCE_STR="\\nexport CODE_DIR=\"${PROFILE_INSTALL_DIR}\"\\nif [ -f \"\$CODE_DIR/account_create\" ]; then\\n\t export PATH=\"$INSTALL_DIR:\$PATH\"\\nfi  # This loads account_create\\n"
    local PROFILE
    PROFILE="${HOME}/.bashrc"

    if ! command grep -qc '/account_create' "${PROFILE}"; then
      echo "=> Appending account_create source string to ${PROFILE}"
      command printf "${SOURCE_STR}" >>"${PROFILE}"
    else
      echo "=> account_create source string already in ${PROFILE}"
    fi

    \. "${PROFILE}"

    reset

    echo "=> Close and reopen your terminal to start using account_create"
  }

  #
  # Unsets the various functions defined
  # during the execution of the install script
  #
  reset() {
    unset -f install_dir latest_version code_source do_install
  }

  do_install

} # this ensures the entire script is downloaded #
