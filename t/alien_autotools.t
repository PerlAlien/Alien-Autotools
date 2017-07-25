use Test2::V0 -no_srand => 1;
use Test::Alien;
use Alien::Autotools;

if($^O eq 'MSWin32')
{
  skip_all 'test requires Alien::MSYS on MSWin32'
    unless eval q{ require Alien::MSYS; 1 };
  require File::Spec;
  my $sh = File::Spec->catfile(Alien::MSYS::msys_path(), 'sh');
  *wrapper = sub {
    my(@cmd) = @_;
    [$sh, -c => "@cmd"];
  };
}
else
{
  *wrapper = sub { [@_] };
}

alien_ok 'Alien::Autotools';

run_ok(wrapper($_, "--version"), "run $_")
  ->success
  ->note for qw( autoconf automake libtool m4 );

done_testing;
