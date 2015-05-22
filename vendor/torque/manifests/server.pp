class torque::server (

) {
  require torque
  tag $torque::cluster_tag

  package { 'torque-server':
    ensure => installed,
  }

  @@torque::config::server_name { $::fqdn: }

  $nodefile = "${torque::torque_home}/server_priv/nodes"

  concat { $nodefile:
    ensure => present,
  }

  Concat::Fragment <<| tag == $torque::cluster_tag and target == $nodefile |>>

}
