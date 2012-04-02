#!/usr/bin/env perl

use Test::More tests => 3;
use strict;
use warnings FATAL => "all";
use Alien::Autotools qw(autoconf_path automake_path libtool_path);

ok -x autoconf_path(), "autoconf found and is executable";
ok -x automake_path(), "autoconf found and is executable";
ok -x libtool_path(), "autoconf found and is executable";
