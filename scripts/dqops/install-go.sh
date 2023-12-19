#!/bin/sh 

# Define the URL for the Go package
GO_PKG_URL="https://go.dev/dl/go1.20.12.linux-amd64.tar.gz"

# Define the local file name
GO_PKG_FILE="go1.20.12.tar.gz"

# Download the package
wget -O "$GO_PKG_FILE" "$GO_PKG_URL"

rm -rf /usr/lib/go
rm /usr/bin/go

tar -C /usr/lib -xzf "$GO_PKG_FILE"

ln -s /usr/lib/go/bin/go /usr/bin/go

# Check if the PATH modification already exists in .bashrc
if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
    echo 'export PATH=$PATH:/usr/lib/go/bin' >> ~/.bashrc
    echo "Path to Go added to .bashrc"
else
    echo "Path to Go already exists in .bashrc"
fi