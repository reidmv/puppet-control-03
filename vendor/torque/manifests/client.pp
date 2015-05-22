class torque::client (

) {
  require torque

  package { 'torque-client':
    ensure => installed,
  }

  Torque::Config::Server_name <<| tag == $torque::cluster_tag |>>

  @@concat::fragment { "torque_node_${::clientcert}":
    target  => "${torque::torque_home}/server_priv/nodes",
    content => "${::fqdn}\n",
    tag     => $torque::cluster_tag,
  }

}
