#!/bin/bash

# =========================
# Usage: ./live-recon.sh live.txt
# =========================

livefile=$1

if [ -z "$livefile" ]; then
    echo "Usage: $0 live.txt"
    exit 1
fi

if [ ! -f "$livefile" ]; then
    echo "[!] File not found: $livefile"
    exit 1
fi

# Use filename (without extension) as working folder name
name=$(basename "$livefile" | sed 's/\.[^.]*$//')

mkdir -p "$HOME/$name"
cp "$livefile" "$HOME/$name/live.txt"
cd "$HOME/$name"

echo "========================================="
echo "[+] Using live file: $livefile"
echo "[+] Working dir: $HOME/$name"
echo "========================================="

echo "[+] Total Live Sub-domain..."
wc -l live.txt
echo "========================================="

# =========================
# PHASE 2: URL ENUM
# =========================

echo "[+] Running gau..."
cat live.txt | gau --subs | tee gau.txt

echo "[+] Running subjs..."
cat live.txt | subjs -ua ~/user-agents.txt | tee subjs.txt

echo "[+] Running waybackurls..."
cat live.txt | waybackurls | tee waybackurls.txt

echo "[+] Running getJS..."
cat live.txt | getJS --complete | tee getjs.txt

echo "[+] Running hakrawler..."
cat live.txt | hakrawler -subs -d 4 | tee hakrawler.txt

echo "[+] Running urlfinder..."
urlfinder -list live.txt -all | tee urlfinder.txt

echo "[+] Running katana..."
katana -list live.txt -d 4 -jc -kf all | tee katana.txt

echo "[+] Running gospider..."
gospider -S live.txt -d 3 --js --robots --sitemap | grep -Eo 'https?://[^ ]+' | tee gospider.txt

echo "[+] Running xnLinkFinder..."
xnLinkFinder -i live.txt -sf live.txt
cat output.txt >> xnl.txt
rm -f output.txt parameters.txt

echo "[+] Running cariddi..."
cat live.txt | cariddi -ua ~/user-agents.txt | tee cariddi.txt

echo "[+] Merging all URLs..."
cat gau.txt waybackurls.txt subjs.txt getjs.txt \
    hakrawler.txt urlfinder.txt katana.txt \
    gospider.txt xnl.txt cariddi.txt | \
    sort -u > all-urls.txt

echo "[+] Extracting JS files..."
cat all-urls.txt | grep -Ei '\.js([?#].*)?$' | sort -u > js.txt

echo
echo "[+] Total URLs from gau:         $(wc -l < gau.txt)"
echo "[+] Total URLs from subjs:        $(wc -l < subjs.txt)"
echo "[+] Total URLs from waybackurls:  $(wc -l < waybackurls.txt)"
echo "[+] Total URLs from getJS:        $(wc -l < getjs.txt)"
echo "[+] Total URLs from hakrawler:    $(wc -l < hakrawler.txt)"
echo "[+] Total URLs from urlfinder:    $(wc -l < urlfinder.txt)"
echo "[+] Total URLs from katana:       $(wc -l < katana.txt)"
echo "[+] Total URLs from gospider:     $(wc -l < gospider.txt)"
echo "[+] Total URLs from xnLinkFinder: $(wc -l < xnl.txt)"
echo "[+] Total URLs from cariddi:      $(wc -l < cariddi.txt)"
echo "[+] Total Unique URLs:            $(wc -l < all-urls.txt)"
echo "[+] Total JS Files:               $(wc -l < js.txt)"

# =========================
# PHASE 3: GF PATTERNS
# =========================

echo "[+] Extracting parameters..."
cat all-urls.txt | grep "=" | sort -u | tee parameters.txt

mkdir -p gf

echo "[+] Running gf patterns..."
cat parameters.txt | gf debug_logic    | tee gf/debug_logic.txt
cat parameters.txt | gf idor           | tee gf/idor.txt
cat parameters.txt | gf img-traversal  | tee gf/img-traversal.txt
cat all-urls.txt   | gf interestingEXT | tee gf/interestingEXT.txt
cat parameters.txt | gf interestingparams | tee gf/interestingparams.txt
cat all-urls.txt   | gf interestingsubs   | tee gf/interestingsubs.txt
cat all-urls.txt   | gf jsvar          | tee gf/jsvar.txt
cat parameters.txt | gf lfi            | tee gf/lfi.txt
cat parameters.txt | gf rce            | tee gf/rce.txt
cat parameters.txt | gf redirect       | tee gf/redirect.txt
cat parameters.txt | gf sqli           | tee gf/sqli.txt
cat parameters.txt | gf ssrf           | tee gf/ssrf.txt
cat parameters.txt | gf ssti           | tee gf/ssti.txt
cat parameters.txt | gf xss            | tee gf/xss.txt

echo
echo "[+] GF Results Summary"
echo "=============================="
echo "[+] debug_logic:      $(wc -l < gf/debug_logic.txt)"
echo "[+] idor:             $(wc -l < gf/idor.txt)"
echo "[+] img-traversal:    $(wc -l < gf/img-traversal.txt)"
echo "[+] interestingEXT:   $(wc -l < gf/interestingEXT.txt)"
echo "[+] interestingparams:$(wc -l < gf/interestingparams.txt)"
echo "[+] interestingsubs:  $(wc -l < gf/interestingsubs.txt)"
echo "[+] jsvar:            $(wc -l < gf/jsvar.txt)"
echo "[+] lfi:              $(wc -l < gf/lfi.txt)"
echo "[+] rce:              $(wc -l < gf/rce.txt)"
echo "[+] redirect:         $(wc -l < gf/redirect.txt)"
echo "[+] sqli:             $(wc -l < gf/sqli.txt)"
echo "[+] ssrf:             $(wc -l < gf/ssrf.txt)"
echo "[+] ssti:             $(wc -l < gf/ssti.txt)"
echo "[+] xss:              $(wc -l < gf/xss.txt)"
echo "[+] Total Parameters: $(wc -l < parameters.txt)"

echo "========================================="
echo "[+] RECON COMPLETE (from live file): $livefile"
echo "[+] Folder: $HOME/$name"
echo "========================================="
echo "[+] Done 🚀"
