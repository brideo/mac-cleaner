# macOS System Cleaner

A comprehensive system cleanup script for macOS that functions as a CCleaner alternative. This script safely removes temporary files, caches, logs, and other unnecessary data to free up disk space and improve system performance.

## Features

The script performs 10 categories of cleanup operations:

1. **System Caches** - User and system cache files, DNS cache
2. **Browser Data** - Cache, history, and cookies for Safari, Chrome, Firefox, and Edge
3. **System & Application Logs** - User logs, system logs, diagnostic reports
4. **Temporary Files** - System temp files, trash, partial downloads
5. **Application Specific Data** - Xcode, Homebrew, npm, Docker, OrbStack, Slack, Discord, Spotify, VS Code
6. **Mail Data** - Mail app cache and envelope index
7. **System Maintenance** - Quick Look cache, font cache, launch services
8. **Downloads & Documents** - Old downloads (30+ days), .DS_Store files, empty directories
9. **Memory & Swap** - Swap files, sleep image, memory purge
10. **Final Cleanup** - Database updates and system optimizations

## Usage

1. Make the script executable:
   ```bash
   chmod +x mac-cleaner.sh
   ```

2. Run the script:
   ```bash
   ./mac-cleaner.sh
   ```

The script will:
- Display colored progress output
- Calculate and show disk space freed
- Prompt to empty trash permanently
- Recommend a system restart for optimal performance

## Safety Features

- Uses safe deletion functions with error handling
- Requires sudo only for system-level operations
- Preserves important system files
- Provides detailed logging of cleanup operations

## Requirements

- macOS operating system
- Admin/sudo privileges for system-level cleanup
- Optional: Homebrew, Docker, or other development tools for app-specific cleanup

## What Gets Cleaned

- **Caches**: Browser caches, system caches, application caches
- **Logs**: System logs, application logs, diagnostic reports
- **Temporary Files**: Downloads folder cleanup, partial downloads, trash
- **Developer Data**: Xcode derived data, npm cache, Docker images
- **System Files**: Font cache, Quick Look thumbnails, swap files

## Warning

This script removes data that may include:
- Browser history and cookies
- Application caches (may slow first launches)
- Log files (useful for troubleshooting)

Review the script before running to ensure it meets your needs.

## License

This script is provided as-is for educational and utility purposes.# mac-cleaner
