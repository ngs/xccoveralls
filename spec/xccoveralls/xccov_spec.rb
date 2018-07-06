require 'spec_helper'

# rubocop:disable Metrics/LineLength, Metrics/BlockLength

describe Xccoveralls::Xccov do
  before do
    `touch #{derived_data_path}/Logs/Test/main.xccovarchive 2> /dev/null`
  end

  let(:options) do
    {
      derived_data_path: derived_data_path,
      source_path: source_path,
      ignorefile_path: ignorefile_path
    }
  end
  let(:derived_data_path) do
    File.join File.dirname(File.dirname(__FILE__)), 'fixtures', 'DerivedData'
  end
  let(:source_path) do
    File.join File.dirname(File.dirname(__FILE__)), 'fixtures', 'Sources'
  end
  let(:ignorefile_path) do
    File.join File.dirname(File.dirname(__FILE__)), 'fixtures', 'Sources', 'coverallsignore'
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
      it { is_expected.to eq "#{derived_data_path}/Logs/Test/main.xccovarchive" }
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

  describe 'file_paths' do
    subject { instance.file_paths }
    it do
      is_expected.to eq [
        '/Users/ngs/src/ci2go/CI2Go/Data/Build.swift',
        '/Users/ngs/src/ci2go/CI2Go/Data/Project.swift'
      ]
    end
  end

  describe 'coverage' do
    subject { instance.coverage(path) }
    let(:path) { '/Users/ngs/src/ci2go/CI2Go/Data/Project.swift' }
    it do
      is_expected.to eq [
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, 95, 95, 95, 95, 95, 95, nil, nil, 95, 95, nil, nil,
        95, 95, nil, nil, 95, 95, nil, nil, 95, nil, 4, 4, 4, 4, 4, 4, 4,
        nil, 30, 30, 30, 30, 30, 30, 30, 30, 30, nil, 2, 2, 2, 2, 2, 2, 2,
        nil, nil, 0, 2, nil, nil, 2, 2, nil, 79, 79, 79, nil, 79, 79, 79,
        nil, 0, 0, 0, nil, nil, nil, 4, 4, 4
      ]
    end
    context 'when path does not exist' do
      let(:path) { '/Users/ngs/src/ci2go/Vendor/ANSIEscapeHelper/AMR_ANSIEscapeHelper.m' }
      it do
        expect { subject }.to raise_error(
          FastlaneCore::Interface::FastlaneError,
          'No coverage data for /Users/ngs/src/ci2go/Vendor/ANSIEscapeHelper/AMR_ANSIEscapeHelper.m'
        )
      end
    end
  end
end
# rubocop:enable Metrics/LineLength, Metrics/BlockLength
