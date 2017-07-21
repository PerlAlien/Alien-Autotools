use Test2::V0;
use Test::Alien;
use Alien::Autotools;

alien_ok 'Alien::Autotools';

run_ok([$_, '--version'], "run $_")
  ->success
  ->note for qw( autoconf automake libtool m4 );

done_testing;
