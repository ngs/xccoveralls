# `$ xccoveralls`

[![Gem Version](https://badge.fury.io/rb/xccoveralls.png)][gem]
[![CircleCI](https://circleci.com/gh/ngs/xccoveralls.svg?style=svg)](https://circleci.com/gh/ngs/xccoveralls)
[![Coverage Status](https://coveralls.io/repos/github/ngs/xccoveralls/badge.svg)](https://coveralls.io/github/ngs/xccoveralls)

Command line tool for sending Xcode 9.3+ coverage information to [Coveralls]

## Installation

```sh
$ [sudo] gem install xccoveralls
```

## Command

```sh
$ xccoveralls report
```

## Options

| Name                        | Description                 | Env Name                        | Default                                 | Required |
| --------------------------- | --------------------------- | ------------------------------- | --------------------------------------- | :------: |
| `-s`, `--source_path`       | Path to project root        | `XCCOVERALLS_SOURCE_PATH`       | Top level of Git repository             |          |
| `-d`, `--derived_data_path` | Path to DerivedDat          | `XCCOVERALLS_DERIVED_DATA_PATH` | `~/Library/Developer/Xcode/DerivedData` |          |
| `-i`, `--ignorefile_path`   | Path to Ignorefile          | `XCCOVERALLS_IGNOREFILE_PATH`   | `(source_path)/.coverallsignore`        |          |
| `-T`, `--repo_token`        | Coveralls secret repo token | `XCCOVERALLS_REPO_TOKEN`        |                                         |    *     |


## License

Copyright &copy; 2018 [Atsushi Nagase]. MIT Licensed, see [LICENSE] for details.

[Coveralls]: https://coveralls.io/
[gem]: https://rubygems.org/gems/xccoveralls
[LICENSE]: LICENSE
[Atsushi Nagase]: https://ngs.io
