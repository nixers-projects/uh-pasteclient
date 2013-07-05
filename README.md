##UnixHub Pastebin Client

###Install

* Accept the license
* Install the mechanize module
* Copy the file to your binary location
* chmod +x it
* Make sure you have everything set in your .netrc on a single line
> machine paste.xinu.at login my_username password my_secret_password
* That's it

In ~/.netrc, put:

``machine paste.unixhub.net login <username> password <password>``    

###Usage

Simply use it as followed:
    For uploading a file: hub filename filename2 filename3  
    For uploading what you STDIN in it: cat file1| hub -stdin

Written by venam

