class torque::client (

) {
  require torque

  package { 'torque-client':
    ensure => installed,
  }

  Torque::Config::Server_name <<| tag == $torque::cluster_tag |>>
}
