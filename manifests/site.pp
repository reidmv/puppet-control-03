file { '/var/puppet_environment.txt':
  ensure  => file,
  content => $::environment,
}

if $::classes { include $::classes }
