# @summary manage perforce package repository
#
class helix_core::repository {
  unless $facts.get('os.architecture') in ['x86_64', 'amd64', 'i386'] {
    fail("Unsupported architecture ${facts.get('os.architecture')}")
  }

  case "${facts.get('os.family')}-${facts.get('os.name')}" {
    /-Ubuntu$/: {
      contain "${name}::apt"
    }
    /^RedHat-/: {
      contain "${name}::yum"
    }
    default: {
      fail("Unsupported os: ${facts.get('os.name')}")
    }
  }
}
