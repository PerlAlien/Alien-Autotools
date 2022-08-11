package Alien::Autotools;

use strict;
use warnings;
use base qw( Exporter );
use File::Which ();
use Path::Tiny  ();
use Alien::autoconf 0.18;
use Alien::automake 0.18;
use Alien::libtool  0.15;
use Alien::m4       0.18;

our @EXPORT_OK = qw(autoconf_dir automake_dir libtool_dir);

# ABSTRACT: Build and install the GNU build system.
# VERSION

=head1 SYNOPSIS

From Perl:

 use Alien::Autotools;
 use Env qw( @PATH @ACLOCAL_PATH );
 
 unshift @PATH, Alien::Autotools->bin_dir;
 unshift @ACLOCAL_PATH, Alien::Autotools->aclocal_dir;
 
 system 'autoconf', ...;

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
  my @dir = map { $_->bin_dir }
            map { "Alien::$_" }
            qw( autoconf automake libtool m4 );
  @dir;
}

sub _dir_from_exe
{
  my($name) = @_;
  my $path = File::Which::which($name);
  die "unable to find $name in PATH" unless $path;
  Path::Tiny->new($path)->parent->stringify;
}

=head2 aclocal_dir

 my @dirs = Alien::Autotools->aclocal_dir;

Returns the list of directories that need to be added to C<ACLOCAL_PATH> in order for the
autotools to work correctly.

=cut

sub aclocal_dir
{
  my @dir;
  foreach my $alien (map { "Alien::$_" } qw( autoconf automake libtool m4 ))
  {
    my $dir = Path::Tiny->new($alien->dist_dir)->child(qw( share aclocal ));
    push @dir, $dir if -d $dir;
  }
  @dir;
}

=head2 versions

 my %versions = Alien::Autotools->versions;

Returns the versions of the various autotools that are available.

=cut

sub versions
{
  my %ver;
  foreach my $alien (qw( autoconf automake libtool m4 ))
  {
    my $class = "Alien::$alien";
    $ver{$alien} = $class->version;
  }
  %ver;
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

=head1 CAVEATS

This module is typically needed for other L<Alien>s for a share install that use the
autotools / GNU build system without bundling a pre-built C<configure> script.  If
possible it is better to use a version of the alienized package that includes a
pre-built C<configure> script.

If you are a system vendor, then you should typically not need to package this module,
check to see if the dependency that requires it can be built as a system install
instead.


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
