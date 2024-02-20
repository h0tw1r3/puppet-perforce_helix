# @summary install helix p4d
#
# @api private
#
class perforce_helix::p4d::install {
  package { $perforce_helix::p4d::packages:
    ensure => $perforce_helix::p4d::ensure,
  }

  -> file { '/etc/perforce/p4d':
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  -> systemd::unit_file { 'p4d@.service':
    source => "puppet:///modules/${module_name}/p4d@.service",
  }
}
