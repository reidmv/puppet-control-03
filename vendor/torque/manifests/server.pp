class torque::server (

) {
  require torque
  tag $torque::cluster_tag

  package { 'torque-server':
    ensure => installed,
  }

  file { '/var/spool/torque/checkpoint':
    ensure => directory,
  }

  exec { 'create pbs_server database':
    command     => '/usr/share/doc/torque-server-5.1.0/torque.setup root',
    refreshonly => true,
    subscribe   => Package['torque-server'],
    before      => Service['pbs_server'],
  }

  service { 'pbs_server':
    ensure  => running,
    enable  => true,
    require => [
      Package['torque-server'],
      Host['torque.aws.puppetlabs.demo'],
    ],
  }

  @@torque::config::server_name { $::fqdn: }
  Torque::Config::Server_name <<| title == $::fqdn |>>

  # This is just here because I didn't know how to configure torque
  @@host { 'torque.aws.puppetlabs.demo': ip => $::ipaddress }
  Host <<| title == 'torque.aws.puppetlabs.demo' and tag == $torque::cluster_tag |>>

  $nodefile = "${torque::torque_home}/server_priv/nodes"

  concat { $nodefile:
    ensure => present,
    notify => Service['pbs_server'],
  }

  Concat::Fragment <<| tag == $torque::cluster_tag and target == $nodefile |>>

}
