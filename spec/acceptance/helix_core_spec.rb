# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'perforce_helix' do
  context 'with default parameters' do
    let(:pp) do
      <<-MANIFEST
      include perforce_helix

      perforce_helix::p4d::server { 'default:1234':
        root => '/srv/p4d_default',
        ssl  => true,
      }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service('p4d@default'), :status do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(1234), :status do
      it { is_expected.to be_listening.on('0.0.0.0').with('tcp') }
    end
  end
end
