define apache::directory(
  $r_directory,
  /*
    ensure => installed
    path => 'PATH',
    options => '-Indexes FollowSymLinks'
    allowOverride => 'none',
    order => 'allow,deny',
    allowFrom => 'all' 
  */
  $r_vhost = undef
  /*
    ...
    confpath # Where to store this conf file
    ...
  */
) {

  include apache::params

  $ensure = $r_directory[ensure]

  # START PATTERN file_defaults
  $dirEnsure = $ensure ? { default => directory, absent => absent }
  $fileEnsure = $ensure ? { default => present, absent => absent }

  File {
    force => true,
    ensure => $fileEnsure,
    owner => root,
    group => root,
    mode => 644,
  }
  #END PATTERN

  $conftype = 'directory'

  $dirPath = $r_directory[path]
  $dirOptions = $r_directory[options]
  $dirAllowOverride = $r_directory[allowOverride]
  $dirOrder = $r_directory[order]
  $dirAllowFrom = $r_directory[allowFrom]
  
  #START PATTERN apache_conffile
  if $r_vhost {
    $vhost_confpath = $r_vhost[confpath]
    $conffile = "$vhost_confpath/$name.$conftype.conf"
    File[$vhost_confpath] -> File[$conffile]
  } else {
    $conffile = "$apache::params::conf_d_path/$name.$conftype.conf"
  }

  file { $conffile:
   content => template("apache/$conftype.conf.erb"),
  }
  if $ensure != absent {
    Class['apache::config_files'] -> File[$conffile] ~> Class['apache::init_service']
  } else {
    #TODO: puppet bug below see vhost.pp
    #Class['apache::config_files'] <- File[$conffile]
    File[$conffile] ~> Class['apache::init_service']
  }
  #END PATTERN
}