package Alien::Autotools;

use strict;
use warnings FATAL => "all";
use utf8;
use Exporter "import";

# VERSION
# ABSTRACT: Build and install the GNU build system.

our @EXPORT_OK = qw(autoconf_dir automake_dir libtool_dir);

sub autoconf_dir () { "##" }

sub automake_dir () { "##" }

sub libtool_dir () { "##" }

1;
