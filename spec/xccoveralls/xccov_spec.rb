require 'spec_helper'

# rubocop:disable Metrics/LineLength, Metrics/BlockLength

describe Xccoveralls::Xccov do
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
      before { `touch #{derived_data_path}/Logs/Test/main.xccovarchive` }
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

  describe 'source_digest' do
    before do
      allow(instance).to receive(:file_paths).and_return [
        "#{source_path}/Data/Build.swift",
        "#{source_path}/Data/Project.swift",
        "#{source_path}/View Controllers/BuildsViewController.swift"
      ]
    end
    subject { instance.source_digest path }
    let(:path) { "#{source_path}/View Controllers/BuildsViewController.swift" }
    it { is_expected.to eq '12978beca5d66aa364d2d8469b86eb1105206dcd' }
    context 'when path does not exist' do
      let(:path) { "#{source_path}/View Controllers/NothingViewController.swift" }
      it do
        expect { subject }.to raise_error(
          FastlaneCore::Interface::FastlaneError,
          "File at #{path} does not exist"
        )
      end
    end
  end

  describe 'name' do
    before do
      allow(instance).to receive(:file_paths).and_return [
        "#{source_path}/Data/Build.swift",
        "#{source_path}/Data/Project.swift",
        "#{source_path}/View Controllers/BuildsViewController.swift"
      ]
    end
    subject { instance.name path }
    let(:path) { "#{source_path}/View Controllers/BuildsViewController.swift" }
    it { is_expected.to eq 'View Controllers/BuildsViewController.swift' }
    context 'when path is outside of source path' do
      let(:path) { '/etc/hosts' }
      it { is_expected.to eq '/etc/hosts' }
    end
  end

  describe 'to_json' do
    before do
      allow(instance).to receive(:file_paths).and_return [
        "#{source_path}/Data/Build.swift",
        "#{source_path}/Data/Project.swift",
        "#{source_path}/View Controllers/BuildsViewController.swift"
      ]
      allow(instance).to receive(:coverage).and_return [
        nil, 2, nil, 0
      ]
    end
    subject { instance.to_json }
    it do
      is_expected.to eq(
        source_files: [
          {
            name: 'Data/Build.swift',
            source_digest: 'fc933b483f4a7deaab58a72f899278f4295b5b3f',
            coverage: [nil, 2, nil, 0]
          },
          {
            name: 'Data/Project.swift',
            source_digest: '28262ad52976daf0690133ff404f32c22a6ee451',
            coverage: [nil, 2, nil, 0]
          },
          {
            name: 'View Controllers/BuildsViewController.swift',
            source_digest: '12978beca5d66aa364d2d8469b86eb1105206dcd',
            coverage: [nil, 2, nil, 0]
          }
        ]
      )
    end
  end
end
# rubocop:enable Metrics/LineLength, Metrics/BlockLength
