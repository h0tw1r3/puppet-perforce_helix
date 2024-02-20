# @summary install helix broker
#
# @api private
#
class perforce_helix::broker::install {
  package { $perforce_helix::broker::packages:
    ensure => $perforce_helix::broker::ensure,
  }
}
