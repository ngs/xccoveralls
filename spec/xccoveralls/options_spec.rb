require 'spec_helper'

# rubocop:disable Metrics/LineLength

shared_examples_for 'validates directory' do
  it do
    expect { subject.verify!('/foo') }
      .to raise_error(
        FastlaneCore::Interface::FastlaneError,
        'Source path /foo does not exist'
      )
  end
  it do
    expect { subject.verify!(__FILE__) }
      .to raise_error(
        FastlaneCore::Interface::FastlaneError,
        %r{^Source path /.+/spec/xccoveralls/options_spec\.rb is not a directory$}
      )
  end
end

shared_examples_for 'validates default value' do |value|
  its(:default_value) { is_expected.to match value }
end

describe Xccoveralls::Options do
  let(:available_options) { described_class.available_options }
  let(:option) { available_options.find { |item| item.key == key } }
  describe 'available_options' do
    subject { available_options }
    it { is_expected.to have(2).items }
  end

  describe 'source_path' do
    let(:key) { :source_path }
    subject { option }
    it_behaves_like(
      'validates default value',
      File.dirname(File.dirname(File.dirname(__FILE__)))
    )
    it_behaves_like 'validates directory'
  end

  describe 'derived_data_path' do
    let(:key) { :derived_data_path }
    subject { option }
    it_behaves_like(
      'validates default value',
      %r{/Users/([^/]+)/Library/Developer/Xcode/DerivedData$}
    )
    it_behaves_like 'validates directory'

    # it { require 'pry'; binding.pry }
  end
end
# rubocop:enable Metrics/LineLength
