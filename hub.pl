#
# UH uploader perl version
# Under the UH License
# Coded by Venam
#

use warnings;
use strict;
use WWW::Mechanize;
use IO::Socket::SSL;

my $br;
my $user        = "";
my $passwd      = "";
my $text_or_not = 0;
my $HEADER      = "\033[95m";
my $OKBLUE      = "\033[94m";
my $OKGREEN     = "\033[92m";
my $WARNING     = "\033[93m";
my $FAIL        = "\033[91m";
my $ENDC        = "\033[0m";
my $INFO        = $HEADER . "[". $OKBLUE ."*" . $HEADER ."] ". $ENDC;
my $ARROW       = " ". $OKGREEN . ">> ". $ENDC;
my $PLUS        = $HEADER ."[" . $OKGREEN ."+" . $HEADER ."] ". $ENDC;
my $MINUS       = $HEADER ."[". $FAIL ."-". $HEADER ."] ". $ENDC;

sub print_help() {
	print $MINUS . "Usage:  
	hub file
	cat file | hub -stdin\n";
}

#Read the .netrc configs
sub readconfigs() {
	open IN, $ENV{"HOME"}."/.netrc";
	for (<IN>) {
		if ($_ =~ /paste.unixhub.net/) {
			my @o_     = split / /, $_;
			$user   = $o_[3];
			$passwd = $o_[5];
		}
	}
}

sub create_br() {
	$br = WWW::Mechanize->new( agent => 'Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Firefox/17.0',
		ssl_opts => { 
			SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE,
			verify_hostname => 0,
		}
	);
}

sub login_in() {
	$br->get('http://paste.unixhub.net/index.php/user/login');
	$br->form_number(2);
	$br->field('username' => $user);
	chomp $passwd;
	$br->field('password' => $passwd);
	$br->click('process');
#	print $br->dump_forms();
	die("Cannot login\n") unless ($br->success);
}

sub uploading($) {
	my ($filename) = @_;
	
	if ($text_or_not == 1) {
		$br->submit_form (
			form_number => 1,
			fields      => {
				'content' => $filename,
			}
		);
	}
	else {
		$br->submit_form (
			form_number => 2,
			fields      => {
				'file[]' => $filename,
			}
		);
	}
	print $INFO . "Uploading" ."\n";
	if ($text_or_not == 0) {
		print $PLUS . "Finished uploading " . $filename."\n";
	}
}

if ( $#ARGV < 0 ) {
	print_help();
	exit(1);
}

readconfigs();
create_br();
login_in();

if ( $ARGV[0] eq  '-stdin' ||  $ARGV[0] eq '-s' || $ARGV[0] eq 's') {
	$text_or_not = 1;
	print $INFO . "From STDIN\n";
	my $filename = "";
	$filename .= $_ for (<STDIN>);
	uploading($filename);
	print $br->uri()."\n";
}
else {
	for my $arg (@ARGV) {
		if ($arg) {
			$br->get("http://paste.unixhub.net/index.php/file/index");
			uploading($arg);
			print $br->uri()."\n";
		}
	}
}


