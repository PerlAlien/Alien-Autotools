#!/usr/bin/env perl

use v5.10;
use strict;
use warnings FATAL => "all";
use utf8;
use version;
use Archive::Tar;
use ExtUtils::CChecker;
use File::Spec::Functions qw(catdir catfile);
use File::Which "which";
use IPC::Cmd "run";
use Module::Build;
use Data::Dump "dump";
use Net::FTP;

my $builder = Module::Build->new(
	# Defaults inserted by DistZilla:
	##{ $plugin->get_prereqs ##}
	##{ $plugin->get_default(qw(dist_name license dist_abstract)) ##}
	##{ $plugin->get_default(qw(dist_author)) ##}
	dist_version_from => "lib/Alien/Autotools.pm",
	share_dir => "share" );

my %autotools = map {
	my ($tool, $ftp_path) = @{$_}{qw(tool ftp_path)};
	my $path = which($tool);
	my ($version) = $path
		? do {
			my $installed = (run(
				command => [$path, "--version"]))[2] =~ /\) ([0-9.]+)$/m;
			# Convert to semantic version
			$installed =~ s/^(\d\.\d+)$/$1.0/ }
		: 0;
	if ( version->new($version) >= $_->{min_version} ) {
		# Skipping installation and passing path found by &which:
		$tool => $path }
	else {
		say "Downloading source archive from ftp.gnu.org...";
		my $ftp = Net::FTP->new("ftp.gnu.org")
			or die "Unable to connect to FTP server";
		$ftp->login or die "Unable to anonymously login to FTP server";
		$ftp->binary;
		$ftp->get($ftp_path) or die "Failed to download $ftp_path";
		$ftp->quit;

		my ($archive) = glob("*.tar.gz");
		Archive::Tar->new($archive)->extract;
		unlink $archive;

		my $base_dir = $builder->base_dir;
		my $share_dir = catdir($base_dir, "share");
		my $tool_dir = glob "*$tool*";
		chdir $tool_dir;

		run( command => ["./configure", "--prefix=$share_dir"] )
			or die "Failed to configure $tool";
		say "Compiling...";
		run( command => [qw(make -j9)]) or die "Failed to make $tool";
		say "Installing $tool...";
		run( command => [qw(make install)] )
			or die "Failed to install $tool";
		chdir $base_dir;

		# Passing sharedir path of new installation:
		$tool, catfile($share_dir, "bin", $tool) } }

	{ tool => "autoconf",
	  min_version => version->new("2.68.0"),
	  bin_path => which("autoconf"),
	  ftp_path => "/gnu/autoconf/autoconf-2.68.tar.gz" },
	{ tool => "automake",
	  min_version => version->new("1.11.0"),
	  bin_path => which("automake"),
	  ftp_path => "ftp.gnu.org/gnu/automake/automake-1.11.3.tar.gz" },
	{ tool => "libtool",
	  min_version => version->new("2.4.0"),
	  bin_path => which("libtool"),
	  ftp_path => "ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz" };

say dump \%autotools;
