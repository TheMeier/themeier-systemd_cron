<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.0.0](https://github.com/TheMeier/themeier-systemd_cron/tree/v2.0.0) - 2024-02-24

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v1.0.1...v2.0.0)

### Changed
- replace templating with system::manage_unit [#34](https://github.com/TheMeier/themeier-systemd_cron/pull/34) ([TheMeier](https://github.com/TheMeier))
- Add Debian 12, drop Debian 9/CentOS/RedHat/Rocky [#33](https://github.com/TheMeier/themeier-systemd_cron/pull/33)([TheMeier](https://github.com/TheMeier))

## [v1.0.1](https://github.com/TheMeier/themeier-systemd_cron/tree/v1.0.1) - 2023-09-09

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v1.0.0...v1.0.1)

### Fixed

- fix: disable acceptance tests for some targets [#24](https://github.com/TheMeier/themeier-systemd_cron/pull/24) ([TheMeier](https://github.com/TheMeier))

## [v1.0.0](https://github.com/TheMeier/themeier-systemd_cron/tree/v1.0.0) - 2021-12-04

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.7...v1.0.0)

## [v0.2.7](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.7) - 2021-12-04

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.6...v0.2.7)

### Other

- Issue/20 [#21](https://github.com/TheMeier/themeier-systemd_cron/pull/21) ([TheMeier](https://github.com/TheMeier))

## [v0.2.6](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.6) - 2021-09-13

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.5...v0.2.6)

### Other

- Make Service Type variable [#19](https://github.com/TheMeier/themeier-systemd_cron/pull/19) ([joe-ERhz5pn0](https://github.com/joe-ERhz5pn0))

## [v0.2.5](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.5) - 2021-01-13

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.4...v0.2.5)

### Other

- use spec tests for mock (avoids warning in spec tests) [#18](https://github.com/TheMeier/themeier-systemd_cron/pull/18) ([trefzer](https://github.com/trefzer))
- allow / in title by substitute with _ [#17](https://github.com/TheMeier/themeier-systemd_cron/pull/17) ([trefzer](https://github.com/trefzer))

## [v0.2.4](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.4) - 2020-12-31

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.3...v0.2.4)

### Other

- Maintenance [#15](https://github.com/TheMeier/themeier-systemd_cron/pull/15) ([TheMeier](https://github.com/TheMeier))

## [v0.2.3](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.3) - 2020-07-02

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.2...v0.2.3)

### Other

- allow Integer or String for on_boot_sec and on_unitactive_sec [#14](https://github.com/TheMeier/themeier-systemd_cron/pull/14) ([TheMeier](https://github.com/TheMeier))
- add tests for OnBootSec and OnUnitActiveSec [#13](https://github.com/TheMeier/themeier-systemd_cron/pull/13) ([TheMeier](https://github.com/TheMeier))
- add posibility to add monotonic timers [#12](https://github.com/TheMeier/themeier-systemd_cron/pull/12) ([trefzer](https://github.com/trefzer))
- update pdk and switch from beaker to litmus [#11](https://github.com/TheMeier/themeier-systemd_cron/pull/11) ([TheMeier](https://github.com/TheMeier))

## [v0.2.2](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.2) - 2019-03-19

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.2.0...v0.2.2)

## [v0.2.0](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.2.0) - 2019-01-26

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.6...v0.2.0)

### Added

- reverse resource order if ensure is absent or false [#9](https://github.com/TheMeier/themeier-systemd_cron/pull/9) ([TheMeier](https://github.com/TheMeier))
- switch to pdk with default template [#7](https://github.com/TheMeier/themeier-systemd_cron/pull/7) ([TheMeier](https://github.com/TheMeier))

## [v0.1.6](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.6) - 2017-09-01

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.5...v0.1.6)

### Added

- modulesync [#4](https://github.com/TheMeier/themeier-systemd_cron/pull/4) ([TheMeier](https://github.com/TheMeier))

## [v0.1.5](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.5) - 2017-07-10

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.4...v0.1.5)

## [v0.1.4](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.4) - 2017-07-10

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.3...v0.1.4)

## [v0.1.3](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.3) - 2017-07-01

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.2...v0.1.3)

### Other

- modulesync [#2](https://github.com/TheMeier/themeier-systemd_cron/pull/2) ([TheMeier](https://github.com/TheMeier))

## [v0.1.2](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.2) - 2017-01-17

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/v0.1.1...v0.1.2)

## [v0.1.1](https://github.com/TheMeier/themeier-systemd_cron/tree/v0.1.1) - 2017-01-17

[Full Changelog](https://github.com/TheMeier/themeier-systemd_cron/compare/9330f312f081077c69bb68f1b119b3a7c069784e...v0.1.1)
