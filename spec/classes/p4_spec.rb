# frozen_string_literal: true

require 'spec_helper'

describe 'perforce_helix::p4' do
  let(:params) do
    {
      packages: ['helix-cli'],
      ensure: 'installed',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # p4::install

      it { is_expected.to contain_class('perforce_helix::p4::install') }

      it {
        params[:packages].each { |package| is_expected.to contain_package(package) }
      }
    end
  end
end
