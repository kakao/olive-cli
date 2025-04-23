#!/bin/bash
set -e

# functions
install_package_if_absent() {
    package=$1

    # Check if the package is installed
    if ! command -v "$package" >/dev/null 2>&1; then
      echo "$package is not installed. Installing..."

      # Determine OS
      if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get >/dev/null 2>&1; then
          # Debian-based distributions (e.g., Ubuntu)
          sudo apt-get update
          sudo apt-get install -y "$package"
        elif command -v yum >/dev/null 2>&1; then
          # Older RedHat-based distributions
          sudo yum install -y "$package"
        elif command -v dnf >/dev/null 2>&1; then
          # Newer RedHat-based distributions (Fedora, RHEL 8+)
          sudo dnf install -y "$package"
        else
          echo "Package manager not supported. Please install $package manually."
          exit 1
        fi
      elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        if ! command -v brew >/dev/null 2>&1; then
          /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  # Install Homebrew if not installed
        fi
        brew install "$package"
      else
        # Unknown.
        echo "Your OS is not supported for this script."
        exit 1
      fi
    fi
}

mkdir_if_absent() {
    directory=$1

    # If the directory doesn't exist, create it
    if [ ! -d "$directory" ]; then
        echo "Directory doesn't exist: $directory"
        echo "Creating directory: $directory"
        mkdir -p $directory
    fi
}

install_ort() {
    ORT_VERSION=$1
    ORT_RELEASE_URL="https://github.com/oss-review-toolkit/ort/releases/download/$ORT_VERSION/ort-$ORT_VERSION.tgz"
    CLI_PACKAGES_PATH="$HOME/.olive/packages"
    ORT_PATH="$CLI_PACKAGES_PATH/ort"

    echo "You need ort(https://github.com/oss-review-toolkit/ort) to use olive-cli."

    # Check if the package is already installed in global path.
    ORT_COMMAND="ort"
    if command -v $ORT_COMMAND >/dev/null 2>&1; then
        echo "ort is already installed in global path."
        echo "Although the ort is already installed in global path, olive-cli uses the ort in the $ORT_PATH."
    fi

    # Check if the package is already installed in $HOME/.olive/packages/ort.
    if [ -d "$ORT_PATH" ]; then
        echo "ort is already installed in $ORT_PATH."
        read -p "Do you want to replace the ort with v$ORT_VERSION? (y/n) " -r
    if [[ $REPLY =~ ^[Yy]$ ]]
        then
             sudo rm -rf "$ORT_PATH"
        else
          # Remove the downloaded file
          echo "Installation canceled..."
          exit 0
        fi
    # If the package is not installed, ask if the user wants to install it.
    else
        read -p "Do you want to download the ort v$ORT_VERSION to the $ORT_PATH? (y/n) " -r
            if [[ ! $REPLY =~ ^[Yy]$ ]]
            then
                # Remove the downloaded file
                echo "Installation canceled..."
                exit 0
            fi
    fi

    # If $HOME/.olive/packages directory doesn't exist, create it
    mkdir_if_absent $CLI_PACKAGES_PATH

    # Download the program using curl
    echo "Downloading ort v$ORT_VERSION from: $ORT_RELEASE_URL..."
    sudo curl -L "$ORT_RELEASE_URL" -o "$CLI_PACKAGES_PATH/ort.tar.gz"

    echo "Extract file: $CLI_PACKAGES_PATH/ort.tar.gz"
    sudo tar -zxvf "$CLI_PACKAGES_PATH/ort.tar.gz" -C "$CLI_PACKAGES_PATH"
    sudo mv "$CLI_PACKAGES_PATH/ort-$ORT_VERSION" "$ORT_PATH"

    # Set the ort as executable
    sudo chmod +x "$ORT_PATH/bin/ort"
    sudo rm "$CLI_PACKAGES_PATH/ort.tar.gz"

    echo "ort v$ORT_VERSION is installed in $ORT_PATH."
}

install_latest_olive_cli() {
    # if olive-cli already exists, ask if the user wants to replace it
    if [ -f "/usr/local/bin/olive-cli" ]; then
        read -p "The olive-cli exists. Would you like to replace? (y/n) " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
          # Remove the downloaded file
          echo "Installation canceled..."
          exit 0
        fi
    fi

    # Download latest release and parsing
    OLIVE_CLI_LATEST_RELEASE=$(curl -s "https://api.github.com/repos/kakao/olive-cli/releases/latest")
    # 에러 메시지 감지
    if echo "$OLIVE_CLI_LATEST_RELEASE" | jq -e 'has("message")' > /dev/null; then
      ERR_MSG=$(echo "$OLIVE_CLI_LATEST_RELEASE" | jq -r '.message')
      echo "GitHub API error: $ERR_MSG"
      exit 1
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux
      OLIVE_CLI_ARCHIVE_URL=$(echo "$OLIVE_CLI_LATEST_RELEASE" | jq -r '.assets[] | select(.name | contains("Linux")) | .browser_download_url')
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      # Mac OSX
      case "$(uname -m)" in
        arm64) ARCH="ARM64" ;;
        x86_64) ARCH="X64" ;;
      esac
      OLIVE_CLI_ARCHIVE_URL=$(echo "$OLIVE_CLI_LATEST_RELEASE" | jq -r --arg arch "$ARCH" '.assets[] | select(.name | contains("macOS") and contains($arch)) | .browser_download_url')
    else
      echo "Your OS is not supported for this script."
      exit 1
    fi

    # Download the program using curl
    echo "Downloading from: $OLIVE_CLI_ARCHIVE_URL"
    sudo curl -L "$OLIVE_CLI_ARCHIVE_URL" -o "olive-cli.tar.gz"

    # Extract the downloaded file
    echo "Extract file: $(pwd)/olive-cli.tar.gz"
    sudo tar -zxvf olive-cli.tar.gz

    # Set the downloaded program as executable
    echo "Set olive-cli as executable"
    sudo chmod +x olive-cli

    # Move the program to /usr/local/bin so it's in the PATH for all users
    echo "Move the program to /usr/local/bin so it's in the PATH for all users."
    sudo mv olive-cli /usr/local/bin/

    # Move the program to /usr/local/bin so it's in the PATH for all users
    echo "Move the NOTICE.md to /usr/local/share/doc/olive-cli"

    OLIVE_CLI_DOCUMENTS_DIR="/usr/local/share/doc/olive-cli"
    # If /usr/local/share/olive-cli directory doesn't exist, create it
    if [ ! -d "$OLIVE_CLI_DOCUMENTS_DIR" ]; then
        sudo mkdir -p $OLIVE_CLI_DOCUMENTS_DIR
    fi
    sudo mv NOTICE.md $OLIVE_CLI_DOCUMENTS_DIR/

    # Remove the downloaded file
    sudo rm olive-cli.tar.gz

    if command -v "olive-cli" >/dev/null 2>&1; then
        echo "Installation completed successfully."
        exit 0
    else
        echo "Installation failed."
        exit 1
    fi
}

# Start the installation process

# install required packages
install_package_if_absent curl
install_package_if_absent tar
install_package_if_absent jq

# install ort
install_ort "34.0.0"

# install olive-cli
install_latest_olive_cli
