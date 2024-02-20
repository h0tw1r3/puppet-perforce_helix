# @summary an instance of a p4d server
#
# @param root
#   directory
# @param instance
#   format as name:port
# @param ssl
#   enable built-in ssl support
# @param auditlog
#   path to audit log
# @param auth
#   port or host:port of centralized auth server
# @param change
#   port or host:port of centralized changelist server
# @param description
#   description to help identify servers
# @param journal
#   path to journal
# @param log
#   name or path to where server errors are written
# @param loginsso
#   client-side single sign-on script
# @param target
#   for replica or edge server, the upstream master or commit server from which it retrieves its data
#
define perforce_helix::p4d::server (
  Stdlib::AbsolutePath $root,
  Pattern[/^([A-z0-9]+):(\d+)$/] $instance = $title,
  Boolean $ssl = false,
  Optional[Stdlib::AbsolutePath] $auditlog = undef,
  Optional[Variant[Stdlib::Port,Pattern[/^\w+:\d+$/]]] $auth = undef,
  Optional[Variant[Stdlib::Port,Pattern[/^\w+:\d+$/]]] $change = undef,
  Optional[String] $description = undef,
  Optional[Stdlib::AbsolutePath] $journal = undef,
  Optional[String] $log = undef,
  Optional[Stdlib::AbsolutePath] $loginsso = undef,
  Optional[Variant[Stdlib::Port,Pattern[/^\w+:\d+$/]]] $target = undef,
) {
  $server = $instance.split(':')
  $conf_file = "/etc/perforce/p4d/${server[0]}.conf"

  $config = {
    'P4AUDIT'       => $auditlog,
    'P4AUTH'        => $auth,
    'P4CHANGE'      => $change,
    'P4DESCRIPTION' => $description,
    'P4JOURNAL'     => $journal,
    'P4LOG'         => $log,
    'P4LOGINSSO'    => $loginsso,
    'P4NAME'        => $server[0], # legacy, remove?
    'P4PORT'        => if $ssl { "ssl:${server[1]}" } else { $server[1] },
    'P4ROOT'        => $root,
    'P4TARGET'      => $target,
    'P4SSLDIR'      => 'ssl',
  }

  file { $root:
    ensure => directory,
    owner  => 'perforce',
    group  => 'perforce',
    mode   => '0750',
  }
  file { "${root}/ssl":
    ensure => directory,
    owner  => 'perforce',
    group  => 'perforce',
    mode   => '0700',
  }
  # replaces P4NAME, TODO: uuid support
  -> file { "${root}/server.id":
    owner   => 'perforce',
    group   => 'perforce',
    content => "${server[0]}\n",
    notify  => "Service[p4d@${server[0]}]",
  }
  -> file { $conf_file:
    content => epp("${module_name}/p4d.conf.epp", { config => $config }),
    notify  => "Service[p4d@${server[0]}]",
  }
  -> exec { "generate-private-key-certificate-${server[0]}":
    path    => '/bin:/usr/bin:/usr/local/bin:/opt/perforce/bin:/opt/perforce/sbin',
    user    => 'perforce',
    command => "bash -c 'source ${conf_file}; export P4ROOT; export P4SSLDIR; p4d -Gc'",
    unless  => ["test -f ${root}/ssl/privatekey.txt", "test -f ${root}/ssl/certificate.txt"],
  }
  ~> service { "p4d@${server[0]}":
    ensure => 'running',
    enable => true,
  }
}
