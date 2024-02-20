# frozen_string_literal: true

require 'spec_helper'

describe 'perforce_helix::p4d' do
  let(:params) do
    {
      packages: ['helix-p4d'],
      ensure: 'installed',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # p4d::install

      it { is_expected.to contain_class('perforce_helix::p4d::install') }

      it {
        params[:packages].each { |package| is_expected.to contain_package(package) }
      }

      it {
        is_expected.to contain_file('/etc/perforce/p4d')
          .with(
            ensure: 'directory',
            owner:  0,
            group:  0,
            mode:   '0644',
          )
      }

      it {
        is_expected.to contain_systemd__unit_file('p4d@.service')
          .with_source('puppet:///modules/perforce_helix/p4d@.service')
      }
    end
  end
end
