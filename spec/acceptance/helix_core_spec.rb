# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'helix_core' do
  context 'with default parameters' do
    let(:pp) do
      <<-MANIFEST
      include helix_core
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end
