#!/bin/bash

#
# This is a very simple script that copies Firefox bookmarks between a
# local machine and a remote machine, over ssh.
#

#
# On a machine with a fresh Firefox install, and with only one
# profile, the below variable does not have to be adjusted. If you
# have more than one Firefox profile, you have to specify the full
# path to the profile that has the bookmarks that you wish to back up.
#
# To find your profile, see the below instructions from Mozilla:
# support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data
#
# Example:
#
# ffprofile="$HOME/.mozilla/firefox/gtxvew1s.default-release"
#

ffprofile="$HOME/.mozilla/firefox/*-release"

#
# The following three variables must be set before the script
# is run. The script will not be able to execute unless the variables
# are set.
#
# 'remotehost' is the IP address of the remote machine, and the user
# that we wish to connect as.
#
# 'remotedir' is the full filepath of the directory to which the
# bookmarks will be backed up. In the example below, the bookmarks are
# being backed up to a directory called 'firefox_bookmarks_backup', in
# the remote user's home folder.
#
# 'port' specifies the port through which ssh should make its
# connection. Default ssh port on most systems is 22.
#
# Example:
#
# remotehost="user@remote-machine"
# remotedir="~/firefox_bookmarks_backup"
# port=22
#

remotehost=
remotedir=
port=

if [ -z "$remotedir" ] || [ -z "$port" ]; then
    printf "error: Remote host, port and directory must be set before this script can run.\n"
    printf "Open this script in a text editor and follow the instructions in the comments.\n\n"
    exit 1
fi

print_usage() {
    printf "usage: [-b] Backup bookmarks to remote machine.\n"
    printf "       [-r] Copy bookmarks from remote machine to local machine.\n"
    printf "       [-s] Check if the bookmarks are backed up.\n"
    printf "       [-h] Print this help message.\n\n"
}

if (( $# == 0 )); then
    printf "error: Expected a flag.\n"
    print_usage
    exit 1;
elif (( $# > 1 )); then
    printf "error: Cannot take more than one flag.\n"
    print_usage
    exit 1;
fi

while getopts 'brsh' flag
do
    case "${flag}" in
        b)
            scp -Oq -P $port $ffprofile/places.sqlite $remotehost:$remotedir
            if (( $? == 0 )); then
                printf "Bookmarks have been backed up to the remote machine.\n\n"
            else
                printf "error: Could not copy bookmarks.\n\n"
            fi
            ;;
        r)
            scp -Oq -P $port $remotehost:$remotedir/places.sqlite $ffprofile
            if (( $? == 0 )); then
                printf "Bookmarks have been copied from the remote machine to the local machine.\n\n"
            else
                printf "error: Could not copy bookmarks.\n\n"
            fi
            ;;
        s)
            shalocal=$(sha1sum $ffprofile/places.sqlite | head -c 40)
            sharemote=$(ssh -p $port ssh://$remotehost "sha1sum $remotedir/places.sqlite" | head -c 40)

            if [[ $shalocal == $sharemote ]]; then
                printf "The bookmarks on the remote machine matches the bookmarks \n"
                printf "on the local machine.\n\n"
            else
                printf "The bookmarks on the remote machine does not match the \n"
                printf "bookmarks on the local machine.\n"
                printf "Run 'fbb -b' to backup your bookmarks.\n\n"
            fi
            ;;
        h)
            print_usage
            ;;
        *)
            print_usage
            exit 1
            ;;
    esac
done

exit 0
