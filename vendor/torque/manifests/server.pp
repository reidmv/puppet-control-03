class torque::server (

) {
  require torque
  tag $torque::cluster_tag

  package { 'torque-server':
    ensure => installed,
  }

  service { 'pbs_server':
    ensure  => running,
    enable  => true,
    require => Package['torque-server'],
  }

  @@torque::config::server_name { $::fqdn: }

  $nodefile = "${torque::torque_home}/server_priv/nodes"

  concat { $nodefile:
    ensure => present,
    notify => Service['pbs_server'],
  }

  Concat::Fragment <<| tag == $torque::cluster_tag and target == $nodefile |>>

}
