# Alien::Autotools ![static](https://github.com/Perl5-Alien/Alien-Autotools/workflows/static/badge.svg) ![linux](https://github.com/Perl5-Alien/Alien-Autotools/workflows/linux/badge.svg) ![windows](https://github.com/Perl5-Alien/Alien-Autotools/workflows/windows/badge.svg) ![macos](https://github.com/Perl5-Alien/Alien-Autotools/workflows/macos/badge.svg)

Build and install the GNU build system.

# SYNOPSIS

From Perl:

```perl
use Alien::Autotools;
use Env qw( @PATH @ACLOCAL_PATH );

unshift @PATH, Alien::Autotools->bin_dir;
unshift @ACLOCAL_PATH, Alien::Autotools->aclocal_dir;

system 'autoconf', ...;
```

From [alienfile](https://metacpan.org/pod/alienfile):

```perl
use alienfile;

share {
  requires 'Alien::Autotools';
};
```

# DESCRIPTION

This [Alien](https://metacpan.org/pod/Alien) provides the minimum tools requires for building `autoconf` based projects
which do not come bundled with a working `configure` script.  It currently delegates
most of its responsibilities to [Alien::autoconf](https://metacpan.org/pod/Alien::autoconf), [Alien::automake](https://metacpan.org/pod/Alien::automake), [Alien::libtool](https://metacpan.org/pod/Alien::libtool),
and [Alien::m4](https://metacpan.org/pod/Alien::m4).

# METHODS

## bin\_dir

```perl
my @dirs = Alien::Autotools->bin_dir;
```

Returns the list of directories that need to be added to `PATH` in order for the autotools
to work correctly.

## aclocal\_dir

```perl
my @dirs = Alien::Autotools->aclocal_dir;
```

Returns the list of directories that need to be added to `ACLOCAL_PATH` in order for the
autotools to work correctly.

## versions

```perl
my %versions = Alien::Autotools->versions;
```

Returns the versions of the various autotools that are available.

## autoconf\_dir

```perl
# legacy interface
use Alien:::Autotools qw( autoconf_dir );
my $dir = autoconf_dir;
```

Returns the directory path to autoconf

## automake\_dir

```perl
# legacy interface
use Alien:::Autotools qw( automake_dir );
my $dir = automake_dir;
```

Returns the directory path to automake

## libtool\_dir

```perl
# legacy interface
use Alien:::Autotools qw( libtool_dir );
my $dir = libtool_dir;
```

Returns the directory path to libtool

# SEE ALSO

- [Alien](https://metacpan.org/pod/Alien)
- [Alien::Build](https://metacpan.org/pod/Alien::Build)
- [alienfile](https://metacpan.org/pod/alienfile)
- [Alien::autoconf](https://metacpan.org/pod/Alien::autoconf)
- [Alien::automake](https://metacpan.org/pod/Alien::automake)
- [Alien::libtool](https://metacpan.org/pod/Alien::libtool)
- [Alien::m4](https://metacpan.org/pod/Alien::m4)

# AUTHOR

Original author: Richard Simões

Current maintainer: Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Richard Simões.

This is free software, licensed under:

```
The GNU Lesser General Public License, Version 3, June 2007
```
