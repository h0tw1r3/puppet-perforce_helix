# @summary install perforce yum repository
#
# @param ensure
# @param gpg_key
# @param gpg_keyring
# @param baseurl
#
class perforce_helix::repository::yum (
  String $gpg_key,
  Enum['present', 'absent'] $ensure = 'present',
  String $gpg_keyring               = '/etc/pki/rpm-gpg/RPM-GPG-KEY-perforce',
  String $baseurl                   = "https://package.perforce.com/yum/rhel/${facts.get('os.release.major').downcase}/${facts.get('os.architecture')}",
) {
  case $gpg_key {
    /^https?:\/\//: {
      $yum_gpg_key = $gpg_key
    }
    default: {
      $yum_gpg_key = "file:/${gpg_keyring}"

      case $gpg_key {
        /^(file|puppet):\/\//: { $gpg_source = $gpg_key }
        default:               { $gpg_content = $gpg_key }
      }

      file { $yum_gpg_key[6,-1]:
        ensure  => stdlib::ensure($ensure, 'file'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => getvar('gpg_source'),
        content => getvar('gpg_content'),
        before  => Yumrepo['perforce'],
      }
    }
  }

  yumrepo { 'perforce':
    ensure   => $ensure,
    descr    => 'Perforce Repository',
    baseurl  => $baseurl,
    gpgkey   => $yum_gpg_key,
    gpgcheck => true,
    enabled  => true,
  }
}
