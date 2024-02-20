# @summary manage helix client
#
# @param packages
#   set empty array to disable package management
# @param ensure
#   value of package ensure parameter
#
class perforce_helix::p4 (
  Variant[Array,Array[String]] $packages,
  Variant[Enum['installed', 'absent', 'latest']] $ensure,
) {
  if $packages {
    include perforce_helix::repository

    Class['perforce_helix::repository']
    -> Package[$packages]

    contain "${name}::install"
  }
}
