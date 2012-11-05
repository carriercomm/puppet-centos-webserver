node default {
  include bash, ppdb, ppext

  class { 'lampstack' :
    password => 'password',
    versions => {
      apache => '2.2.15*',
      mysql => '5.1*',
      php => {
        php => '5.3.3*',
        mcrypt => '5.3.3*',

        #The following modules are virtual resources that can be "realized" later.
        # If they are never realized they are never installed.
        dba => '5.3.3*',
        mysql => '5.3.3*',
        pgsql => '5.3.3*',
        pear => '1.9*',
        pecl_apc => '3.1*',
        pecl_memcache => '3.0*',
      },
      perl => {
        perl => '5.10*',
        mod_perl => '*',
      },
    },
    ensure => latest,
  }                                          
  
  class { 'postgresql' :
    ensure => latest,
    version => '8.4*',
    rootUserPassword => 'password',
  }

  ppdb::connect_root { 'postgresql': ensure => installed }
  
  phppgadmin { 'test' :
    version => '5.0.3',
    ensure => absent,
    destpath => '/var/www/html/test/phppgadmin',
    testURL => 'http://localhost/test/phppgadmin/',
  }
  
}
