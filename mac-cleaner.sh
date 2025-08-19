#!/bin/bash

#################################################################
# macOS System Cleanup Script
# This script cleans temporary files, caches, logs, and more
# Run with: chmod +x mac-cleaner.sh && ./mac-cleaner.sh
#################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track space freed
INITIAL_SPACE=$(df -k / | tail -1 | awk '{print $4}')

echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              macOS System Cleaner                    ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""

# Function to safely delete with error handling
safe_delete() {
    local path="$1"
    local description="$2"
    
    if [ -e "$path" ] || [ -d "$path" ]; then
        echo -e "${YELLOW}Cleaning:${NC} $description"
        rm -rf "$path" 2>/dev/null || sudo rm -rf "$path" 2>/dev/null
    fi
}

# Function to clean with pattern matching
clean_pattern() {
    local pattern="$1"
    local description="$2"
    
    echo -e "${YELLOW}Cleaning:${NC} $description"
    find $pattern -type f -delete 2>/dev/null
}

#################################################################
# SYSTEM CACHES
#################################################################
echo -e "\n${GREEN}[1/10] System Caches${NC}"
echo "----------------------------------------"

# User caches
safe_delete ~/Library/Caches/* "User cache files"

# System caches (requires sudo)
sudo rm -rf /Library/Caches/* 2>/dev/null
sudo rm -rf /System/Library/Caches/* 2>/dev/null

# DNS cache
echo -e "${YELLOW}Flushing:${NC} DNS cache"
sudo dscacheutil -flushcache 2>/dev/null
sudo killall -HUP mDNSResponder 2>/dev/null

#################################################################
# BROWSER DATA
#################################################################
echo -e "\n${GREEN}[2/10] Browser Data${NC}"
echo "----------------------------------------"

# Safari
safe_delete ~/Library/Safari/History.db "Safari history"
safe_delete ~/Library/Safari/Downloads.plist "Safari downloads history"
safe_delete ~/Library/Safari/RecentlyClosedTabs.plist "Safari recently closed tabs"
safe_delete ~/Library/Caches/com.apple.Safari/* "Safari cache"
safe_delete ~/Library/Caches/com.apple.Safari.SafeBrowsing/* "Safari safe browsing cache"

# Chrome
safe_delete ~/Library/Caches/Google/Chrome/* "Chrome cache"
safe_delete "~/Library/Application Support/Google/Chrome/Default/History" "Chrome history"
safe_delete "~/Library/Application Support/Google/Chrome/Default/Cookies" "Chrome cookies"
safe_delete "~/Library/Application Support/Google/Chrome/Default/Cache/*" "Chrome cache data"
safe_delete "~/Library/Application Support/Google/Chrome/Default/Application Cache/*" "Chrome app cache"

# Firefox
safe_delete ~/Library/Caches/Firefox/* "Firefox cache"
safe_delete "~/Library/Application Support/Firefox/Profiles/*/cache2/*" "Firefox cache2"
safe_delete "~/Library/Application Support/Firefox/Profiles/*/thumbnails/*" "Firefox thumbnails"

# Edge
safe_delete ~/Library/Caches/Microsoft\ Edge/* "Edge cache"
safe_delete "~/Library/Application Support/Microsoft Edge/Default/Cache/*" "Edge cache data"

#################################################################
# LOGS
#################################################################
echo -e "\n${GREEN}[3/10] System & Application Logs${NC}"
echo "----------------------------------------"

# User logs
safe_delete ~/Library/Logs/* "User logs"

# System logs
sudo rm -rf /Library/Logs/* 2>/dev/null
sudo rm -rf /var/log/*.log 2>/dev/null
sudo rm -rf /var/log/*.out 2>/dev/null
safe_delete /private/var/log/asl/*.asl "ASL logs"

# Diagnostic reports
safe_delete ~/Library/Logs/DiagnosticReports/* "Diagnostic reports"
sudo rm -rf /Library/Logs/DiagnosticReports/* 2>/dev/null

#################################################################
# TEMPORARY FILES
#################################################################
echo -e "\n${GREEN}[4/10] Temporary Files${NC}"
echo "----------------------------------------"

# System temp files (exclude socket files to prevent service crashes)
echo -e "${YELLOW}Cleaning:${NC} System temporary files (preserving sockets)"
find /tmp -type f ! -name "*.sock" ! -name "*.lock" ! -name "*.pid" -delete 2>/dev/null
safe_delete /var/tmp/* "Variable temporary files"
safe_delete /private/tmp/* "Private temporary files"
safe_delete ~/Library/Caches/TemporaryItems/* "Temporary items"

# User temp files
safe_delete ~/.Trash/* "Trash"
safe_delete ~/Downloads/*.download "Partial downloads"
safe_delete ~/Downloads/*.crdownload "Chrome partial downloads"
safe_delete ~/Downloads/*.part "Firefox partial downloads"

#################################################################
# APPLICATION SPECIFIC
#################################################################
echo -e "\n${GREEN}[5/10] Application Specific Data${NC}"
echo "----------------------------------------"

# Xcode
safe_delete ~/Library/Developer/Xcode/DerivedData/* "Xcode derived data"
safe_delete ~/Library/Developer/Xcode/Archives/* "Xcode archives"
safe_delete ~/Library/Developer/CoreSimulator/Caches/* "iOS Simulator caches"
safe_delete ~/Library/Developer/CoreSimulator/Devices/* "Old simulator devices"

# Homebrew
echo -e "${YELLOW}Cleaning:${NC} Homebrew cache"
brew cleanup -s 2>/dev/null
rm -rf $(brew --cache) 2>/dev/null

# npm
safe_delete ~/.npm/_cacache/* "npm cache"

# yarn
safe_delete ~/Library/Caches/Yarn/* "Yarn cache"

# pip
safe_delete ~/Library/Caches/pip/* "pip cache"

# Docker (if not using OrbStack)
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Cleaning:${NC} Docker system"
    docker system prune -af --volumes 2>/dev/null
fi

# OrbStack
safe_delete ~/Library/Caches/dev.kdrag0n.OrbStack/* "OrbStack cache"

# Slack
safe_delete ~/Library/Application\ Support/Slack/Cache/* "Slack cache"
safe_delete ~/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/* "Slack service worker cache"

# Discord
safe_delete ~/Library/Application\ Support/discord/Cache/* "Discord cache"
safe_delete ~/Library/Application\ Support/discord/Code\ Cache/* "Discord code cache"

# Spotify
safe_delete ~/Library/Caches/com.spotify.client/* "Spotify cache"
safe_delete ~/Library/Application\ Support/Spotify/PersistentCache/* "Spotify persistent cache"

# VS Code
safe_delete ~/Library/Application\ Support/Code/Cache/* "VS Code cache"
safe_delete ~/Library/Application\ Support/Code/CachedData/* "VS Code cached data"

#################################################################
# MAIL
#################################################################
echo -e "\n${GREEN}[6/10] Mail Data${NC}"
echo "----------------------------------------"

# Mail app
safe_delete ~/Library/Mail/V*/MailData/Envelope\ Index "Mail envelope index"
safe_delete ~/Library/Containers/com.apple.mail/Data/Library/Caches/* "Mail cache"

#################################################################
# SYSTEM MAINTENANCE
#################################################################
echo -e "\n${GREEN}[7/10] System Maintenance Files${NC}"
echo "----------------------------------------"

# Quick Look cache
safe_delete ~/Library/Caches/com.apple.QuickLook.thumbnailcache/* "Quick Look thumbnails"
qlmanage -r cache 2>/dev/null

# Font cache
echo -e "${YELLOW}Rebuilding:${NC} Font cache"
sudo atsutil databases -remove 2>/dev/null

# Spotlight index (optional - will rebuild automatically)
# echo -e "${YELLOW}Rebuilding:${NC} Spotlight index"
# sudo mdutil -E / 2>/dev/null

# Launch services
echo -e "${YELLOW}Rebuilding:${NC} Launch Services database"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user 2>/dev/null

#################################################################
# DOWNLOADS & DOCUMENTS
#################################################################
echo -e "\n${GREEN}[8/10] Downloads & Documents Cleanup${NC}"
echo "----------------------------------------"

# Old downloads (files older than 30 days)
echo -e "${YELLOW}Removing:${NC} Downloads older than 30 days"
timeout 30 find ~/Downloads -type f -mtime +30 -delete 2>/dev/null

# .DS_Store files (limited scope for performance)
echo -e "${YELLOW}Removing:${NC} .DS_Store files"
timeout 60 find ~/Desktop ~/Documents ~/Downloads ~/Pictures ~/Music ~/Movies -name ".DS_Store" -type f -delete 2>/dev/null
timeout 30 find ~/Library -maxdepth 3 -name ".DS_Store" -type f -delete 2>/dev/null

# Empty directories in Downloads
timeout 10 find ~/Downloads -type d -empty -delete 2>/dev/null

#################################################################
# MEMORY & SWAP
#################################################################
echo -e "\n${GREEN}[9/10] Memory & Swap${NC}"
echo "----------------------------------------"

# Swap files
safe_delete /private/var/vm/swapfile* "Swap files"

# Sleep image
sudo rm -rf /private/var/vm/sleepimage 2>/dev/null

# Memory pressure
echo -e "${YELLOW}Purging:${NC} Inactive memory"
sudo purge 2>/dev/null

#################################################################
# FINAL CLEANUP
#################################################################
echo -e "\n${GREEN}[10/10] Final Cleanup${NC}"
echo "----------------------------------------"

# Update database
echo -e "${YELLOW}Updating:${NC} locate database"
sudo /usr/libexec/locate.updatedb 2>/dev/null

# Rebuild Spotlight index for better performance
echo -e "${YELLOW}Note:${NC} Run 'sudo mdutil -E /' to rebuild Spotlight if search is slow"

#################################################################
# SUMMARY
#################################################################
echo -e "\n${GREEN}═══════════════════════════════════════════════════════${NC}"

# Calculate space freed
FINAL_SPACE=$(df -k / | tail -1 | awk '{print $4}')
SPACE_FREED=$((FINAL_SPACE - INITIAL_SPACE))
SPACE_FREED_MB=$((SPACE_FREED / 1024))

if [ $SPACE_FREED_MB -gt 0 ]; then
    echo -e "${GREEN}✓ Cleanup completed successfully!${NC}"
    echo -e "${GREEN}✓ Space freed: ~${SPACE_FREED_MB} MB${NC}"
else
    echo -e "${YELLOW}✓ Cleanup completed (some files may require restart)${NC}"
fi

echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"

# Optional: Empty trash
echo ""
read -p "Do you want to empty the Trash permanently? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf ~/.Trash/*
    echo -e "${GREEN}✓ Trash emptied${NC}"
fi

# Optional: Restart recommendation
echo ""
echo -e "${YELLOW}Recommendation:${NC} Restart your Mac for optimal performance"
echo -e "${YELLOW}Note:${NC} Some caches will rebuild automatically on next use"
