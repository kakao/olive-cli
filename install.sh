#!/bin/bash

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
          /usr/bin/ruby -e "$(sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  # Install Homebrew if not installed
        fi
        sudo brew install "$package"
      else
        # Unknown.
        echo "Your OS is not supported for this script."
        exit 1
      fi
    fi
}

# install required packages
install_package_if_absent curl
install_package_if_absent tar
install_package_if_absent jq

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
OLIVE_CLI_LATEST_RELEASE=$(sudo curl -s "https://api.github.com/repos/kakao/olive-cli/releases/latest")

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  OLIVE_CLI_ARCHIVE_URL=$(echo "$OLIVE_CLI_LATEST_RELEASE" | jq -r '.assets[] | select(.name | contains("Linux")) | .browser_download_url')
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  OLIVE_CLI_ARCHIVE_URL=$(echo "$OLIVE_CLI_LATEST_RELEASE" | jq -r '.assets[] | select(.name | contains("macOS")) | .browser_download_url')
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
else
    echo "Installation failed."
fi
