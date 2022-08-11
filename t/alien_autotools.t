use Test2::V0 -no_srand => 1;
use Test::Alien 2.52;
use Alien::Autotools;

alien_ok 'Alien::Autotools';
plugin_ok 'Build::MSYS';

interpolate_run_ok("%{$_} --version")
  ->success
  ->note for qw( m4 autoconf automake libtool );

done_testing;
