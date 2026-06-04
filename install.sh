#!/bin/bash

# =========================
# Usage: ./install.sh
# Full setup for recon.sh
# =========================

echo "========================================="
echo "[+] Starting Full Setup..."
echo "========================================="

# =========================
# SYSTEM PACKAGES
# =========================
echo "[+] Installing system packages..."
sudo apt update -y
sudo apt install -y \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    unzip \
    golang \
    chromium-browser

# =========================
# GO ENV SETUP
# =========================
echo "[+] Setting up Go environment..."
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# =========================
# GO TOOLS
# =========================
echo "[+] Installing Go tools..."

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/unfurl@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/lc/subjs@latest
go install github.com/003random/getJS@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/tomnomnom/gf@latest
go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/hahwul/dalfox/v2@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/sensepost/gowitness@latest
go install github.com/BishopFox/jsluice/cmd/jsluice@latest
go install github.com/MrEmpy/mantra@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

echo "[+] Go tools installed!"

# =========================
# PYTHON TOOLS
# =========================
echo "[+] Installing Python tools..."

mkdir -p ~/tools
cd ~/tools

# Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git
pip3 install -r Sublist3r/requirements.txt --break-system-packages

# SecretFinder
git clone https://github.com/m4ll0k/SecretFinder.git
pip3 install -r SecretFinder/requirements.txt --break-system-packages

# xnLinkFinder
pip3 install xnLinkFinder --break-system-packages

# cariddi
go install github.com/edoardottt/cariddi/cmd/cariddi@latest

echo "[+] Python tools installed!"

# =========================
# GF PATTERNS
# =========================
echo "[+] Installing gf patterns..."

mkdir -p ~/.gf

# default patterns
git clone https://github.com/tomnomnom/gf.git ~/tools/gf-tool
cp ~/tools/gf-tool/examples/*.json ~/.gf/ 2>/dev/null

# extra patterns
git clone https://github.com/1ndianl33t/Gf-Patterns.git ~/tools/Gf-Patterns
cp ~/tools/Gf-Patterns/*.json ~/.gf/ 2>/dev/null

echo "[+] GF patterns installed!"

# =========================
# GITHUB-SUBDOMAINS
# =========================
echo "[+] Installing github-subdomains..."
go install github.com/gwen001/github-subdomains@latest

# =========================
# TRUFFLEHOG
# =========================
echo "[+] Installing TruffleHog..."
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin

# =========================
# NUCLEI TEMPLATES
# =========================
echo "[+] Updating nuclei templates..."
nuclei -update-templates

# =========================
# USER AGENTS FILE
# =========================
echo "[+] Creating user-agents.txt..."
cat > ~/user-agents.txt << 'UAEOF'
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0
Mozilla/5.0 (Macintosh; Intel Mac OS X 14.2; rv:121.0) Gecko/20100101 Firefox/121.0
UAEOF

# =========================
# VERIFY
# =========================
echo ""
echo "========================================="
echo "[+] Verifying installations..."
echo "========================================="

tools=(
    subfinder
    assetfinder
    waybackurls
    unfurl
    httpx
    gau
    subjs
    hakrawler
    katana
    gospider
    gf
    chaos
    nuclei
    dalfox
    qsreplace
    gowitness
    jsluice
    dnsx
    cariddi
    trufflehog
    github-subdomains
)

for tool in "${tools[@]}"; do
    if command -v $tool &>/dev/null; then
        echo "  ✅ $tool"
    else
        echo "  ❌ $tool — NOT FOUND"
    fi
done

# python tools
if [ -d ~/tools/Sublist3r ]; then
    echo "  ✅ Sublist3r"
else
    echo "  ❌ Sublist3r — NOT FOUND"
fi

if [ -d ~/tools/SecretFinder ]; then
    echo "  ✅ SecretFinder"
else
    echo "  ❌ SecretFinder — NOT FOUND"
fi

echo "========================================="
echo "[+] Setup Complete! 🚀"
echo "[+] Run: source ~/.bashrc"
echo "[+] Then: ./recon.sh example.com"
echo "========================================="
