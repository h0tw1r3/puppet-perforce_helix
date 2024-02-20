# Perforce Helix

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Limitations](#limitations)

## Description

Deploy [Perforce Helix Core](https://www.perforce.com/products/helix-core)
components.

## Setup

```pp
include 'perforce_helix'
```

### Create a p4d server

```pp
file { '/srv/perforce':
    ensure => directory,
}

perforce_helix::p4d::server { 'default:1234':
    root => '/srv/perforce/default',
    ssl  => true,
}
```

## Limitations

Vendor provides packages for Ubuntu and EL based Linux distributions.
