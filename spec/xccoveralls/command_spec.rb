require 'spec_helper'

describe Xccoveralls::Command do # rubocop:disable Metrics/BlockLength
  before(:each) do
    allow(FastlaneCore::UpdateChecker).to receive(:start_looking_for_update)
    allow(FastlaneCore::UpdateChecker).to receive(:show_update_status)
    allow(Xccoveralls::Runner).to receive(:new) { |options|
      fake_runner[:options] = options
    }.and_return fake_runner
    allow(Commander::Runner).to receive(:instance)
      .and_return fake_commander_runner
  end

  after(:each) do
    FastlaneCore::Globals.verbose = false
  end

  let(:args) do
    %W[
      -T foo
      -d #{File.expand_path('../fixtures/DerivedData', __dir__)}
      -s #{File.expand_path('../fixtures/Sources', __dir__)}
      --verbose
    ]
  end

  let(:fake_commander_runner) do
    Commander::Runner.new(args)
  end

  let(:fake_runner) do
    r = {}
    allow(r).to receive(:run!)
    r
  end

  describe 'options' do
    subject do
      described_class.run!
      fake_runner
    end

    it { is_expected.to have_received(:run!) }

    its(%i[options source_path]) do
      is_expected.to match %r{/spec/fixtures/Sources$}
    end

    its(%i[options derived_data_path]) do
      is_expected.to match %r{/spec/fixtures/DerivedData$}
    end

    its(%i[options repo_token]) do
      is_expected.to eq 'foo'
    end
  end
end
