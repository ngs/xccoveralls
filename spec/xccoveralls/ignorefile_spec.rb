require 'spec_helper'

describe Xccoveralls::Ignorefile do
  let(:instance) { described_class.new arg }
  let(:arg) do
    %w[
      *.m
      AppDelegate.swift
      !*ViewController.swift
    ]
  end
  let(:files) do
    %w[
      /Users/ngs/foo/Hoge.m
      /Users/ngs/foo/AppDelegate.swift
      /Users/ngs/foo/FooViewController.swift
      /Users/ngs/foo/BarViewController.swift
      /Users/ngs/foo/Baz.swift
    ]
  end
  subject { instance.apply(files) }
  it do
    is_expected.to eq %w[
      /Users/ngs/foo/FooViewController.swift
      /Users/ngs/foo/BarViewController.swift
      /Users/ngs/foo/Baz.swift
    ]
  end
end
