class openssh {

  service { 'sshd':
    ensure => running,
    enable => true,
  }

}
