class torque::client (

) {
  require torque

  package { 'torque-client':
    ensure => installed,
  }

  service { 'pbs_mom':
    ensure    => running,
    enable    => true,
    require   => Package['torque-client'],
  }

  Torque::Config::Server_name <<| tag == $torque::cluster_tag |>> {
    notify => Service['pbs_mom'],
  }

  @@concat::fragment { "torque_node_${::clientcert}":
    target  => "${torque::torque_home}/server_priv/nodes",
    content => "${::fqdn} np=${::processorcount}\n",
    tag     => $torque::cluster_tag,
    order   => $::clientcert,
  }

  # This is here because I don't know how to configure torque
  Host <<| title == 'torque.aws.puppetlabs.demo' and tag == $torque::cluster_tag |>>
}
