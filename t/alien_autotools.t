use Test2::V0 -no_srand => 1;
use Test::Alien;
use Alien::Autotools;
use Alien::m4;
use Capture::Tiny qw( capture );

if($^O eq 'MSWin32')
{
  my($uname) = capture { system 'uname' };
  if(defined $uname && $uname =~ /MINGW(32|64)/)
  {
    *wrapper = sub {
      my(@cmd) = @_;
      ['sh', -c => "@cmd"];
    };
  }
  else
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
}
else
{
  *wrapper = sub { [@_] };
}

alien_ok 'Alien::Autotools';

run_ok(wrapper($_, "--version"), "run $_")
  ->success
  ->note for qw( autoconf automake libtool );

run_ok(wrapper(Alien::m4->exe, "--version"), "run @{[ Alien::m4->exe ]}")
  ->success
  ->note;

done_testing;
