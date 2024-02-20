# @summary manage perforce package repository
#
# @param ensure
#
class perforce_helix::repository (
  Enum['present', 'absent', 'unmanaged'] $ensure = 'present',
) {
  if $ensure != 'unmanaged' {
    unless $facts.get('os.architecture') in ['x86_64', 'amd64', 'i386'] {
      fail("Unsupported architecture ${facts.get('os.architecture')}")
    }

    case "${facts.get('os.family')}-${facts.get('os.name')}" {
      /-Ubuntu$/: {
        $provider = 'apt'
      }
      /^RedHat-/: {
        $provider = 'yum'
      }
      default: {
        fail("Unsupported os: ${facts.get('os.name')}")
      }
    }

    class { "${name}::${provider}":
      ensure => $ensure,
    }
  }
}
