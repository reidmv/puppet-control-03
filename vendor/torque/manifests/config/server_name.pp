define torque::config::server_name () {
  include torque

  file { "${torque::torque_home}/server_name":
    ensure  => file,
    content => "${name}\n",
  }

}
