# frozen_string_literal: true

require 'spec_helper'
require 'deep_merge'

describe 'helix_core' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('helix_core::repository') }
    end
  end
end
