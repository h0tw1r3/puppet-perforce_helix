# frozen_string_literal: true

require 'spec_helper'

shared_examples 'yum repository' do
  let(:file_keyring) { params[:gpg_key] !~ %r{^https?://} }
  let(:is_key_source) { params[:gpg_key] =~ %r{^(file|puppet)://} }

  it {
    is_expected.to contain_class('Perforce_helix::Repository::Yum')
      .with(
        gpg_key:     params[:gpg_key],
        baseurl:     params[:baseurl],
        gpg_keyring: params[:gpg_keyring],
      )
  }

  it {
    which = file_keyring ? 'to' : 'not_to'
    what = is_key_source ? 'source' : 'content'
    is_expected.method(which).call contain_file(params[:gpg_keyring])
      .that_comes_before('Yumrepo[perforce]')
      .with(
        owner:     'root',
        group:     'root',
        mode:      '0644',
        "#{what}": params[:gpg_key],
      )
  }

  it {
    gpg_key = file_keyring ? "file:/#{params[:gpg_keyring]}" : params[:gpg_key]

    is_expected.to contain_yumrepo('perforce')
      .with(
        descr:    'Perforce Repository',
        baseurl:  params[:baseurl],
        gpgkey:   gpg_key,
        gpgcheck: true,
        enabled:  true,
      )
  }
end

describe 'perforce_helix::repository::yum' do
  let(:params) do
    {
      baseurl:     "https://package.perforce.com/yum/rhel/#{facts[:os]['release']['major'].downcase}/#{facts[:os][:architecture]}",
      gpg_keyring: '/etc/pki/rpm-gpg/RPM-GPG-KEY-perforce',
      gpg_key:     'https://package.perforce.com/perforce.pubkey',
    }
  end

  on_supported_os.each do |os, os_facts|
    next unless os_facts[:os]['family'].eql?('RedHat')

    context "on #{os}" do
      let(:facts) { os_facts }

      context 'https keyring' do
        include_examples 'yum repository'
      end

      context 'content keyring' do
        let(:params) { super().merge({ gpg_key: 'a gpg key could be here' }) }

        include_examples 'yum repository'
      end

      context 'puppet source keyring' do
        let(:params) { super().merge({ gpg_key: 'puppet:///module/blah/blah/blah.asc' }) }

        include_examples 'yum repository'
      end
    end
  end
end
