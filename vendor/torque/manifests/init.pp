class torque (
  String $cluster_name = $::torque_cluster,
  $manage_known_hosts  = true,
  $torque_home         = '/var/spool/torque',
) {
  include openssh

  $cluster_tag = "torque_${cluster_name}"
  tag $cluster_tag

  yumrepo { 'torque':
    ensure   => present,
    name     => 'puppet_labs_demo_torque',
    enabled  => true,
    baseurl  => 'https://s3-us-west-2.amazonaws.com/tseteam/repos/torque',
    gpgcheck => 0,
  }
  
  # Ensure known_hosts is populated for each node in the cluster
  @@sshkey { $::clientcert:
    ensure       => present,
    key          => $::sshrsakey,
    type         => 'rsa',
    host_aliases => [
      $::ipaddress,
      $::ipaddress_eth1,
      $::hostname,
      $::fqdn,
    ],
  }

  Sshkey <<| tag == "torque_${cluster_name}" |>>

  # Configure host-based trust relationships for each node in the cluster
  concat { '/etc/hosts.equiv':
    ensure => present,
  }

  @@concat::fragment { "torque_${::clientcert}_equiv":
    target  => '/etc/hosts.equiv',
    content => "${::fqdn}\n",
  }

  Concat::Fragment <<| tag == "torque_${cluster_name}" |>>

  Ssh_config {
    ensure => present,
  }
  ssh_config { "HostbasedAuthentication global":
    key    => "HostbasedAuthentication",
    value  => "yes",
  }
  ssh_config { "EnableSSHKeysign global":
    key    => "EnableSSHKeysign",
    value  => "yes",
  }

  Sshd_config {
    ensure => present,
    notify => Class['openssh'],
  }
  sshd_config { "HostbasedAuthentication global":
    key    => "HostbasedAuthentication",
    value  => "yes",
  }
  sshd_config { "IgnoreRhosts global":
    key    => "IgnoreRhosts",
    value  => "yes",
  }
  sshd_config { "IgnoreUserKnownHosts global":
    key    => "IgnoreUserKnownHosts",
    value  => "yes",
  }
  sshd_config { 'HostbasedUsesNameFromPacketOnly global':
    key    => "HostbasedUsesNameFromPacketOnly",
    value  => "yes",
  }
  sshd_config { 'PermitRootLogin global':
    key    => "PermitRootLogin",
    value  => "yes",
  }

}
