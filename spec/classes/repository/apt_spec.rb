# frozen_string_literal: true

require 'spec_helper'

shared_examples 'apt source' do
  let(:is_key_source) { params[:gpg_key] =~ %r{^(puppet|https?)://} }

  it {
    is_expected.to contain_class('Perforce_helix::Repository::Apt')
      .with(
        gpg_key:     params[:gpg_key],
        location:    params[:location],
        gpg_keyring: params[:gpg_keyring],
      )
  }

  it {
    with = is_key_source ? 'source' : 'content'
    is_expected.to contain_apt__keyring(File.basename(params[:gpg_keyring]))
      .that_comes_before('Apt::Source[perforce]')
      .with("#{with}": params[:gpg_key])
      .with(dir: File.dirname(params[:gpg_keyring]))
  }

  it {
    is_expected.to contain_apt__source('perforce')
      .with(
        location:          params[:location],
        comment:           'Perforce Package Source',
        release:           facts[:os]['distro']['codename'],
        repos:             'release',
        architecture:      facts[:os]['architecture'],
        keyring:           params[:gpg_keyring],
      )
  }
end

describe 'perforce_helix::repository::apt' do
  let(:params) do
    {
      gpg_key:     'https://package.perforce.com/perforce.pubkey',
      location:    'https://package.perforce.com/apt/ubuntu/dists',
      gpg_keyring: '/etc/apt/keyring/perforce.asc',
    }
  end

  on_supported_os.each do |os, os_facts|
    next unless os_facts[:os]['family'].eql?('Debian')

    context "on #{os}" do
      let(:facts) { os_facts }

      context 'https keyring' do
        include_examples 'apt source'
      end

      context 'content keyring' do
        let(:params) { super().merge({ gpg_key: 'a gpg key could be here' }) }

        include_examples 'apt source'
      end

      context 'puppet source keyring' do
        let(:params) { super().merge({ gpg_key: 'puppet:///module/blah/blah/blah.asc' }) }

        include_examples 'apt source'
      end
    end
  end
end
