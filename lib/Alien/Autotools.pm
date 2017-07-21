package Alien::Autotools;

use strict;
use warnings;
use base qw( Exporter );
use File::Which ();
use Path::Tiny  ();
use Alien::autoconf;
use Alien::automake;
use Alien::libtool;
use Alien::m4;

our @EXPORT_OK = qw(autoconf_dir automake_dir libtool_dir);

# ABSTRACT: Build and install the GNU build system.
# VERSION

=head1 SYNOPSIS

From Perl:

 use Alien::Autotools;
 use Env qw( @PATH );
 
 unshift @PATH, Alien::Autotools->bin_dir;

From L<alienfile>:

 use alienfile;
 
 share {
   requires 'Alien::Autotools';
 };

=head1 DESCRIPTION

This L<Alien> provides the minimum tools requires for building C<autoconf> based projects
which do not come bundled with a working C<configure> script.  It currently delegates
most of its responsibilities to L<Alien::autoconf>, L<Alien::automake>, L<Alien::libtool>,
and L<Alien::m4>.

=head1 METHODS

=head2 bin_dir

 my @dirs = Alien::Autotools->bin_dir;

Returns the list of directories that need to be added to C<PATH> in order for the autotools
to work correctly.

=cut

sub bin_dir
{
  map { $_->bin_dir } map { "Alien::$_" } qw( autoconf automake libtool m4 );
}

sub _dir_from_exe
{
  my($name) = @_;
  my $path = File::Which::which($name);
  die "unable to find $name in PATH" unless $path;
  Path::Tiny->new($path)->parent->stringify;
}

=head2 autoconf_dir

 # legacy interface
 use Alien:::Autotools qw( autoconf_dir );
 my $dir = autoconf_dir;

Returns the directory path to autoconf

=cut

sub autoconf_dir ()
{
  my($dir) = Alien::autoconf->bin_dir;
  $dir
    ? $dir
    : _dir_from_exe('autoconf');
}

=head2 automake_dir

 # legacy interface
 use Alien:::Autotools qw( automake_dir );
 my $dir = automake_dir;

Returns the directory path to automake

=cut

sub automake_dir ()
{
  my($dir) = Alien::automake->bin_dir;
  $dir
    ? $dir
    : _dir_from_exe('automake');
}

=head2 libtool_dir

 # legacy interface
 use Alien:::Autotools qw( libtool_dir );
 my $dir = libtool_dir;

Returns the directory path to libtool

=cut

sub libtool_dir ()
{
  my($dir) = Alien::libtool->bin_dir;
  $dir
    ? $dir
    : _dir_from_exe('libtool');
}

sub cflags       {}
sub libs         {}
sub dynamic_libs {}

1;

=head1 SEE ALSO

=over 4

=item L<Alien>

=item L<Alien::Build>

=item L<alienfile>

=item L<Alien::autoconf>

=item L<Alien::automake>

=item L<Alien::libtool>

=item L<Alien::m4>

=back

=cut
