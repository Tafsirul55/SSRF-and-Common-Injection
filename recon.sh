#!/bin/bash

# =========================
# Usage: ./passive.sh example.com
# =========================

domain=$1

if [ -z "$domain" ]; then
    echo "Usage: $0 domain.com"
    exit 1
fi

mkdir -p passive_$domain
cd passive_$domain

echo "========================================="
echo "[+] Target: $domain"
echo "========================================="

# =========================
echo "[+] Running Sublist3r..."
python3 ~/tools/Sublist3r/sublist3r.py -d $domain -o sublist3r.txt

echo "[+] Running subfinder..."
subfinder -d $domain -all -v | tee subfinder.txt

echo "[+] Running assetfinder..."
assetfinder --subs-only $domain | tee assetfinder.txt

#echo "[+] Running amass (passive)..."
#amass enum -passive -d $domain -v -o amass.txt

echo "[+] Running waybackurls_subdomains..."
waybackurls $domain | unfurl --unique domains > waybackurls_subdomains.txt

echo "[+] Running crt..."
crtsh $domain | tee crt.txt

echo "[+] Running chaos..."
chaos -d $domain -silent | tee chaos.txt

echo "[+] Running github-subdomains..."
github-subdomains -d $domain -o github.txt

# =========================
echo "[+] Merging all results..."

cat *.txt | sort -u | tee all_passive.txt

echo "========================================="
echo "[+] Total Subdomains Found:"
wc -l all_passive.txt
echo "========================================="

# =========================
echo "[+] Live..."
cat all_passive.txt | httpx -follow-redirects > live.txt

# =========================
echo "[+] Total Live Sub-domain..."
wc -l live.txt
echo "========================================="

echo "[+] Saved: passive_$domain/all_passive.txt"
echo "[+] Done 🚀"

echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="




#!/bin/bash

# Usage: ./urlenum.sh live.txt

input=$1

if [ -z "$input" ]; then
    echo "Usage: ./urlenum.sh live.txt"
    exit 1
fi

echo "[+] Running gau..."
cat $input | gau --subs | tee gau.txt

echo "[+] Running subjs..."
cat $input | subjs -ua ~/user-agents.txt | tee subjs.txt

echo "[+] Running waybackurls..."
cat $input | waybackurls | tee waybackurls.txt

echo "[+] Running getJS..."
cat $input | getJS --complete | tee getjs.txt

echo "[+] Running hakrawler..."
cat $input | hakrawler -subs -d 4 | tee hakrawler.txt

echo "[+] Running urlfinder..."
urlfinder -list $input -all | tee urlfinder.txt

echo "[+] Running katana..."
katana -list $input -d 4 -jc -kf all | tee katana.txt

echo "[+] Running gospider..."
gospider -S $input -d 3 --js --robots --sitemap | grep -Eo 'https?://[^ ]+' | tee gospider.txt

echo "[+] Running xnLinkFinder..."
xnLinkFinder -i $input -sf $input
cat output.txt >> xnl.txt
rm output.txt parameters.txt

echo "[+] Running cariddi..."
cat $input | cariddi -ua ~/user-agents.txt | tee cariddi.txt

echo "[+] Merging all URLs..."

cat gau.txt >> all-urls.txt
cat subjs.txt >> all-urls.txt
cat waybackurls.txt >> all-urls.txt
cat getjs.txt >> all-urls.txt
cat hakrawler.txt >> all-urls.txt
cat urlfinder.txt >> all-urls.txt
cat katana.txt >> all-urls.txt
cat gospider.txt >> all-urls.txt
cat xnl.txt >> all-urls.txt
cat cariddi.txt >> all-urls.txt

sort -u all-urls.txt -o all-urls.txt

echo "[+] Extracting JS files..."

cat all-urls.txt | grep -Ei '\.js([?#].*)?$' | sort -u > js.txt

echo
echo "[+] Total URLs from gau:"
wc -l gau.txt

echo "[+] Total URLs from subjs:"
wc -l subjs.txt

echo "[+] Total URLs from waybackurls:"
wc -l waybackurls.txt

echo "[+] Total URLs from getJS:"
wc -l getjs.txt

echo "[+] Total URLs from hakrawler:"
wc -l hakrawler.txt

echo "[+] Total URLs from urlfinder:"
wc -l urlfinder.txt

echo "[+] Total URLs from katana:"
wc -l katana.txt

echo "[+] Total URLs from gospider:"
wc -l gospider.txt

echo "[+] Total URLs from xnLinkFinder:"
wc -l xnl.txt

echo "[+] Total URLs from cariddi:"
wc -l cariddi.txt

echo
echo "[+] Total Unique URLs:"
wc -l all-urls.txt

echo "[+] Total JS Files:"
wc -l js.txt

echo
echo "[+] Done 🚀"



echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="
echo "========================================="



#!/bin/bash

# Usage: ./gf.sh all-urls.txt

input=$1

if [ -z "$input" ]; then
    echo "Usage: ./gf.sh all-urls.txt"
    exit 1
fi

echo "[+] Extracting parameters..."
cat $input | grep "=" | sort -u | tee parameters.txt

echo "[+] Creating gf directory..."
mkdir -p gf

echo "[+] Running debug_logic..."
cat parameters.txt | gf debug_logic | tee gf/debug_logic.txt

echo "[+] Running idor..."
cat parameters.txt | gf idor | tee gf/idor.txt

echo "[+] Running img-traversal..."
cat parameters.txt | gf img-traversal | tee gf/img-traversal.txt

echo "[+] Running interestingEXT..."
cat $input | gf interestingEXT | tee gf/interestingEXT.txt

echo "[+] Running interestingparams..."
cat parameters.txt | gf interestingparams | tee gf/interestingparams.txt

echo "[+] Running interestingsubs..."
cat $input | gf interestingsubs | tee gf/interestingsubs.txt

echo "[+] Running jsvar..."
cat $input | gf jsvar | tee gf/jsvar.txt

echo "[+] Running lfi..."
cat parameters.txt | gf lfi | tee gf/lfi.txt

echo "[+] Running rce..."
cat parameters.txt | gf rce | tee gf/rce.txt

echo "[+] Running redirect..."
cat parameters.txt | gf redirect | tee gf/redirect.txt

echo "[+] Running sqli..."
cat parameters.txt | gf sqli | tee gf/sqli.txt

echo "[+] Running ssrf..."
cat parameters.txt | gf ssrf | tee gf/ssrf.txt

echo "[+] Running ssti..."
cat parameters.txt | gf ssti | tee gf/ssti.txt

echo "[+] Running xss..."
cat parameters.txt | gf xss | tee gf/xss.txt

echo
echo "[+] Results Summary"
echo "=============================="

echo "[+] debug_logic:"
wc -l gf/debug_logic.txt

echo "[+] idor:"
wc -l gf/idor.txt

echo "[+] img-traversal:"
wc -l gf/img-traversal.txt

echo "[+] interestingEXT:"
wc -l gf/interestingEXT.txt

echo "[+] interestingparams:"
wc -l gf/interestingparams.txt

echo "[+] interestingsubs:"
wc -l gf/interestingsubs.txt

echo "[+] jsvar:"
wc -l gf/jsvar.txt

echo "[+] lfi:"
wc -l gf/lfi.txt

echo "[+] rce:"
wc -l gf/rce.txt

echo "[+] redirect:"
wc -l gf/redirect.txt

echo "[+] sqli:"
wc -l gf/sqli.txt

echo "[+] ssrf:"
wc -l gf/ssrf.txt

echo "[+] ssti:"
wc -l gf/ssti.txt

echo "[+] xss:"
wc -l gf/xss.txt

echo
echo "[+] Total Parameters:"
wc -l parameters.txt

echo
echo "[+] Done 🚀"
