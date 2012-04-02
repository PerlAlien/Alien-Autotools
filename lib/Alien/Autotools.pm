package Alien::Autotools;

use strict;
use warnings FATAL => "all";
use utf8;
use Exporter "import";

# VERSION
# ABSTRACT: Build and install the GNU build system

our @EXPORT_OK = qw(autoconf_path automake_path libtool_path);

sub autoconf_path () { "##" }

sub automake_path () { "##" }

sub libtool_path () { "##" }

1;
