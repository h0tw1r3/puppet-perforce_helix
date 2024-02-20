# @summary install helix client
#
# @api private
#
class perforce_helix::p4::install {
  package { $perforce_helix::p4::packages:
    ensure => $perforce_helix::p4::ensure,
  }
}
