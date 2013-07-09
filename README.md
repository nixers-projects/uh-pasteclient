##UnixHub Pastebin Client

###Install

* Accept the license
* Install the mechanize module
* Copy the file to your binary location
* chmod +x it

In ~/.netrc, put:

``machine paste.unixhub.net login <username> password <password>``    

###Usage

Simply use it as followed:
    For uploading a file: hub filename filename2 filename3  
    For uploading what you STDIN in it: cat file1| hub -s

Written by venam

