# frozen_string_literal: true

require 'spec_helper'
require 'deep_merge'

describe 'perforce_helix::repository' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it {
        which = (facts[:os]['family'] == 'RedHat') ? 'to' : 'not_to'
        is_expected.method(which).call contain_class('perforce_helix::repository::yum')
      }
      it {
        which = (facts[:os]['family'] == 'Debian') ? 'to' : 'not_to'
        is_expected.method(which).call contain_class('perforce_helix::repository::apt')
      }
    end
  end

  on_supported_os.take(1).each do |_, os_facts|
    os_facts.deep_merge!({ os: { 'architecture' => 'aarch64' } })

    context "on #{os_facts[:os]['name']}-#{os_facts[:os]['architecture']}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.and_raise_error(%r{Unsupported architecture}) }
    end
  end

  unsupported_os = {
    supported_os: [
      {
        'operatingsystem' => 'Debian',
        'operatingsystemrelease' => '11',
      },
    ]
  }
  on_supported_os(unsupported_os).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.and_raise_error(%r{Unsupported os}) }
    end
  end
end
