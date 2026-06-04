#!/bin/bash

# =========================
# Usage: ./install.sh
# Only for recon.sh
# =========================

echo "========================================="
echo "[+] Starting Setup for recon.sh..."
echo "========================================="

# =========================
# SYSTEM PACKAGES
# =========================
echo "[+] Installing system packages..."
sudo apt update -y
sudo apt install -y python3 python3-pip git curl jq golang

# =========================
# GO ENV
# =========================
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

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
go install github.com/gwen001/github-subdomains@latest
go install github.com/edoardottt/cariddi/cmd/cariddi@latest

echo "[+] Go tools done!"

# =========================
# PYTHON TOOLS
# =========================
echo "[+] Installing Python tools..."

mkdir -p ~/tools

# Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git ~/tools/Sublist3r
pip3 install -r ~/tools/Sublist3r/requirements.txt --break-system-packages

# xnLinkFinder
# pip3 install xnLinkFinder --break-system-packages
pip install xnLinkFinder --break-system-packages --ignore-installed

echo "[+] Python tools done!"

# =========================
# GF PATTERNS
# =========================
echo "[+] Installing gf patterns..."
mkdir -p ~/.gf
git clone https://github.com/tomnomnom/gf.git ~/tools/gf-tool
cp ~/tools/gf-tool/examples/*.json ~/.gf/ 2>/dev/null
git clone https://github.com/1ndianl33t/Gf-Patterns.git ~/tools/Gf-Patterns
cp ~/tools/Gf-Patterns/*.json ~/.gf/ 2>/dev/null
echo "[+] GF patterns done!"

# =========================
# CRTSH TOOL
# =========================
echo "[+] Installing crtsh..."
curl -s https://raw.githubusercontent.com/Tafsirul55/SSRF-and-Common-Injection/refs/heads/main/crtsh -o /usr/local/bin/crtsh
chmod +x /usr/local/bin/crtsh
echo "[+] crtsh done!"

# =========================
# USER AGENTS
# =========================
echo "[+] Creating user-agents.txt..."
cat > ~/user-agents.txt << 'UAEOF'
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0
UAEOF

# =========================
# VERIFY
# =========================
echo ""
echo "========================================="
echo "[+] Checking tools..."
echo "========================================="

tools=(
    subfinder assetfinder waybackurls unfurl
    httpx gau subjs hakrawler urlfinder
    katana gospider gf chaos
    github-subdomains cariddi crtsh
)

for tool in "${tools[@]}"; do
    if command -v $tool &>/dev/null; then
        echo "  ✅ $tool"
    else
        echo "  ❌ $tool"
    fi
done

[ -d ~/tools/Sublist3r ] && echo "  ✅ Sublist3r" || echo "  ❌ Sublist3r"
[ -f ~/user-agents.txt ] && echo "  ✅ user-agents.txt" || echo "  ❌ user-agents.txt"

echo "========================================="
echo "[+] Done! এখন চালান:"
echo "    source ~/.bashrc"
echo "    ./recon.sh example.com"
echo "========================================="
