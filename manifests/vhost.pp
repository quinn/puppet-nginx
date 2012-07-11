# Define: nginx::server::vhost
#
#   nginx vhost. For serving web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::vhost(
  $port           = '80',
  #$dest,
  $priority       = '10',
  $template       = 'nginx/vhost-default.conf.erb',
  $servername     = '',
  $magic          = '',
  $isdefaultvhost = false
  ) {

  include nginx
  include nginx::server

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  file { "${nginx::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # liberally borrowed from apache module.
  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
    @firewall {
      "0100-INPUT ACCEPT $port":
        jump  => 'ACCEPT',
        dport => "$port",
        proto => 'tcp'
    }
  }

}
# EOF
