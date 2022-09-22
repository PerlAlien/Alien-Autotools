use Test2::V0 -no_srand => 1;
use Test::Alien;
use Test::Alien::Build;
use Path::Tiny ();
use Capture::Tiny qw( capture capture_merged );

our $path = Path::Tiny->new('corpus/foo')->absolute->stringify;

note "path = $path";

my $build = alienfile_ok q{

  use alienfile;

  probe sub { 'share' };

  share {

    requires 'Alien::Autotools';

    log "path = $main::path";

    fetch sub {
      my($build) = @_;
      return {
        type     => 'file',
        filename => 'foo',
        path     => $main::path,
        protocol => 'file',
      };
    };

    plugin 'Extract::Directory';

    plugin 'Build::Autoconf';

    build [
       [ 'sh', -c => 'autoreconf -vfi' ],
       '%{configure}',
       '%{make}',
       [ '%{make}', 'install' ],
     ];

  };

};

my $error;

note scalar capture_merged {
  eval {
    $build->load_requires('configure');
    $build->load_requires($build->install_type);
    $build->download;
    $build->build;
  };
  $error = $@;
};

is $@, '';

#note YAML::Dump({ runtime => $build->runtime_prop, install => $build->install_prop });

my $prefix = $build->install_prop->{stage};
my $bin = "$prefix/bin/foo";

ok -f $bin, "bin/foo exists";
note "$bin";

if($^O eq 'MSWin32')
{
  my($uname) = capture { system 'uname' };
  if(defined $uname && $uname =~ /MINGW(32|64)/)
  {
    $bin = [ 'sh', -c => $bin ];
  }
  else
  {
    eval q{ require Alien::MSYS };  ## no critic (BuiltinFunctions::ProhibitStringyEval)
    my $sh = Path::Tiny->new(Alien::MSYS::msys_path())->child('sh');
    $bin = [ $sh, -c => $bin ];
  }
}

run_ok($bin)
  ->success
  ->out_like(qr/hello foo/)
  ->note;

done_testing;
