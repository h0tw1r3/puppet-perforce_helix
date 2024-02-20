# @summary Manage Perforce Helix Core
#
class perforce_helix {
  contain "${name}::p4d"
  contain "${name}::broker"

  Class["${name}::p4d"]
  -> Perforce_helix::P4d::Server <<| |>>
}
