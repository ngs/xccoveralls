require 'spec_helper'

# rubocop:disable Metrics/LineLength

shared_examples_for 'validates directory' do
  subject do
    allow(FastlaneCore::UI).to receive(:user_error!)
    option.verify!(path)
    FastlaneCore::UI
  end

  context 'path does not exist' do
    let(:path) { '/foo' }
    it do
      is_expected.to have_received(:user_error!).with(
        'Source path /foo does not exist'
      )
    end
  end

  context 'path is a file' do
    let(:path) { __FILE__ }
    it do
      is_expected.to have_received(:user_error!).with(
        %r{^Source path /.+/spec/xccoveralls/options_spec\.rb is not a directory$}
      )
    end
  end

  context 'path is a directory' do
    let(:path) { '/Library' }
    it { is_expected.not_to have_received(:user_error!) }
  end
end

shared_examples_for 'validates file' do
  subject do
    allow(FastlaneCore::UI).to receive(:user_error!)
    option.verify!(path)
    FastlaneCore::UI
  end

  context 'path does not exist' do
    let(:path) { '/foo' }
    it do
      is_expected.to have_received(:user_error!).with(
        'Ignorefile does not exist at /foo'
      )
    end
  end

  context 'path is a directory' do
    let(:path) { '/Library' }
    it do
      is_expected.to have_received(:user_error!).with(
        '/Library is not a file'
      )
    end
  end

  context 'path is a file' do
    let(:path) { __FILE__ }
    it { is_expected.not_to have_received(:user_error!) }
  end
end

shared_examples_for 'validates default value' do |value|
  its(:default_value) { is_expected.to match value }
end

describe Xccoveralls::Options do # rubocop:disable Metrics/BlockLength
  let(:available_options) { described_class.available_options }
  let(:option) { available_options.find { |item| item.key == key } }
  subject { option }

  describe 'available_options' do
    subject { available_options }
    it { is_expected.to have(4).items }
  end

  describe 'source_path' do
    let(:key) { :source_path }
    it_behaves_like(
      'validates default value',
      File.dirname(File.dirname(File.dirname(__FILE__)))
    )
    it_behaves_like 'validates directory'
  end

  describe 'derived_data_path' do
    let(:key) { :derived_data_path }
    it_behaves_like(
      'validates default value',
      %r{/Users/([^/]+)/Library/Developer/Xcode/DerivedData$}
    )
    it_behaves_like 'validates directory'
  end

  describe 'ignorefile_path' do
    let(:key) { :ignorefile_path }
    its(:default_value) { is_expected.to be_nil }
    it_behaves_like 'validates file'
  end
end
# rubocop:enable Metrics/LineLength
