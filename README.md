This is a simple script that allows the user to quickly backup and
restore their Firefox profile. The profile is backed up to a remote
machine over ssh.

# Installation
    git clone https://github.com/rhmaa/firefox-profile-backup.git
    chmod +x ~/firefox-profile-backup/ffb.sh
    cp ~/firefox-profile-backup/ffb.sh ~/.local/bin/ffb
    rm -rf ~/firefox-profile-backup

Before running the script, make sure that the variables `remotedir`
and `port` are set. If you have more than one Firefox profile, make
sure to adjust the variable `ffprofile` accordingly.

Once the variables are set, and once the script has been placed in
`~/.local/bin`, you can call the script at any time by typing `ffb` in
your terminal.

Note that the script requires sqlite3 to run. This helps us determine
if the user has Firefox open or not, as the database will be locked
when Firefox is running. This in turn prevents us from fucking up the
database accidentally.

Install sqlite3 on Fedora:
`# dnf install sqlite`

# Usage
`ffb -h` - help - prints a help message with available commands.

`ffb -b` - backup - copies the Firefox profile from the local machine to the remote machine.

`ffb -s` - sync - copies the Firefox profile from the remote machine to the local machine.
