use Test2::V0 -no_srand => 1;
use Alien::Autotools qw(autoconf_dir automake_dir libtool_dir);
use File::Spec::Functions qw(catfile);

skip_all 'do not test on Windows' if $^O eq 'cygwin' or $^O eq 'MSWin32';

ok -x catfile( autoconf_dir(), "autoconf" ), "autoconf found and is executable";
note "dir = @{[ autoconf_dir() ]}";
ok -x catfile( automake_dir(), "automake" ), "automake found and is executable";
note "dir = @{[ automake_dir() ]}";
ok -x catfile( libtool_dir(), "libtool" ), "libtool found and is executable";
note "dir = @{[ libtool_dir() ]}";

done_testing;
