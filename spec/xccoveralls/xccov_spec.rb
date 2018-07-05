require 'spec_helper'

# rubocop:disable Metrics/LineLength, Metrics/BlockLength

describe Xccoveralls::Xccov do
  before do
    `touch #{derived_data_path}/Logs/Test/96C6195A-E7C3-4B17-A344-2EFFE95ACCB2.xccovarchive 2> /dev/null`
  end

  let(:options) do
    {
      derived_data_path: derived_data_path,
      source_path: source_path
    }
  end
  let(:derived_data_path) do
    File.join File.dirname(File.dirname(__FILE__)), 'fixtures', 'DerivedData'
  end
  let(:source_path) do
    File.join File.dirname(File.dirname(__FILE__)), 'fixtures', 'Sources'
  end

  let(:instance) { described_class.new(options) }
  subject { instance }

  its(:derived_data_path) do
    is_expected.to match %r{/spec/fixtures/DerivedData$}
  end

  describe('archive_path') do
    subject { instance.archive_path }
    context 'fake is younger' do
      before { `touch #{derived_data_path}/Logs/Test/fake.xccovarchive` }
      it { is_expected.to eq "#{derived_data_path}/Logs/Test/fake.xccovarchive" }
    end
    context 'otherwise' do
      it { is_expected.to eq "#{derived_data_path}/Logs/Test/96C6195A-E7C3-4B17-A344-2EFFE95ACCB2.xccovarchive" }
    end
    context 'when archive not found' do
      let(:derived_data_path) do
        File.dirname(File.dirname(__FILE__))
      end
      it do
        expect { subject }.to raise_error(
          FastlaneCore::Interface::FastlaneError,
          %r{^Could not find any .xccovarchive in (.+)/spec$}
        )
      end
    end
  end

  describe 'files' do
    subject { instance.files }
    it { is_expected.to have(100).items }
  end

  describe 'coverage' do
    subject { instance.coverage(path) }
    let(:path) { '/Users/ngs/src/ci2go/CI2Go/AppDelegate.swift' }
    it { is_expected.to have(74).items }
    context 'when path does not exist' do
      let(:path) { '/Users/ngs/src/ci2go/CI2Go/AppDelegate.mm' }
      it do
        expect { subject }.to raise_error(
          FastlaneCore::Interface::FastlaneError,
          'No coverage data for /Users/ngs/src/ci2go/CI2Go/AppDelegate.mm'
        )
      end
    end
  end
end
# rubocop:enable Metrics/LineLength, Metrics/BlockLength
