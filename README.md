This is a simple script that allows the user to quickly backup and
restore their Firefox bookmarks. The bookmarks are backed up to a
remote machine over ssh.

# Installation
    git clone https://github.com/hevosmaa/firefox-bookmarks-backup.git
    chmod +x ~/firefox-bookmarks-backup/fbb.sh
    cp ~/firefox-bookmarks-backup/fbb.sh ~/.local/bin/fbb
    rm -rf ~/firefox-bookmarks-backup

Before running the script, make sure that the variables `remotedir`
and `port` are set. If you have more than one Firefox profile, make
sure to adjust the variable `ffprofile` accordingly.

Once the variables are set, and once the script has been placed in
`~/.local/bin`, you can call the script at any time by typing `fbb` in
your terminal.

# Usage
`fbb -h` - help - prints a help message with available commands.

`fbb -b` - backup - copies the Firefox bookmarks to a remote machine.

`fbb -r` - restore - fetches the Firefox bookmarks from a remote machine.
