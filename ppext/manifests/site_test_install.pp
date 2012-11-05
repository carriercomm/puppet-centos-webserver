node default {
  include bash, ppext, ppext::params

  $a = { b => 'c' }
  if has_key($a, 'b') { warning("has_key pass") } else { warning("has_key FAIL") }
  if !has_key($a, 'd') { warning("has_key pass") } else { warning("has_key FAIL") }
  
  $module = 'test_ppext'
  $modinf = {
    name => $module,
    ensure => installed,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
  ppext::module { $module : modinf => $modinf }     

  $r_bashfile = {
    name => "test_ppext::test",
    resname => 'test',
    modinf => $modinf,
  }
  
  ppext::bashfile { $r_bashfile[name] :
    resinf => $r_bashfile,
    
    command => [ 'echo $1', 'echo $2', 'echo 3', 'echo $CHOCOLATE', 'echo $BRUSSEL_SPROUTS', 'echo $TEST' ],
    cwd => "/home",
    envpath => [ "/root", "/var" ],
    environment => [ "CHOCOLATE=YUM", "BRUSSEL_SPROUTS=YUCK" ],
    namedArgs => true,
    requiredArgs => 'test',
  }
  ~>
  ppext::execbash { "test_ppext::test" :
    modinf => $modinf,
    
    r_bashfile => $r_bashfile,
    
    parameters => [ '--test=arg1', 'arg2'],
    refreshonly => true,
  }

  ppext::exec { "test_ppext::test2" :
    modinf => $modinf,
    
    command => 'echo hello $TEST',
    path => '/etc',
    cwd => '/home',
    environment => 'TEST=1'
  }

  ppext::exec { "test_ppext::testsu" :
    modinf => $modinf,
    
    command => [ 'echo hello from $USER' ],
    path => '/bin',
    user => 'postgres',
  }

  ppext::execonce { "test_ppext::test_execonce" :
    modinf => $modinf,
    
    command => 'echo hello $TEST',
    path => '/etc',
    cwd => '/home',
    environment => 'TEST=1'
  }


  ppext::exec { "test_ppext::TEST_FAIL":
    modinf => $modinf,
    command => 'echo couldn\'t',
  }
}
