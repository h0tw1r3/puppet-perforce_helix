# @summary install perforce apt source
#
# @param ensure
# @param location
# @param gpg_key
# @param gpg_keyring
#
class perforce_helix::repository::apt (
  String $gpg_key,
  Enum['present', 'absent'] $ensure = 'present',
  String $gpg_keyring               = '/etc/apt/keyrings/perforce.asc',
  String $location                  = 'https://package.perforce.com/apt/ubuntu',
) {
  case $gpg_key {
    /^(puppet|https?):\/\//: { $key_source = $gpg_key }
    default:                 { $key_content = $gpg_key }
  }

  apt::keyring { basename($gpg_keyring):
    ensure  => $ensure,
    dir     => dirname($gpg_keyring),
    content => getvar('key_content'),
    source  => getvar('key_source'),
  }
  -> apt::source { 'perforce':
    ensure       => $ensure,
    location     => $location,
    comment      => 'Perforce Package Source',
    release      => $facts.get('os.distro.codename'),
    repos        => 'release',
    architecture => $facts.get('os.architecture'),
    keyring      => $gpg_keyring,
  }
}
