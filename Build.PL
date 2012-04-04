#!/usr/bin/env perl

use strict;
use warnings FATAL => "all";
use utf8;
use version;
use Archive::Tar;
use ExtUtils::CChecker;
use File::Spec::Functions qw(catdir catfile splitpath);
use IPC::Cmd qw(run can_run);
use Module::Build;
use Net::FTP;
use File::Path qw(make_path remove_tree);

# Prevent warnings about missing share directory:
make_path("share");

my $builder = Module::Build->new(
	# Defaults inserted by DistZilla:
	##{ $plugin->get_prereqs ##}
	##{ $plugin->get_default(qw(dist_name license dist_abstract)) ##}
	##{ $plugin->get_default(qw(dist_author)) ##}
	dist_version_from => "lib/Alien/Autotools.pm",
	share_dir => "share" );

my $base_dir = $builder->base_dir;
my $share_dir = catdir($base_dir, "share");

# Automake needs a possibly newer autoconf than what the system has, so add the
# new bin dir to $ENV{PATH}.
$ENV{PATH} = catdir($share_dir, "bin") . ":$ENV{PATH}";

my %autotools = map {
	my ($tool, $bin_path, $ftp_path) = @{$_}{qw(tool bin_path ftp_path)};
	my ($version) = $bin_path
		? do {
			my ($output) = ( run(
				command => [$bin_path, "--version"] ) )[2][0] =~ /([\d.]+)/ }
		: 0;
	# Convert to semantic version
	$version =~ s/^(?<!.)(\d\.\d+)$/$1.0/m;
	if ( !$ENV{COMPILE_ALIEN_AUTOTOOLS}
		 && version->new($version) >= $_->{min_version} ) {
		# Skipping installation and passing directory of path found by &can_run:
		$tool => join "", ( splitpath($bin_path) )[0, 1] }
	else {
		print "Downloading $tool source archive from ftp.gnu.org...\n";
		my $ftp = Net::FTP->new("ftp.gnu.org")
			or die "Unable to connect to FTP server";
		$ftp->login or die "Unable to anonymously login to FTP server";
		$ftp->binary;
		$ftp->get($ftp_path) or die "Failed to download $ftp_path";
		$ftp->quit;

		my ($archive) = glob("*.tar.gz");
		Archive::Tar->new($archive)->extract;
		unlink $archive;

		my ($tool_dir) = glob "$tool-*";
		chdir $tool_dir;
		run( command => ["./configure", "--prefix=$share_dir"] )
			or die "Failed to configure $tool";
		print "Compiling $tool...\n";
		run( command => [qw(make -j9)]) or die "Failed to make $tool";
		print "Installing...\n";
		run( command => [qw(make install)] )
			or die "Failed to install $tool";
		chdir $base_dir;
		remove_tree($tool_dir);

		# Passing sharedir path of new installation:
		$tool, catdir($share_dir, "bin") } }
	{ tool => "autoconf",
	  min_version => version->new("2.68.0"),
	  bin_path => can_run("autoconf"),
	  ftp_path => "/gnu/autoconf/autoconf-2.68.tar.gz" },
	{ tool => "automake",
	  min_version => version->new("1.11.0"),
	  bin_path => can_run("automake"),
	  ftp_path => "/gnu/automake/automake-1.11.3.tar.gz" },
	{ tool => "libtool",
	  min_version => version->new("2.4.0"),
	  bin_path => can_run("libtool"),
	  ftp_path => "/gnu/libtool/libtool-2.4.2.tar.gz" };

# Update Perl module:
do {
	open my $LIB, "<", catdir qw(lib Alien Autotools.pm);
	local $/;
	my $lib = <$LIB>;
	close $LIB;
	$lib =~ s/##/$autotools{autoconf}/;
	$lib =~ s/##/$autotools{automake}/;
	$lib =~ s/##/$autotools{libtool}/;
	open $LIB, ">", "lib/Alien/Autotools.pm";
	print $LIB $lib };

# Update manifest:
my @share_files = map { glob catdir qw(share $_ *) } qw(bin share);
@share_files > 0 and do {
	open my $MANIFEST, ">>", "MANIFEST";
	print $MANIFEST map {
		catfile($builder->dist_dir, $_) . "\n" } @share_files };

$builder->create_build_script;
