# @summary install perforce apt source
#
# @param gpg_key
# @param location
# @param gpg_keyring
class helix_core::repository::apt (
  String $gpg_key,
  String $location    = 'https://package.perforce.com/apt/ubuntu',
  String $gpg_keyring = '/etc/apt/keyrings/perforce.asc',
) {
  case $gpg_key {
    /^(puppet|https?):\/\//: { $key_source = $gpg_key }
    default:                 { $key_content = $gpg_key }
  }

  apt::keyring { basename($gpg_keyring):
    dir     => dirname($gpg_keyring),
    content => getvar('key_content'),
    source  => getvar('key_source'),
  }
  -> apt::source { 'perforce':
    location     => $location,
    comment      => 'Perforce Package Source',
    release      => $facts.get('os.distro.codename'),
    architecture => $facts.get('os.architecture'),
    keyring      => $gpg_keyring,
  }
}
