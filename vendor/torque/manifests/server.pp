class torque::server (

) {
  require torque
  tag $torque::cluster_tag

  package { 'torque-server':
    ensure => installed,
  }

  @@torque::config::server_name { $::fqdn: }

}
