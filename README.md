# Alien::Autotools ![static](https://github.com/PerlAlien/Alien-Autotools/workflows/static/badge.svg) ![linux](https://github.com/PerlAlien/Alien-Autotools/workflows/linux/badge.svg) ![windows](https://github.com/PerlAlien/Alien-Autotools/workflows/windows/badge.svg) ![macos](https://github.com/PerlAlien/Alien-Autotools/workflows/macos/badge.svg)

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
  # Alien::Autotools will pull in:
  #  - Alien::autoconf
  #  - Alien::automake
  #  - Alien::m4
  #  - Alien::libtool
  # all of which you will likely need.
  requires 'Alien::Autotools';
  plugin 'Build::Autoconf';
  build [
    '%{autoreconf} -vfi',
    '%{configure}',
    '%{make}',
    '%{make} install',
  ];
};
```

# DESCRIPTION

This [Alien](https://metacpan.org/pod/Alien) provides the minimum tools requires for building `autoconf` based projects
which do not come bundled with a working `configure` script.  It currently delegates
most of its responsibilities to [Alien::autoconf](https://metacpan.org/pod/Alien::autoconf), [Alien::automake](https://metacpan.org/pod/Alien::automake), [Alien::libtool](https://metacpan.org/pod/Alien::libtool),
and [Alien::m4](https://metacpan.org/pod/Alien::m4).

The most common use case from an [alienfile](https://metacpan.org/pod/alienfile) is shown above where `autoreconf` is called
from this [Alien](https://metacpan.org/pod/Alien), which allows the [Alien::Build::Plugin::Build::Autoconf](https://metacpan.org/pod/Alien::Build::Plugin::Build::Autoconf) to then
configure and build the alienized package.

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

# CAVEATS

This module is typically needed for other [Alien](https://metacpan.org/pod/Alien)s for a share install that use the
autotools / GNU build system without bundling a pre-built `configure` script.  If
possible it is better to use a version of the alienized package that includes a
pre-built `configure` script.

If you are a system vendor, then you should typically not need to package this module,
check to see if the dependency that requires it can be built as a system install
instead.

# HELPERS

This [Alien](https://metacpan.org/pod/Alien) provides all of the helpers provides by [Alien::m4](https://metacpan.org/pod/Alien::m4), [Alien::autoconf](https://metacpan.org/pod/Alien::autoconf),
[Alien::automake](https://metacpan.org/pod/Alien::automake) and [Alien::libtool](https://metacpan.org/pod/Alien::libtool).  Each helper will execute the corresponding
command.  You will want to sue the helpers instead of using the command names directly
because they will use the correct incantation on Windows.  The following list is a
subset of all of the helpers provided by this alien that are probably the most useful.

- m4
- autoreconf
- automake
- libtool
- libtoolize

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

This software is Copyright (c) 2012-2022 by Richard Simões.

This is free software, licensed under:

```
The GNU Lesser General Public License, Version 3, June 2007
```
