#!/usr/bin/python3

import os
import subprocess
import tempfile
import urllib.request
import shutil

# List of DMG URLs
dmg_urls = [
    "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg",
    "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg",
    "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg",
    "https://devimages-cdn.apple.com/design/resources/download/NY.dmg",
]

def download_file(url, destination):
    """Download a file from a URL to a destination."""
    urllib.request.urlretrieve(url, destination)

def mount_dmg(dmg_path):
    """Mount the DMG and return the mount point."""
    output = subprocess.check_output(["hdiutil", "attach", dmg_path, "-nobrowse"], text=True)
    for line in output.splitlines():
        if "/Volumes/" in line:
            return line.split("\t")[-1]  # The mount point is in the last column
    return None

def install_pkg(mount_point):
    """Find and install the PKG inside the mounted DMG."""
    for root, _, files in os.walk(mount_point):
        for file in files:
            if file.endswith(".pkg"):
                pkg_path = os.path.join(root, file)
                subprocess.check_call(["sudo", "installer", "-pkg", pkg_path, "-target", "/"])
                return

def unmount_dmg(mount_point):
    """Unmount the DMG."""
    subprocess.check_call(["hdiutil", "detach", mount_point, "-quiet"])

def clean_up(file_path):
    """Remove temporary files."""
    if os.path.exists(file_path):
        os.remove(file_path)

def main():
    temp_dir = tempfile.mkdtemp()

    try:
        for dmg_url in dmg_urls:
            # Download the DMG
            dmg_file = os.path.join(temp_dir, os.path.basename(dmg_url))
            print(f"Downloading {dmg_url}...")
            download_file(dmg_url, dmg_file)

            # Mount the DMG
            print(f"Mounting {dmg_file}...")
            mount_point = mount_dmg(dmg_file)

            if not mount_point:
                print(f"Failed to mount {dmg_file}")
                continue

            print(f"Mounted at {mount_point}")

            # Install the PKG
            print(f"Installing PKG from {mount_point}...")
            install_pkg(mount_point)

            # Unmount the DMG
            print(f"Unmounting {mount_point}...")
            unmount_dmg(mount_point)

            # Clean up the downloaded DMG
            print(f"Cleaning up {dmg_file}...")
            clean_up(dmg_file)

        print("All installations completed successfully.")

    finally:
        # Clean up the temporary directory
        shutil.rmtree(temp_dir)

if __name__ == "__main__":
    main()