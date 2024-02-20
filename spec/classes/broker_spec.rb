# frozen_string_literal: true

require 'spec_helper'

describe 'perforce_helix::broker' do
  let(:params) do
    {
      packages: ['helix-broker'],
      ensure: 'installed',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # broker::install

      it { is_expected.to contain_class('perforce_helix::broker::install') }

      it {
        params[:packages].each { |package| is_expected.to contain_package(package) }
      }
    end
  end
end
