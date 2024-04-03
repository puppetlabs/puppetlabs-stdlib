<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v9.6.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.6.0) - 2024-04-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.5.0...v9.6.0)

### Added

- Allow usage of file templates with stdlib::manage [#1422](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1422) ([tuxmea](https://github.com/tuxmea))

## [v9.5.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.5.0) - 2024-03-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.4.1...v9.5.0)

### Added

- Add function stdlib::sort_by [#1384](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1384) ([XMol](https://github.com/XMol))

### Fixed

- (#1389) - pw_hash with bcrypt not working on puppet master [#1410](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1410) ([TuningYourCode](https://github.com/TuningYourCode))

### Other

- Deprecate `time` function [#1417](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1417) ([alexjfisher](https://github.com/alexjfisher))

## [v9.4.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.4.1) - 2023-11-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.4.0...v9.4.1)

### Fixed

- Correct casing of Stdlib::IP::Address [#1406](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1406) ([ekohl](https://github.com/ekohl))

## [v9.4.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.4.0) - 2023-09-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.3.0...v9.4.0)

### Added

- Modernise `fqdn_rotate` function [#1341](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1341) ([alexjfisher](https://github.com/alexjfisher))

## [v9.3.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.3.0) - 2023-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.2.0...v9.3.0)

### Added

- Add stdlib::has_function [#1386](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1386) ([seanmil](https://github.com/seanmil))

### Fixed

- Re-add block support to deprecated top-level merge [#1385](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1385) ([seanmil](https://github.com/seanmil))

## [v9.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.2.0) - 2023-06-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.1.0...v9.2.0)

### Added

- Add `use_strict_setting` parameter to `deprecation` function [#1378](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1378) ([alexjfisher](https://github.com/alexjfisher))

### Fixed

- Ignore Puppet's `strict` setting when calling function without namespace [#1377](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1377) ([alexjfisher](https://github.com/alexjfisher))
- Pass calling scope to `stdlib::ensure_packages` from shim [#1366](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1366) ([alexjfisher](https://github.com/alexjfisher))

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.1.0) - 2023-06-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v9.0.0...v9.1.0)

### Added

- re-add support for loading aliases in yaml files [#1362](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1362) ([lollipopman](https://github.com/lollipopman))

### Fixed

- (CONT-1035) Alter logic of pw_hash [#1370](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1370) ([david22swan](https://github.com/david22swan))
- Fix `fqdn_rand_string` regression [#1367](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1367) ([alexjfisher](https://github.com/alexjfisher))
- (CONT-1023) - Enhancing deferrable_epp to support nested hash [#1359](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1359) ([Ramesh7](https://github.com/Ramesh7))

## [v9.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v9.0.0) - 2023-05-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.6.0...v9.0.0)

### Changed
- Deprecate the `validate_legacy()` function [#1353](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1353) ([smortex](https://github.com/smortex))
- Remove deprecated functions [#1352](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1352) ([smortex](https://github.com/smortex))
- Rewrite validate_email_address() as a Puppet 4.x function [#1350](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1350) ([smortex](https://github.com/smortex))
- Rewrite validate_domain_name() as a Puppet 4.x function [#1345](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1345) ([smortex](https://github.com/smortex))
- Rewrite seeded_rand() as a Puppet 4.x function [#1344](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1344) ([smortex](https://github.com/smortex))
- Rewrite fqdn_rand_string() as a Puppet 4.x function [#1343](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1343) ([smortex](https://github.com/smortex))
- Remove deprecated strip function [#1338](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1338) ([smortex](https://github.com/smortex))
- Remove deprecated rstrip function [#1337](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1337) ([smortex](https://github.com/smortex))
- Remove deprecated getvar function [#1336](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1336) ([smortex](https://github.com/smortex))
- Remove deprecated sort function [#1335](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1335) ([smortex](https://github.com/smortex))
- Remove deprecated upcase function [#1334](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1334) ([smortex](https://github.com/smortex))
- Remove deprecated round function [#1333](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1333) ([smortex](https://github.com/smortex))
- Remove deprecated chop function [#1331](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1331) ([smortex](https://github.com/smortex))
- Remove deprecated chomp function [#1330](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1330) ([smortex](https://github.com/smortex))
- Remove deprecated ceiling function [#1329](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1329) ([smortex](https://github.com/smortex))
- Remove deprecated capitalize functions [#1328](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1328) ([smortex](https://github.com/smortex))
- Remove deprecated camelcase function [#1327](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1327) ([smortex](https://github.com/smortex))
- Modernise `has_interface_with` function [#1326](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1326) ([alexjfisher](https://github.com/alexjfisher))
- Remove deprecated is_array function [#1325](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1325) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated is_absolute_path function [#1324](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1324) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated min function [#1323](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1323) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated max function [#1322](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1322) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated lstrip function [#1321](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1321) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated hash function [#1320](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1320) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated has_key function [#1319](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1319) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated downcase function [#1318](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1318) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated abs function [#1317](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1317) ([MartyEwings](https://github.com/MartyEwings))
- Remove dig and dig44 functions [#1316](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1316) ([MartyEwings](https://github.com/MartyEwings))
- Remove Puppet 5.5 deprecations [#1314](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1314) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated unique function [#1311](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1311) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated Private function [#1310](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1310) ([MartyEwings](https://github.com/MartyEwings))
- Remove deprecated type and type3x functions [#1309](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1309) ([MartyEwings](https://github.com/MartyEwings))
- (CONT-801) Puppet 8 support / Drop Puppet 6 support [#1307](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1307) ([LukasAud](https://github.com/LukasAud))

### Added

- Namespace Puppet 4.x functions [#1356](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1356) ([smortex](https://github.com/smortex))
- Add a function to update / regenerate deprecated shims [#1349](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1349) ([smortex](https://github.com/smortex))

### Fixed

- Remove deprecated File.exists? [#1357](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1357) ([ekohl](https://github.com/ekohl))
- Fix validate_domain_name called without parameters [#1351](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1351) ([smortex](https://github.com/smortex))
- Add Stdlib::IP::Address::CIDR [#1348](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1348) ([Geod24](https://github.com/Geod24))
- Allow `deferrable_epp` to return a `Sensitive[String]` [#1342](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1342) ([alexjfisher](https://github.com/alexjfisher))

## [v8.6.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.6.0) - 2023-04-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.5.0...v8.6.0)

### Added

- Stdlib::Http::Method: Add new type for http methods [#1299](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1299) ([b4ldr](https://github.com/b4ldr))
- Add `stdlib::sha256` [#1289](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1289) ([jcpunk](https://github.com/jcpunk))
- Add `stdlib::crc32` [#1288](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1288) ([jcpunk](https://github.com/jcpunk))
- Add Stdlib::Ensure::Package type [#1281](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1281) ([arjenz](https://github.com/arjenz))

### Fixed

- (PUP-11752) Fix fqdn_rand_string_spec.rb test [#1308](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1308) ([alexjfisher](https://github.com/alexjfisher))
- Make ensure_packages work with `ensure => present` [#1300](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1300) ([alexjfisher](https://github.com/alexjfisher))
- Safely handle a missing root user [#1295](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1295) ([ekohl](https://github.com/ekohl))
- stdlib::ensure: update function to support the generic case [#1286](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1286) ([b4ldr](https://github.com/b4ldr))
- Drop Puppet < 3.6 support in package_provider fact [#1280](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1280) ([ekohl](https://github.com/ekohl))
- Correct bcrypt salt regex [#1279](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1279) ([sabo](https://github.com/sabo))
- Determine root_home without shelling out [#1278](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1278) ([ekohl](https://github.com/ekohl))
- (CONT-173) - Updating deprecated facter instances [#1277](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1277) ([jordanbreen28](https://github.com/jordanbreen28))

## [v8.5.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.5.0) - 2022-10-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.4.0...v8.5.0)

### Added

- Add a Stdlib::CreateResources type [#1267](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1267) ([ekohl](https://github.com/ekohl))
- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#1261](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1261) ([david22swan](https://github.com/david22swan))
- (FEAT) Add function parsepson [#1259](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1259) ([david22swan](https://github.com/david22swan))

### Fixed

- (CONT-200) Fix require relative paths [#1275](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1275) ([chelnak](https://github.com/chelnak))
- pdksync - (CONT-189) Remove support for RedHat6 / OracleLinux6 / Scientific6 [#1272](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1272) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) - Dropping Support for Debian 9 [#1269](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1269) ([jordanbreen28](https://github.com/jordanbreen28))
- (MAINT) Drop support for AIX + Windows EOL OSs [#1265](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1265) ([jordanbreen28](https://github.com/jordanbreen28))
- (GH-1262) Use 'require_relative' to load stdlib due to lookup errors [#1264](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1264) ([david22swan](https://github.com/david22swan))
- Switch parsejson() from PSON to JSON parsing [#1240](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1240) ([seanmil](https://github.com/seanmil))

## [v8.4.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.4.0) - 2022-07-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.3.0...v8.4.0)

### Added

- deferrable epp function simplifying deferred templates [#1253](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1253) ([binford2k](https://github.com/binford2k))

## [v8.3.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.3.0) - 2022-07-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.2.0...v8.3.0)

### Added

- pdksync - (GH-cat-12) Add Support for Redhat 9 [#1247](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1247) ([david22swan](https://github.com/david22swan))
- Convert `ensure_packages` to new API and refactor [#1244](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1244) ([alexjfisher](https://github.com/alexjfisher))

### Fixed

- (MODULES-2892) Handle missing file in file_line [#1251](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1251) ([silug](https://github.com/silug))
- Simplify stdlib::manage [#1250](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1250) ([jcpunk](https://github.com/jcpunk))
- Unbreak `rake strings:generate:reference` [#1239](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1239) ([smortex](https://github.com/smortex))
- loadjson: do not send http_basic_authentication if not needed [#1208](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1208) ([chaen](https://github.com/chaen))

## [v8.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.2.0) - 2022-05-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.1.0...v8.2.0)

### Added

- Add `xml_encode` function [#1236](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1236) ([alexjfisher](https://github.com/alexjfisher))
- (MODULES-4976) Add windows escaping functions [#1235](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1235) ([smortex](https://github.com/smortex))
- MODULES-11309 : convert a string to a resource [#1233](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1233) ([jcpunk](https://github.com/jcpunk))
- pdksync - (FM-8922) - Add Support for Windows 2022 [#1222](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1222) ([david22swan](https://github.com/david22swan))
- (MODULES-11196) Add support for AIX 7.2 [#1220](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1220) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#1216](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1216) ([david22swan](https://github.com/david22swan))

### Fixed

- Update load_module_metadata.rb to correct capitalisation in strings documentartion [#1241](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1241) ([davidsandilands](https://github.com/davidsandilands))
- Modernize escape functions [#1238](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1238) ([smortex](https://github.com/smortex))
- Convert data to Pcore before serialisation in to_ruby/to_python [#1237](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1237) ([smortex](https://github.com/smortex))
- (maint) Update str2saltedpbkdf2.rb to use the correct salt length [#1232](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1232) ([AriaXLi](https://github.com/AriaXLi))
- Fix `to_yaml` `options` parameter [#1231](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1231) ([alexjfisher](https://github.com/alexjfisher))
- pdksync - (GH-iac-334) Remove Support for Ubuntu 14.04/16.04 [#1224](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1224) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1787) Remove Support for CentOS 6 [#1219](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1219) ([david22swan](https://github.com/david22swan))
- Fix serialization of undef in to_python() [#1205](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1205) ([smortex](https://github.com/smortex))

## [v8.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.1.0) - 2021-10-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v8.0.0...v8.1.0)

### Added

- pdksync - (IAC-1751) - Add Support for Rocky 8 [#1214](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1214) ([david22swan](https://github.com/david22swan))
- stdlib::ensure: Add support for package resource [#1213](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1213) ([david-caro](https://github.com/david-caro))
- Added to_toml function [#1209](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1209) ([nmaludy](https://github.com/nmaludy))

### Fixed

- [MODULES-11195] Add lint-ignore for pattern length [#1212](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1212) ([carabasdaniel](https://github.com/carabasdaniel))
- pdksync - (IAC-1598) - Remove Support for Debian 8 [#1210](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1210) ([david22swan](https://github.com/david22swan))
- os_version_gte: fix version comparison logic [#1207](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1207) ([kenyon](https://github.com/kenyon))
- max, lstrip: fix deprecated message [#1204](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1204) ([b4ldr](https://github.com/b4ldr))
- (MODULES-11126) Replacing URI.escape with URI::DEFAULT_PARSER [#1195](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1195) ([valleedelisle](https://github.com/valleedelisle))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v8.0.0) - 2021-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v7.1.0...v8.0.0)

### Changed
- Flip installed and present in Function ensure_packages [#1196](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1196) ([cocker-cc](https://github.com/cocker-cc))

### Added

- New function to_python() / to_ruby() [#1200](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1200) ([smortex](https://github.com/smortex))
- pdksync - (IAC-1709) - Add Support for Debian 11 [#1199](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1199) ([david22swan](https://github.com/david22swan))
- Stdlib::Http::Method: Add new type for http methods [#1192](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1192) ([b4ldr](https://github.com/b4ldr))

### Fixed

- (MODULES-11099) Make merge parameter data types actually backwards compatible [#1191](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1191) ([LadyNamedLaura](https://github.com/LadyNamedLaura))

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v7.1.0) - 2021-05-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v7.0.1...v7.1.0)

### Added

- pw_hash: add support for bcrypt variants [#1173](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1173) ([kjetilho](https://github.com/kjetilho))

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v7.0.1) - 2021-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v7.0.0...v7.0.1)

### Fixed

- Fix typo in validate_ipv6_address function [#1176](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1176) ([nbarrientos](https://github.com/nbarrientos))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v7.0.0) - 2021-03-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.6.0...v7.0.0)

### Changed
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#1164](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1164) ([carabasdaniel](https://github.com/carabasdaniel))

### Added

- Stdlib::Email type [#1160](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1160) ([b4ldr](https://github.com/b4ldr))

### Fixed

- (bugfix) Setting stricter email validation [#1163](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1163) ([pmcmaw](https://github.com/pmcmaw))
- (IAC-1414) Throw error in range() function when step size invalid [#1161](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1161) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [v6.6.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.6.0) - 2021-02-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.5.0...v6.6.0)

### Added

- stdlib::ensure: new fuction to cast ensure values [#1150](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1150) ([b4ldr](https://github.com/b4ldr))
- (feat) Add support for Puppet 7 [#1144](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1144) ([daianamezdrea](https://github.com/daianamezdrea))
- Allow options injection for to_yaml [#1137](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1137) ([baurmatt](https://github.com/baurmatt))
- Allow start/end checks on empty strings [#1135](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1135) ([jvrsantacruz](https://github.com/jvrsantacruz))
- Stdlib::HttpStatus: add type for HTTP status codes as per rfc2616 [#1132](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1132) ([b4ldr](https://github.com/b4ldr))

### Fixed

- (IAC-1375) fix unit tests for pe_version fact, when using later facte… [#1155](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1155) ([tphoney](https://github.com/tphoney))
- seeded_rand: update funtion to ensure it returns an int not String [#1139](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1139) ([b4ldr](https://github.com/b4ldr))

## [v6.5.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.5.0) - 2020-09-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.4.0...v6.5.0)

### Added

- Add parsehocon() function [#1130](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1130) ([reidmv](https://github.com/reidmv))
- Add new types for Stdlib::Ensure::File [#1129](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1129) ([b4ldr](https://github.com/b4ldr))
- Add additional types Stdlib::Port::Dynamic,Ephemeral,Registered,User} [#1128](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1128) ([b4ldr](https://github.com/b4ldr))
- Stdlib::Datasize: This CR adds a new data size type alias [#1126](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1126) ([b4ldr](https://github.com/b4ldr))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.4.0) - 2020-08-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.3.0...v6.4.0)

### Added

- pdksync - (IAC-973) - Update travis/appveyor to run on new default branch `main` [#1117](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1117) ([david22swan](https://github.com/david22swan))
- (IAC-746) - Add ubuntu 20.04 support [#1110](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1110) ([david22swan](https://github.com/david22swan))

### Fixed

- [MODULES-10781] Fix defined type defined_with_params() [#1122](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1122) ([trevor-vaughan](https://github.com/trevor-vaughan))
- [MODULES-10729] defined_with_params - unnamed type [#1115](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1115) ([trevor-vaughan](https://github.com/trevor-vaughan))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.3.0) - 2020-04-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.2.0...v6.3.0)

### Added

- Add start_with function [#1086](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1086) ([baurmatt](https://github.com/baurmatt))
- stdlib::end_with: create String.end_with function [#1084](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1084) ([b4ldr](https://github.com/b4ldr))
- Adding str2saltedpbkdf2 function [#1040](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1040) ([genebean](https://github.com/genebean))

### Fixed

- (MODULES-10623) explicitly top-scope calls to JSON methods [#1101](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1101) ([tkishel](https://github.com/tkishel))
- [IAC-547] Remove strftime from stdlib as it has already been replaced by the puppet agent since 4.8.0 [#1097](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1097) ([carabasdaniel](https://github.com/carabasdaniel))
- Add correct namespace for start_with function [#1095](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1095) ([baurmatt](https://github.com/baurmatt))
- intersection: show types in exception due to invalid arguments [#1077](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1077) ([runejuhl](https://github.com/runejuhl))
- Make type aliases stricter [#1066](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1066) ([pegasd](https://github.com/pegasd))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.2.0) - 2019-12-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.1.0...v6.2.0)

### Added

- (FM-8696) - Addition of Support for CentOS 8 [#1065](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1065) ([david22swan](https://github.com/david22swan))
- Add support for additional options to to_json_pretty [#1055](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1055) ([runejuhl](https://github.com/runejuhl))

### Fixed

- Fix PE detection (for the moment) [#1049](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1049) ([trevor-vaughan](https://github.com/trevor-vaughan))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.1.0) - 2019-09-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v6.0.0...v6.1.0)

### Added

- (MODULES-9915) Add type aliases for cloud object store uris [#1048](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1048) ([hooten](https://github.com/hooten))
- FM-8411 - add support for debian10 [#1045](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1045) ([lionce](https://github.com/lionce))
- (FM-8230) Convert testing to litmus [#1031](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1031) ([eimlav](https://github.com/eimlav))
- (FM-8160) Add Windows Server 2019 support [#1025](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1025) ([eimlav](https://github.com/eimlav))
- (FM-8048) Add RedHat 8 support [#1022](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1022) ([eimlav](https://github.com/eimlav))
- (MODULES-9049) Add type alias for 'yes' and 'no'. [#1017](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1017) ([ghoneycutt](https://github.com/ghoneycutt))
- add Stdlib::Syslogfacility type [#1005](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1005) ([bastelfreak](https://github.com/bastelfreak))

### Fixed

- fix lib/puppet/parser/functions/fqdn_rand_string.rb:21: syntax error [#1029](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1029) ([pulecp](https://github.com/pulecp))
- Limit the maximum array size produced by range(). [#1023](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1023) ([mbaynton](https://github.com/mbaynton))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v6.0.0) - 2019-05-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/5.2.0...v6.0.0)

### Changed
- pdksync - (MODULES-8444) - Raise lower Puppet bound [#1011](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1011) ([david22swan](https://github.com/david22swan))

### Added

- (MODULES-8760) Add iterative feature to merge() function [#1008](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1008) ([hlindberg](https://github.com/hlindberg))
- Add a stdlib::ip_in_range() function [#1003](https://github.com/puppetlabs/puppetlabs-stdlib/pull/1003) ([iglov](https://github.com/iglov))

## [5.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/5.2.0) - 2019-01-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/5.1.0...5.2.0)

### Added

- (MODULES-8404) - Relax `Stdlib::Filesource` type [#981](https://github.com/puppetlabs/puppetlabs-stdlib/pull/981) ([alexjfisher](https://github.com/alexjfisher))
- Creates new type Stdlib::IP::Address::V6::CIDR [#980](https://github.com/puppetlabs/puppetlabs-stdlib/pull/980) ([timhughes](https://github.com/timhughes))
- (MODULES-8137) - Addition of support for SLES 15 [#978](https://github.com/puppetlabs/puppetlabs-stdlib/pull/978) ([david22swan](https://github.com/david22swan))
- (MODULES-8322) Consider IPs with /0 as valid [#975](https://github.com/puppetlabs/puppetlabs-stdlib/pull/975) ([simondeziel](https://github.com/simondeziel))
- Add a function to compare the OS version [#972](https://github.com/puppetlabs/puppetlabs-stdlib/pull/972) ([ekohl](https://github.com/ekohl))
- (MODULES-8273) - Make unquoted classes useable [#971](https://github.com/puppetlabs/puppetlabs-stdlib/pull/971) ([baurmatt](https://github.com/baurmatt))
- add Function extname() [#949](https://github.com/puppetlabs/puppetlabs-stdlib/pull/949) ([cocker-cc](https://github.com/cocker-cc))
- (MODULES-7024) Add 20-octet MAC addresses [#905](https://github.com/puppetlabs/puppetlabs-stdlib/pull/905) ([ananace](https://github.com/ananace))

### Fixed

- pdksync - (FM-7655) Fix rubygems-update for ruby < 2.3 [#979](https://github.com/puppetlabs/puppetlabs-stdlib/pull/979) ([tphoney](https://github.com/tphoney))
- fix ensure_packages duplicate checking [#969](https://github.com/puppetlabs/puppetlabs-stdlib/pull/969) ([netzvieh](https://github.com/netzvieh))

## [5.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/5.1.0) - 2018-10-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/5.0.0...5.1.0)

### Added

- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#958](https://github.com/puppetlabs/puppetlabs-stdlib/pull/958) ([tphoney](https://github.com/tphoney))
- (maint) Convert from mocking with mocha to rspec-mocks [#948](https://github.com/puppetlabs/puppetlabs-stdlib/pull/948) ([rodjek](https://github.com/rodjek))

### Fixed

- (FM-7388) - Fixing unit tests for puppet 4, 5 and 6 [#962](https://github.com/puppetlabs/puppetlabs-stdlib/pull/962) ([tphoney](https://github.com/tphoney))
- (MODULES-7768) Handle nil in delete_undef_values() function [#954](https://github.com/puppetlabs/puppetlabs-stdlib/pull/954) ([hlindberg](https://github.com/hlindberg))
- Update docs for 'concat' to be correct [#950](https://github.com/puppetlabs/puppetlabs-stdlib/pull/950) ([rhowe-gds](https://github.com/rhowe-gds))

## [5.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/5.0.0) - 2018-08-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.25.1...5.0.0)

### Added

- (MODULES-7541) http type checks case insensitive [#934](https://github.com/puppetlabs/puppetlabs-stdlib/pull/934) ([tphoney](https://github.com/tphoney))
- (MODULES-7440) Update Stdlib to support Ubuntu 18.04 [#932](https://github.com/puppetlabs/puppetlabs-stdlib/pull/932) ([david22swan](https://github.com/david22swan))
- Allow loadyaml() and loadjason() to accept URLs with HTTP basic auth [#923](https://github.com/puppetlabs/puppetlabs-stdlib/pull/923) ([jonnytdevops](https://github.com/jonnytdevops))
- Load https file into loadjson() and loadyaml() [#918](https://github.com/puppetlabs/puppetlabs-stdlib/pull/918) ([jonnytdevops](https://github.com/jonnytdevops))
- Add support for symbolic file modes [#915](https://github.com/puppetlabs/puppetlabs-stdlib/pull/915) ([runejuhl](https://github.com/runejuhl))
- (MODULES-7181) Remove Stdlib::(Ipv4|IPv6|Ip_address) [#909](https://github.com/puppetlabs/puppetlabs-stdlib/pull/909) ([baurmatt](https://github.com/baurmatt))
- Allow pick() to work with strict variables [#890](https://github.com/puppetlabs/puppetlabs-stdlib/pull/890) ([binford2k](https://github.com/binford2k))
- seeded_rand_string() function [#877](https://github.com/puppetlabs/puppetlabs-stdlib/pull/877) ([pegasd](https://github.com/pegasd))

### Fixed

- Make any2array return empty array on empty string [#930](https://github.com/puppetlabs/puppetlabs-stdlib/pull/930) ([jbro](https://github.com/jbro))
- Revert "Allow pick() to work with strict variables" [#927](https://github.com/puppetlabs/puppetlabs-stdlib/pull/927) ([mwhahaha](https://github.com/mwhahaha))
- (docs) update documentation wrt functions moved to puppet [#922](https://github.com/puppetlabs/puppetlabs-stdlib/pull/922) ([hlindberg](https://github.com/hlindberg))

## [4.25.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.25.1) - 2018-04-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.25.0...4.25.1)

## [4.25.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.25.0) - 2018-03-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.24.0...4.25.0)

### Added

- (MODULES-6366) Add data types for IP validation [#872](https://github.com/puppetlabs/puppetlabs-stdlib/pull/872) ([ghoneycutt](https://github.com/ghoneycutt))
- add Stdlib::Fqdn and Stdlib::Host [#842](https://github.com/puppetlabs/puppetlabs-stdlib/pull/842) ([b4ldr](https://github.com/b4ldr))
- add Stdlib::Filesource [#841](https://github.com/puppetlabs/puppetlabs-stdlib/pull/841) ([b4ldr](https://github.com/b4ldr))
- add Stdlib::base64 and Stdlib::Base32 types [#840](https://github.com/puppetlabs/puppetlabs-stdlib/pull/840) ([b4ldr](https://github.com/b4ldr))
- add Stdlib::Port, Stdlib::Privilegedport & Stdlib::Unprivilegedport [#839](https://github.com/puppetlabs/puppetlabs-stdlib/pull/839) ([b4ldr](https://github.com/b4ldr))

### Fixed

- Handle join_keys_to_values() with undef values. [#874](https://github.com/puppetlabs/puppetlabs-stdlib/pull/874) ([BobVanB](https://github.com/BobVanB))
- FixToAccountForVersionChange [#867](https://github.com/puppetlabs/puppetlabs-stdlib/pull/867) ([david22swan](https://github.com/david22swan))

## [4.24.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.24.0) - 2017-12-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.23.0...4.24.0)

### Fixed

- (MODULES-6216) - Fix type3x function in stdlib [#861](https://github.com/puppetlabs/puppetlabs-stdlib/pull/861) ([pmcmaw](https://github.com/pmcmaw))

## [4.23.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.23.0) - 2017-11-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.22.0...4.23.0)

## [4.22.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.22.0) - 2017-11-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.21.0...4.22.0)

### Fixed

- Fixes a minor typo [#845](https://github.com/puppetlabs/puppetlabs-stdlib/pull/845) ([jbondpdx](https://github.com/jbondpdx))

## [4.21.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.21.0) - 2017-11-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.20.0...4.21.0)

### Added

- Add Stdlib::Mode type [#834](https://github.com/puppetlabs/puppetlabs-stdlib/pull/834) ([ghoneycutt](https://github.com/ghoneycutt))
- (MODULES-5680) Added new function sprintf_hash to allow using named references [#824](https://github.com/puppetlabs/puppetlabs-stdlib/pull/824) ([vStone](https://github.com/vStone))
- (MODULES-5679) Add a new function ifelse to match ruby's tenary operator [#823](https://github.com/puppetlabs/puppetlabs-stdlib/pull/823) ([vStone](https://github.com/vStone))
- Add a type for ensure on service resources [#750](https://github.com/puppetlabs/puppetlabs-stdlib/pull/750) ([npwalker](https://github.com/npwalker))

### Fixed

- Revert "(MODULES-5679) Add a new function ifelse to match ruby's tenary operator" [#832](https://github.com/puppetlabs/puppetlabs-stdlib/pull/832) ([david22swan](https://github.com/david22swan))
- (maint) Fix example syntax [#829](https://github.com/puppetlabs/puppetlabs-stdlib/pull/829) ([binford2k](https://github.com/binford2k))
- correct test cases to properly check result [#826](https://github.com/puppetlabs/puppetlabs-stdlib/pull/826) ([felixdoerre](https://github.com/felixdoerre))
- (MODULES-5651) Do not append infinitely [#825](https://github.com/puppetlabs/puppetlabs-stdlib/pull/825) ([hunner](https://github.com/hunner))
- use single quotes in validate_legacy example code [#816](https://github.com/puppetlabs/puppetlabs-stdlib/pull/816) ([mutante](https://github.com/mutante))
- Allow root as valid UNIX path [#811](https://github.com/puppetlabs/puppetlabs-stdlib/pull/811) ([kofrezo](https://github.com/kofrezo))
- Fix filenames of two function spec tests [#777](https://github.com/puppetlabs/puppetlabs-stdlib/pull/777) ([alexjfisher](https://github.com/alexjfisher))

## [4.20.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.20.0) - 2017-09-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.19.0...4.20.0)

### Added

- (MODULES-5546) add check for pw_hash [#810](https://github.com/puppetlabs/puppetlabs-stdlib/pull/810) ([eputnam](https://github.com/eputnam))
- Added to_json, to_json_pretty, and to_yaml functions [#809](https://github.com/puppetlabs/puppetlabs-stdlib/pull/809) ([WhatsARanjit](https://github.com/WhatsARanjit))

## [4.19.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.19.0) - 2017-08-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.18.0...4.19.0)

## [4.18.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.18.0) - 2017-08-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.17.1...4.18.0)

### Added

- MODULES-5382 Add documentation for email functions [#800](https://github.com/puppetlabs/puppetlabs-stdlib/pull/800) ([tphoney](https://github.com/tphoney))
- add type for MAC address [#796](https://github.com/puppetlabs/puppetlabs-stdlib/pull/796) ([bastelfreak](https://github.com/bastelfreak))
- (MODULES-4908) adds support for sensitive data type to pw_hash [#791](https://github.com/puppetlabs/puppetlabs-stdlib/pull/791) ([eputnam](https://github.com/eputnam))
- (FACT-932) Add new function, fact() [#787](https://github.com/puppetlabs/puppetlabs-stdlib/pull/787) ([reidmv](https://github.com/reidmv))
- Add validate_domain_name function [#753](https://github.com/puppetlabs/puppetlabs-stdlib/pull/753) ([frapex](https://github.com/frapex))
- Add a round function to complement ceiling and floor [#748](https://github.com/puppetlabs/puppetlabs-stdlib/pull/748) ([npwalker](https://github.com/npwalker))
- Add new file_line option append_on_no_match [#717](https://github.com/puppetlabs/puppetlabs-stdlib/pull/717) ([ripclawffb](https://github.com/ripclawffb))

### Fixed

- MODULES-5440 fix upper bound for puppet [#803](https://github.com/puppetlabs/puppetlabs-stdlib/pull/803) ([tphoney](https://github.com/tphoney))
- (MODULES-5003) file_line does not change multiple lines when one matches [#794](https://github.com/puppetlabs/puppetlabs-stdlib/pull/794) ([tkishel](https://github.com/tkishel))
- (MODULES-5003) file_line fix all broken lines [#788](https://github.com/puppetlabs/puppetlabs-stdlib/pull/788) ([tphoney](https://github.com/tphoney))
- (MODULES-5113) Make line support Sensitive [#786](https://github.com/puppetlabs/puppetlabs-stdlib/pull/786) ([reidmv](https://github.com/reidmv))
- Fix headers in CHANGELOG.md so that headers render correctly [#783](https://github.com/puppetlabs/puppetlabs-stdlib/pull/783) ([davewongillies](https://github.com/davewongillies))
- (Modules 4377) Causes ensure_packages to accept concurrent declarations with ensure => 'present' and 'installed' [#716](https://github.com/puppetlabs/puppetlabs-stdlib/pull/716) ([EmersonPrado](https://github.com/EmersonPrado))

## [4.17.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.17.1) - 2017-06-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.17.0...4.17.1)

### Fixed

- (MODULES-5095) Workaround for PUP-7650 [#780](https://github.com/puppetlabs/puppetlabs-stdlib/pull/780) ([thallgren](https://github.com/thallgren))
- (FM-6197) formatting fixes for file_line resource [#779](https://github.com/puppetlabs/puppetlabs-stdlib/pull/779) ([jbondpdx](https://github.com/jbondpdx))

## [4.17.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.17.0) - 2017-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.16.0...4.17.0)

### Added

- (FM-6116) - Adding POT file for metadata.json [#746](https://github.com/puppetlabs/puppetlabs-stdlib/pull/746) ([pmcmaw](https://github.com/pmcmaw))
- Add glob function [#718](https://github.com/puppetlabs/puppetlabs-stdlib/pull/718) ([sspreitzer](https://github.com/sspreitzer))

### Fixed

- (MODULES-4706) prerelease fixes [#771](https://github.com/puppetlabs/puppetlabs-stdlib/pull/771) ([eputnam](https://github.com/eputnam))
- (MODULES-4706) prerelease fixes [#770](https://github.com/puppetlabs/puppetlabs-stdlib/pull/770) ([jbondpdx](https://github.com/jbondpdx))
- (PE-20308) Fix defined_with_params() for defined type strings & references [#765](https://github.com/puppetlabs/puppetlabs-stdlib/pull/765) ([hunner](https://github.com/hunner))
- (PE-20308) Correct boundary for 4.5 vs 4.6 [#763](https://github.com/puppetlabs/puppetlabs-stdlib/pull/763) ([hunner](https://github.com/hunner))
- (PE-20308) Pass a literal type and not a string to findresource [#761](https://github.com/puppetlabs/puppetlabs-stdlib/pull/761) ([hunner](https://github.com/hunner))
- Ruby 1.8 doesn't support open_args [#758](https://github.com/puppetlabs/puppetlabs-stdlib/pull/758) ([sathieu](https://github.com/sathieu))
- [MODULES-4528] Replace Puppet.version.to_f version comparison from spec_helper.rb [#745](https://github.com/puppetlabs/puppetlabs-stdlib/pull/745) ([wilson208](https://github.com/wilson208))

## [4.16.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.16.0) - 2017-03-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.15.0...4.16.0)

### Added

- (FM-6051) Adds comments to warn for UTF8 incompatibility [#741](https://github.com/puppetlabs/puppetlabs-stdlib/pull/741) ([HelenCampbell](https://github.com/HelenCampbell))
- Addition of new length function [#736](https://github.com/puppetlabs/puppetlabs-stdlib/pull/736) ([HelenCampbell](https://github.com/HelenCampbell))
- (FM-6086) - Unit tests for Resource Types [#734](https://github.com/puppetlabs/puppetlabs-stdlib/pull/734) ([pmcmaw](https://github.com/pmcmaw))
- (FM-6063) - Unit tests for high effort functions [#732](https://github.com/puppetlabs/puppetlabs-stdlib/pull/732) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-4485) Improve ipv6 support for type [#731](https://github.com/puppetlabs/puppetlabs-stdlib/pull/731) ([petems](https://github.com/petems))
- (#FM-6068) allow file encoding to be specified [#726](https://github.com/puppetlabs/puppetlabs-stdlib/pull/726) ([GeoffWilliams](https://github.com/GeoffWilliams))

### Fixed

- Permit double slash in absolute/Unix path types [#740](https://github.com/puppetlabs/puppetlabs-stdlib/pull/740) ([domcleal](https://github.com/domcleal))
- (MODULES-4528) Use versioncmp to check Puppet version for 4.10.x compat [#737](https://github.com/puppetlabs/puppetlabs-stdlib/pull/737) ([domcleal](https://github.com/domcleal))
- Should only try to apply the resource if it not defined [#735](https://github.com/puppetlabs/puppetlabs-stdlib/pull/735) ([elmobp](https://github.com/elmobp))
- loosen the regex for tuple checking [#728](https://github.com/puppetlabs/puppetlabs-stdlib/pull/728) ([tphoney](https://github.com/tphoney))
- Fix acceptance test failure "Hiera is not a class" [#720](https://github.com/puppetlabs/puppetlabs-stdlib/pull/720) ([DavidS](https://github.com/DavidS))
- Fix unsupported data type error with rspec-puppet master [#715](https://github.com/puppetlabs/puppetlabs-stdlib/pull/715) ([domcleal](https://github.com/domcleal))

## [4.15.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.15.0) - 2017-01-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.14.0...4.15.0)

### Added

- Implement beaker-module_install_helper [#713](https://github.com/puppetlabs/puppetlabs-stdlib/pull/713) ([wilson208](https://github.com/wilson208))
- Addition of compat hash type for deprecation [#708](https://github.com/puppetlabs/puppetlabs-stdlib/pull/708) ([HelenCampbell](https://github.com/HelenCampbell))
- add ubuntu xenial to metadata [#705](https://github.com/puppetlabs/puppetlabs-stdlib/pull/705) ([eputnam](https://github.com/eputnam))
- (MODULES-4188) Add UUID generation function [#700](https://github.com/puppetlabs/puppetlabs-stdlib/pull/700) ([petems](https://github.com/petems))
- Add pry() function from hunner-pry [#640](https://github.com/puppetlabs/puppetlabs-stdlib/pull/640) ([hunner](https://github.com/hunner))
- Add puppet_server fact to return agent's server [#613](https://github.com/puppetlabs/puppetlabs-stdlib/pull/613) ([reidmv](https://github.com/reidmv))

## [4.14.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.14.0) - 2016-12-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.13.1...4.14.0)

### Added

- (MODULES-3829) Add tests for ensure_resources [#697](https://github.com/puppetlabs/puppetlabs-stdlib/pull/697) ([HAIL9000](https://github.com/HAIL9000))
- Addition of 4.6 and 4.7 travis cells [#686](https://github.com/puppetlabs/puppetlabs-stdlib/pull/686) ([HelenCampbell](https://github.com/HelenCampbell))
- Handle array values in join_keys_to_values function [#632](https://github.com/puppetlabs/puppetlabs-stdlib/pull/632) ([edestecd](https://github.com/edestecd))

### Fixed

- (MODULES-3393) Deprecation - Use puppet stacktrace if available [#693](https://github.com/puppetlabs/puppetlabs-stdlib/pull/693) ([HelenCampbell](https://github.com/HelenCampbell))
- Revert "Call site output for deprecation warnings" [#692](https://github.com/puppetlabs/puppetlabs-stdlib/pull/692) ([bmjen](https://github.com/bmjen))
- Fix spec failures on puppet 4.8 [#689](https://github.com/puppetlabs/puppetlabs-stdlib/pull/689) ([DavidS](https://github.com/DavidS))
- (MODULES-3829) Use .dup to duplicate classes for modification. [#687](https://github.com/puppetlabs/puppetlabs-stdlib/pull/687) ([MG2R](https://github.com/MG2R))
- (MODULES-3980) Fix ipv4 regex validator [#680](https://github.com/puppetlabs/puppetlabs-stdlib/pull/680) ([DavidS](https://github.com/DavidS))

## [4.13.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.13.1) - 2016-10-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.13.0...4.13.1)

## [4.13.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.13.0) - 2016-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.12.0...4.13.0)

### Added

- Add deprecation warnings to remaining validates [#656](https://github.com/puppetlabs/puppetlabs-stdlib/pull/656) ([HelenCampbell](https://github.com/HelenCampbell))
- Addition of logging with file and line numbers [#651](https://github.com/puppetlabs/puppetlabs-stdlib/pull/651) ([HelenCampbell](https://github.com/HelenCampbell))
- Add facter fact for puppet_environmentpath [#648](https://github.com/puppetlabs/puppetlabs-stdlib/pull/648) ([stbenjam](https://github.com/stbenjam))
- (MODULES-3540) Addition of validate legacy function [#630](https://github.com/puppetlabs/puppetlabs-stdlib/pull/630) ([HelenCampbell](https://github.com/HelenCampbell))
- Added documentation for regexpescape function. [#625](https://github.com/puppetlabs/puppetlabs-stdlib/pull/625) ([mooresm1](https://github.com/mooresm1))
- Added the regexpescape function. [#624](https://github.com/puppetlabs/puppetlabs-stdlib/pull/624) ([mooresm1](https://github.com/mooresm1))
- (MODULES-3529) add deprecation function [#617](https://github.com/puppetlabs/puppetlabs-stdlib/pull/617) ([tphoney](https://github.com/tphoney))
- Add delete_regex [#605](https://github.com/puppetlabs/puppetlabs-stdlib/pull/605) ([jyaworski](https://github.com/jyaworski))
- Add a missing s in the ensure_packages hash example [#604](https://github.com/puppetlabs/puppetlabs-stdlib/pull/604) ([rjw1](https://github.com/rjw1))
- (MODULES-1439) Adds any2bool function [#601](https://github.com/puppetlabs/puppetlabs-stdlib/pull/601) ([petems](https://github.com/petems))
- Add the default value to the "loadyaml" function [#600](https://github.com/puppetlabs/puppetlabs-stdlib/pull/600) ([dmitryilyin](https://github.com/dmitryilyin))

### Fixed

- (MODULES-3590) Fix match_for_absence parameter [#666](https://github.com/puppetlabs/puppetlabs-stdlib/pull/666) ([HAIL9000](https://github.com/HAIL9000))
- Ignore :undefined_variable "reason" in getvar [#665](https://github.com/puppetlabs/puppetlabs-stdlib/pull/665) ([mks-m](https://github.com/mks-m))
- (MODULES-3933) Fix getparam for 'false' values [#663](https://github.com/puppetlabs/puppetlabs-stdlib/pull/663) ([DavidS](https://github.com/DavidS))
- Permit undef passed as `nil` to validate_string [#662](https://github.com/puppetlabs/puppetlabs-stdlib/pull/662) ([domcleal](https://github.com/domcleal))
- Ensure validate functions use Puppet 4 deprecation [#659](https://github.com/puppetlabs/puppetlabs-stdlib/pull/659) ([HelenCampbell](https://github.com/HelenCampbell))
- Revert "Ensure validate functions use Puppet 4 deprecation" [#655](https://github.com/puppetlabs/puppetlabs-stdlib/pull/655) ([HelenCampbell](https://github.com/HelenCampbell))
- Ensure validate functions use Puppet 4 deprecation [#654](https://github.com/puppetlabs/puppetlabs-stdlib/pull/654) ([HelenCampbell](https://github.com/HelenCampbell))
- Fix whitespace [#653](https://github.com/puppetlabs/puppetlabs-stdlib/pull/653) ([hunner](https://github.com/hunner))
- MODULES-3699 Deprecation spec fix 2 [#646](https://github.com/puppetlabs/puppetlabs-stdlib/pull/646) ([eputnam](https://github.com/eputnam))
- Fix markdown indentation [#631](https://github.com/puppetlabs/puppetlabs-stdlib/pull/631) ([smortex](https://github.com/smortex))
- Fix str2bool error message [#626](https://github.com/puppetlabs/puppetlabs-stdlib/pull/626) ([LoicGombeaud](https://github.com/LoicGombeaud))
- (MODULES-3543) Fixup defined_with_params to work on all puppet versions [#615](https://github.com/puppetlabs/puppetlabs-stdlib/pull/615) ([DavidS](https://github.com/DavidS))
- (MODULES-3543) Fix define_with_params to handle undef properly [#614](https://github.com/puppetlabs/puppetlabs-stdlib/pull/614) ([DavidS](https://github.com/DavidS))
- (MODULES-3354) Use 1.8.7 hash in validate_email_address function [#606](https://github.com/puppetlabs/puppetlabs-stdlib/pull/606) ([stbenjam](https://github.com/stbenjam))
- Use reject instead of delete_if [#592](https://github.com/puppetlabs/puppetlabs-stdlib/pull/592) ([jyaworski](https://github.com/jyaworski))

## [4.12.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.12.0) - 2016-05-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.11.0...4.12.0)

### Added

- Add support for regular expressions to delete [#591](https://github.com/puppetlabs/puppetlabs-stdlib/pull/591) ([jyaworski](https://github.com/jyaworski))
- Add validate_email_address function [#583](https://github.com/puppetlabs/puppetlabs-stdlib/pull/583) ([jyaworski](https://github.com/jyaworski))
- Add check if Gem is defined [#579](https://github.com/puppetlabs/puppetlabs-stdlib/pull/579) ([sulaweyo](https://github.com/sulaweyo))
- Add enclose_ipv6 function [#577](https://github.com/puppetlabs/puppetlabs-stdlib/pull/577) ([EmilienM](https://github.com/EmilienM))
- ensure_packages.rb: Modifed to pass hiera parameters (as hash,array) as first argument [#576](https://github.com/puppetlabs/puppetlabs-stdlib/pull/576) ([yadavnikhil](https://github.com/yadavnikhil))
- Extend Base64() function support [#575](https://github.com/puppetlabs/puppetlabs-stdlib/pull/575) ([guessi](https://github.com/guessi))
- Add dig function [#573](https://github.com/puppetlabs/puppetlabs-stdlib/pull/573) ([mks-m](https://github.com/mks-m))
- Add is_ipv4_address and is_ipv6_address functions [#570](https://github.com/puppetlabs/puppetlabs-stdlib/pull/570) ([gfidente](https://github.com/gfidente))
- Add test for basename on path with scheme [#567](https://github.com/puppetlabs/puppetlabs-stdlib/pull/567) ([alechenninger](https://github.com/alechenninger))

### Fixed

- Undo changing delete() to delete regex matches [#599](https://github.com/puppetlabs/puppetlabs-stdlib/pull/599) ([hunner](https://github.com/hunner))
- (MODULES-3271) Ensure that is_email_address works on unsupported rubies [#598](https://github.com/puppetlabs/puppetlabs-stdlib/pull/598) ([DavidS](https://github.com/DavidS))
- (MODULES-3246) Fix concat with Hash arguments. [#590](https://github.com/puppetlabs/puppetlabs-stdlib/pull/590) ([alext](https://github.com/alext))
- (maint) Fixes fqdn_rand_string tests [#578](https://github.com/puppetlabs/puppetlabs-stdlib/pull/578) ([bmjen](https://github.com/bmjen))
- Fix reference to validate_bool in function [#568](https://github.com/puppetlabs/puppetlabs-stdlib/pull/568) ([mattbostock](https://github.com/mattbostock))

## [4.11.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.11.0) - 2016-01-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.10.0...4.11.0)

### Added

- minor tweak to 4.11.0 adding debian 8 to metadata [#565](https://github.com/puppetlabs/puppetlabs-stdlib/pull/565) ([tphoney](https://github.com/tphoney))
- Allow package_provider fact to resolve on PE 3.x [#561](https://github.com/puppetlabs/puppetlabs-stdlib/pull/561) ([DavidS](https://github.com/DavidS))
- adds new parser called is_absolute_path [#553](https://github.com/puppetlabs/puppetlabs-stdlib/pull/553) ([logicminds](https://github.com/logicminds))
- Add a function to validate an x509 RSA key pair [#552](https://github.com/puppetlabs/puppetlabs-stdlib/pull/552) ([mattbostock](https://github.com/mattbostock))
- Add clamp function [#545](https://github.com/puppetlabs/puppetlabs-stdlib/pull/545) ([mpolenchuk](https://github.com/mpolenchuk))

## [4.10.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.10.0) - 2015-12-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.9.1...4.10.0)

### Added

- (#2886) seeded_rand: new function [#554](https://github.com/puppetlabs/puppetlabs-stdlib/pull/554) ([kjetilho](https://github.com/kjetilho))

## [4.9.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.9.1) - 2015-12-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.9.0...4.9.1)

### Added

- Add validator for any IP address [#546](https://github.com/puppetlabs/puppetlabs-stdlib/pull/546) ([devvesa](https://github.com/devvesa))
- Add check to ensure regex does not throw for none type. [#539](https://github.com/puppetlabs/puppetlabs-stdlib/pull/539) ([mentat](https://github.com/mentat))
- add functionality to bool2str function [#538](https://github.com/puppetlabs/puppetlabs-stdlib/pull/538) ([mmckinst](https://github.com/mmckinst))
- Add package_provider fact [#534](https://github.com/puppetlabs/puppetlabs-stdlib/pull/534) ([asasfu](https://github.com/asasfu))
- (MODULES-2561) add is_a function [#523](https://github.com/puppetlabs/puppetlabs-stdlib/pull/523) ([DavidS](https://github.com/DavidS))
- accept any case of boolean strings [#518](https://github.com/puppetlabs/puppetlabs-stdlib/pull/518) ([logicminds](https://github.com/logicminds))
- [MODULES-2462] Improve parseyaml function [#511](https://github.com/puppetlabs/puppetlabs-stdlib/pull/511) ([dmitryilyin](https://github.com/dmitryilyin))
- Add a service_provider fact [#506](https://github.com/puppetlabs/puppetlabs-stdlib/pull/506) ([binford2k](https://github.com/binford2k))

### Fixed

- Fix reference to validate_bool in IP4 function [#551](https://github.com/puppetlabs/puppetlabs-stdlib/pull/551) ([mattbostock](https://github.com/mattbostock))
- Fix Gemfile to work with ruby 1.8.7 [#548](https://github.com/puppetlabs/puppetlabs-stdlib/pull/548) ([bmjen](https://github.com/bmjen))
- (FM-3773) Fix root_home fact on AIX 5.x [#547](https://github.com/puppetlabs/puppetlabs-stdlib/pull/547) ([reidmv](https://github.com/reidmv))
- Use absolute class name in example [#543](https://github.com/puppetlabs/puppetlabs-stdlib/pull/543) ([ghoneycutt](https://github.com/ghoneycutt))
- use properly encoded characters [#542](https://github.com/puppetlabs/puppetlabs-stdlib/pull/542) ([greg0ire](https://github.com/greg0ire))
- Fix load module metadata [#537](https://github.com/puppetlabs/puppetlabs-stdlib/pull/537) ([cmurphy](https://github.com/cmurphy))
- prevent deprecation warning about the allow_virtual parameter [#535](https://github.com/puppetlabs/puppetlabs-stdlib/pull/535) ([martinpfeifer](https://github.com/martinpfeifer))
- Fix backwards compatibility from #511 [#527](https://github.com/puppetlabs/puppetlabs-stdlib/pull/527) ([underscorgan](https://github.com/underscorgan))

## [4.9.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.9.0) - 2015-09-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.8.0...4.9.0)

### Added

- Adds a convert_base function, which can convert numbers between bases [#514](https://github.com/puppetlabs/puppetlabs-stdlib/pull/514) ([DavidS](https://github.com/DavidS))
- Add a new function "try_get_value" [#513](https://github.com/puppetlabs/puppetlabs-stdlib/pull/513) ([dmitryilyin](https://github.com/dmitryilyin))
- (MODULES-2456) Modify union to accept more than two arrays [#507](https://github.com/puppetlabs/puppetlabs-stdlib/pull/507) ([Jetroid](https://github.com/Jetroid))
- (MODULES-2410) Add new functions dos2unix and unix2dos [#505](https://github.com/puppetlabs/puppetlabs-stdlib/pull/505) ([gibbsoft](https://github.com/gibbsoft))

### Fixed

- (MAINT) fix up try_get_value acceptance test [#517](https://github.com/puppetlabs/puppetlabs-stdlib/pull/517) ([DavidS](https://github.com/DavidS))
- Ticket/MODULES-2478 Make root_home fact work on AIX using native lsuser command [#515](https://github.com/puppetlabs/puppetlabs-stdlib/pull/515) ([jfautley](https://github.com/jfautley))

## [4.8.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.8.0) - 2015-08-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.7.0...4.8.0)

### Added

- [#puppethack] Adding replace attribute to file_line [#494](https://github.com/puppetlabs/puppetlabs-stdlib/pull/494) ([rmaika](https://github.com/rmaika))
- Add load_metadata_json function [#483](https://github.com/puppetlabs/puppetlabs-stdlib/pull/483) ([nibalizer](https://github.com/nibalizer))

### Fixed

- Fix extraneous end [#501](https://github.com/puppetlabs/puppetlabs-stdlib/pull/501) ([hunner](https://github.com/hunner))
- (MODULES-2316) Change file_type boolean parameter to symbols [#497](https://github.com/puppetlabs/puppetlabs-stdlib/pull/497) ([domcleal](https://github.com/domcleal))
- Style fixes [#491](https://github.com/puppetlabs/puppetlabs-stdlib/pull/491) ([ekohl](https://github.com/ekohl))

## [4.7.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.7.0) - 2015-07-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.6.0...4.7.0)

### Added

- adding support for hash in the size function [#489](https://github.com/puppetlabs/puppetlabs-stdlib/pull/489) ([gcmalloc](https://github.com/gcmalloc))
- Add support for Solaris 12 [#478](https://github.com/puppetlabs/puppetlabs-stdlib/pull/478) ([drewfisher314](https://github.com/drewfisher314))
- (FM-2130) Document new location of facts.d cache [#454](https://github.com/puppetlabs/puppetlabs-stdlib/pull/454) ([elyscape](https://github.com/elyscape))

### Fixed

- (maint) Fix test to not assume is_pe fact on > 4.0.0 puppet [#488](https://github.com/puppetlabs/puppetlabs-stdlib/pull/488) ([cyberious](https://github.com/cyberious))
- Fix documentation error in upcase [#487](https://github.com/puppetlabs/puppetlabs-stdlib/pull/487) ([liv3d](https://github.com/liv3d))
- Clarify that third argument to ensure_resource() is a hash [#485](https://github.com/puppetlabs/puppetlabs-stdlib/pull/485) ([ghoneycutt](https://github.com/ghoneycutt))
- Use puppet_install_helper [#484](https://github.com/puppetlabs/puppetlabs-stdlib/pull/484) ([underscorgan](https://github.com/underscorgan))
- catch and rescue from looking up non-existent facts [#479](https://github.com/puppetlabs/puppetlabs-stdlib/pull/479) ([mklette](https://github.com/mklette))
- AIO uses puppet 4 so should return true for is_future_parser_enabled [#477](https://github.com/puppetlabs/puppetlabs-stdlib/pull/477) ([underscorgan](https://github.com/underscorgan))
- Also catch :undefined_variable as thrown by future parser [#470](https://github.com/puppetlabs/puppetlabs-stdlib/pull/470) ([bobtfish](https://github.com/bobtfish))
- Fix time() on 1.8.7 [#469](https://github.com/puppetlabs/puppetlabs-stdlib/pull/469) ([hunner](https://github.com/hunner))
- Fix spelling of camelcase [#468](https://github.com/puppetlabs/puppetlabs-stdlib/pull/468) ([kylog](https://github.com/kylog))
- (MODULES-1882) convert function tests to rspec-puppet [#464](https://github.com/puppetlabs/puppetlabs-stdlib/pull/464) ([DavidS](https://github.com/DavidS))
-  (MODULES-2071) Patch file_line provider to use multiple with after [#463](https://github.com/puppetlabs/puppetlabs-stdlib/pull/463) ([rmaika](https://github.com/rmaika))
- fqdn_rotate: Don't use the value itself as part of the random seed [#462](https://github.com/puppetlabs/puppetlabs-stdlib/pull/462) ([elyscape](https://github.com/elyscape))
- validate_integer, validate_numeric: explicitely reject hashes in arrays [#461](https://github.com/puppetlabs/puppetlabs-stdlib/pull/461) ([DavidS](https://github.com/DavidS))
- fqdn_rotate: reset srand seed correctly on old ruby versions [#460](https://github.com/puppetlabs/puppetlabs-stdlib/pull/460) ([DavidS](https://github.com/DavidS))
- range(): fix TypeError(can't convert nil into Integer) when using range ... [#448](https://github.com/puppetlabs/puppetlabs-stdlib/pull/448) ([DavidS](https://github.com/DavidS))
- Fix pw_hash() on JRuby < 1.7.17 [#446](https://github.com/puppetlabs/puppetlabs-stdlib/pull/446) ([elyscape](https://github.com/elyscape))
- uses include type class declaration [#441](https://github.com/puppetlabs/puppetlabs-stdlib/pull/441) ([mrzarquon](https://github.com/mrzarquon))
- fqdn_rand_string: fix argument error message [#440](https://github.com/puppetlabs/puppetlabs-stdlib/pull/440) ([DavidS](https://github.com/DavidS))
- Check if file exists before loading with loadyaml. If not, return nil [#314](https://github.com/puppetlabs/puppetlabs-stdlib/pull/314) ([amateo](https://github.com/amateo))

## [4.6.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.6.0) - 2015-04-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.5.1...4.6.0)

### Added

- Modules-2474: Only runs enhanced salts functions test on systems that ... [#434](https://github.com/puppetlabs/puppetlabs-stdlib/pull/434) ([bmjen](https://github.com/bmjen))
- Clarifying behaviour of attributes and adding an extra example. [#430](https://github.com/puppetlabs/puppetlabs-stdlib/pull/430) ([underscorgan](https://github.com/underscorgan))
- (BKR-147) add Gemfile setting for BEAKER_VERSION for puppet... [#426](https://github.com/puppetlabs/puppetlabs-stdlib/pull/426) ([anodelman](https://github.com/anodelman))
- Add ability to pin beaker versions [#423](https://github.com/puppetlabs/puppetlabs-stdlib/pull/423) ([cyberious](https://github.com/cyberious))
- Add support for hashes in the prefix function [#420](https://github.com/puppetlabs/puppetlabs-stdlib/pull/420) ([underscorgan](https://github.com/underscorgan))
- Loosen the restrictions of upcase and allow for recursion of the objects... [#419](https://github.com/puppetlabs/puppetlabs-stdlib/pull/419) ([cyberious](https://github.com/cyberious))
- Add Hash to upcase [#417](https://github.com/puppetlabs/puppetlabs-stdlib/pull/417) ([cyberious](https://github.com/cyberious))
- (MODULES-1737) Add pw_hash() function [#408](https://github.com/puppetlabs/puppetlabs-stdlib/pull/408) ([elyscape](https://github.com/elyscape))
- Add a ceiling function to complement the floor function. [#407](https://github.com/puppetlabs/puppetlabs-stdlib/pull/407) ([adamcrews](https://github.com/adamcrews))
- (MODULES-1715) Add FQDN-based random string generator [#405](https://github.com/puppetlabs/puppetlabs-stdlib/pull/405) ([elyscape](https://github.com/elyscape))
- (MODULES-560) Add new functions validate_numeric() and validate_integer(). [#375](https://github.com/puppetlabs/puppetlabs-stdlib/pull/375) ([poikilotherm](https://github.com/poikilotherm))

### Fixed

- Fix the 4.6.0 release date [#438](https://github.com/puppetlabs/puppetlabs-stdlib/pull/438) ([hunner](https://github.com/hunner))
- Fix acceptance tests for #405 [#433](https://github.com/puppetlabs/puppetlabs-stdlib/pull/433) ([cmurphy](https://github.com/cmurphy))
- Fix unsupported platforms variable name in tests [#432](https://github.com/puppetlabs/puppetlabs-stdlib/pull/432) ([cmurphy](https://github.com/cmurphy))
- File_line checks provided after param if no match is found [#431](https://github.com/puppetlabs/puppetlabs-stdlib/pull/431) ([bmjen](https://github.com/bmjen))
- Fix off-by-one error in validate_augeas_spec.rb that was causing rspec failure [#425](https://github.com/puppetlabs/puppetlabs-stdlib/pull/425) ([jeffcoat](https://github.com/jeffcoat))
- Fix issue with 1.8.7 and upcase [#418](https://github.com/puppetlabs/puppetlabs-stdlib/pull/418) ([cyberious](https://github.com/cyberious))
- Check for string before copying [#413](https://github.com/puppetlabs/puppetlabs-stdlib/pull/413) ([underscorgan](https://github.com/underscorgan))
- (MODULES-1771) Don't modify input to is_domain_name() [#412](https://github.com/puppetlabs/puppetlabs-stdlib/pull/412) ([seanmil](https://github.com/seanmil))
- Fix Travis builds [#411](https://github.com/puppetlabs/puppetlabs-stdlib/pull/411) ([elyscape](https://github.com/elyscape))
- (MODULES-1738) Don't modify the global seed in fqdn_rotate() [#406](https://github.com/puppetlabs/puppetlabs-stdlib/pull/406) ([elyscape](https://github.com/elyscape))
- (MODULES-1670) Do not match dotted-quad IP address as domain name [#404](https://github.com/puppetlabs/puppetlabs-stdlib/pull/404) ([roderickm](https://github.com/roderickm))
- Dirname typecheck [#369](https://github.com/puppetlabs/puppetlabs-stdlib/pull/369) ([rfugina](https://github.com/rfugina))

## [4.5.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.5.1) - 2015-01-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.5.0...4.5.1)

### Added

- MODULES-1606 add ability to pass array to delete for items to delete [#392](https://github.com/puppetlabs/puppetlabs-stdlib/pull/392) ([cyberious](https://github.com/cyberious))
- MODULES-444-Add concat multiple [#374](https://github.com/puppetlabs/puppetlabs-stdlib/pull/374) ([petems](https://github.com/petems))
- Allow array of pathes in validate_absolute_path [#372](https://github.com/puppetlabs/puppetlabs-stdlib/pull/372) ([poikilotherm](https://github.com/poikilotherm))
- Basename implementation [#368](https://github.com/puppetlabs/puppetlabs-stdlib/pull/368) ([rfugina](https://github.com/rfugina))

### Fixed

- FM-2131 Move to non temp directory for factor_dot_d [#401](https://github.com/puppetlabs/puppetlabs-stdlib/pull/401) ([cyberious](https://github.com/cyberious))
- Pull in RSpec 3.0 fixes. [#398](https://github.com/puppetlabs/puppetlabs-stdlib/pull/398) ([cyberious](https://github.com/cyberious))
- Change all to each [#396](https://github.com/puppetlabs/puppetlabs-stdlib/pull/396) ([hunner](https://github.com/hunner))
- FM-2130 Move cache file to non temp directory [#395](https://github.com/puppetlabs/puppetlabs-stdlib/pull/395) ([cyberious](https://github.com/cyberious))
- Fix bad check in test [#389](https://github.com/puppetlabs/puppetlabs-stdlib/pull/389) ([underscorgan](https://github.com/underscorgan))
- (MODULES-1582) File location placeholder [#377](https://github.com/puppetlabs/puppetlabs-stdlib/pull/377) ([petems](https://github.com/petems))
- ensure_resource: be more verbose in debug mode [#336](https://github.com/puppetlabs/puppetlabs-stdlib/pull/336) ([mklette](https://github.com/mklette))
- Correct function name in changelog [#301](https://github.com/puppetlabs/puppetlabs-stdlib/pull/301) ([3flex](https://github.com/3flex))

## [4.5.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.5.0) - 2014-12-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.4.0...4.5.0)

### Added

- FM-2020 SLES Support verified [#371](https://github.com/puppetlabs/puppetlabs-stdlib/pull/371) ([cyberious](https://github.com/cyberious))
- FM-1523: Added module summary to metadata.json [#370](https://github.com/puppetlabs/puppetlabs-stdlib/pull/370) ([jbondpdx](https://github.com/jbondpdx))
- (MODULES-1329) Allow member to look for array [#319](https://github.com/puppetlabs/puppetlabs-stdlib/pull/319) ([Spredzy](https://github.com/Spredzy))

### Fixed

- Need to convert strings and fixnums to arrays [#367](https://github.com/puppetlabs/puppetlabs-stdlib/pull/367) ([underscorgan](https://github.com/underscorgan))
- Make the range function work with integers [#365](https://github.com/puppetlabs/puppetlabs-stdlib/pull/365) ([dalen](https://github.com/dalen))
- (maint) Fix indentation of range function [#364](https://github.com/puppetlabs/puppetlabs-stdlib/pull/364) ([dalen](https://github.com/dalen))

## [4.4.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.4.0) - 2014-11-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.3.2...4.4.0)

### Added

- (QENG-1404) Segregate system testing gems [#356](https://github.com/puppetlabs/puppetlabs-stdlib/pull/356) ([justinstoller](https://github.com/justinstoller))
- MODULES-1413 Add ability for member to take numeric objects [#350](https://github.com/puppetlabs/puppetlabs-stdlib/pull/350) ([cyberious](https://github.com/cyberious))
- Add proper exception catching of Windows errors when CreateProcess does not succeed [#348](https://github.com/puppetlabs/puppetlabs-stdlib/pull/348) ([cyberious](https://github.com/cyberious))
- Added correct converstions for PB and EB. [#343](https://github.com/puppetlabs/puppetlabs-stdlib/pull/343) ([big-samantha](https://github.com/big-samantha))
- add require 'tempfile' to resolve a previously autorequired resource [#340](https://github.com/puppetlabs/puppetlabs-stdlib/pull/340) ([cyberious](https://github.com/cyberious))
- (MODULES-1221) Add file_line autorequire documentation [#300](https://github.com/puppetlabs/puppetlabs-stdlib/pull/300) ([trlinkin](https://github.com/trlinkin))

### Fixed

- Fix exclude windows test on ensure_package [#363](https://github.com/puppetlabs/puppetlabs-stdlib/pull/363) ([hunner](https://github.com/hunner))
- Correct type() logic [#358](https://github.com/puppetlabs/puppetlabs-stdlib/pull/358) ([hunner](https://github.com/hunner))
- Fix the unless for test cases on ensure_package and ensure_resource [#353](https://github.com/puppetlabs/puppetlabs-stdlib/pull/353) ([cyberious](https://github.com/cyberious))
- Fix validate_cmd, previous addition of SystemCallError only works for Puppet 3.7, previous version throw different exception.  Wrapping in generic Exception catch all [#349](https://github.com/puppetlabs/puppetlabs-stdlib/pull/349) ([cyberious](https://github.com/cyberious))
- Fix issue with ensure_request [#347](https://github.com/puppetlabs/puppetlabs-stdlib/pull/347) ([cyberious](https://github.com/cyberious))
- Spec_helper_acceptance fix provision section [#346](https://github.com/puppetlabs/puppetlabs-stdlib/pull/346) ([cyberious](https://github.com/cyberious))
- Fix logic issue with not including windows for testing ensure_packages as ruby and gem are not on the install path [#345](https://github.com/puppetlabs/puppetlabs-stdlib/pull/345) ([cyberious](https://github.com/cyberious))
- Fix testcases for Future Parser and resolve issue with values_at in assuming that it was dealing with a string [#344](https://github.com/puppetlabs/puppetlabs-stdlib/pull/344) ([cyberious](https://github.com/cyberious))
- ENTERPRISE-281 fixes issue with has_interfaces and case mismatch causing... [#334](https://github.com/puppetlabs/puppetlabs-stdlib/pull/334) ([cyberious](https://github.com/cyberious))
- MODULES-1248 Fix issue with not properly counting regex matches with leg... [#321](https://github.com/puppetlabs/puppetlabs-stdlib/pull/321) ([cyberious](https://github.com/cyberious))
- Fix strict_variables = true [#303](https://github.com/puppetlabs/puppetlabs-stdlib/pull/303) ([bobtfish](https://github.com/bobtfish))

## [4.3.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.3.2) - 2014-07-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.3.1...4.3.2)

## [4.3.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.3.1) - 2014-07-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.3.0...4.3.1)

### Fixed

- Correct metadata.json to match checksum [#297](https://github.com/puppetlabs/puppetlabs-stdlib/pull/297) ([hunner](https://github.com/hunner))

## [4.3.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.3.0) - 2014-07-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.2.2...4.3.0)

### Added

- AIX has no facter network support [#296](https://github.com/puppetlabs/puppetlabs-stdlib/pull/296) ([hunner](https://github.com/hunner))
- Start synchronizing module files [#290](https://github.com/puppetlabs/puppetlabs-stdlib/pull/290) ([cmurphy](https://github.com/cmurphy))
- stdlib 4 isn't compatible with PE 3.2 [#286](https://github.com/puppetlabs/puppetlabs-stdlib/pull/286) ([hunner](https://github.com/hunner))
- Increase resilience if lookup var comes back with nil object [#284](https://github.com/puppetlabs/puppetlabs-stdlib/pull/284) ([cyberious](https://github.com/cyberious))
- Add windows support and work around issue with SCP_TO on windows systems [#283](https://github.com/puppetlabs/puppetlabs-stdlib/pull/283) ([cyberious](https://github.com/cyberious))
- Add windows Nodesets and remove Beaker from Gemfile [#278](https://github.com/puppetlabs/puppetlabs-stdlib/pull/278) ([cyberious](https://github.com/cyberious))
- Add private() function [#270](https://github.com/puppetlabs/puppetlabs-stdlib/pull/270) ([raphink](https://github.com/raphink))

### Fixed

- Gotta single quote yer typewriter buttons [#293](https://github.com/puppetlabs/puppetlabs-stdlib/pull/293) ([hunner](https://github.com/hunner))
- Need quotes for spaces in path [#292](https://github.com/puppetlabs/puppetlabs-stdlib/pull/292) ([hunner](https://github.com/hunner))
- has_ip_network doesn't work on windows either [#291](https://github.com/puppetlabs/puppetlabs-stdlib/pull/291) ([hunner](https://github.com/hunner))
- Disable windows network stuff and quote path [#289](https://github.com/puppetlabs/puppetlabs-stdlib/pull/289) ([hunner](https://github.com/hunner))
- Not enough escape velocity [#288](https://github.com/puppetlabs/puppetlabs-stdlib/pull/288) ([hunner](https://github.com/hunner))
- Fix pe facts and slashes [#287](https://github.com/puppetlabs/puppetlabs-stdlib/pull/287) ([hunner](https://github.com/hunner))
- Windows needs a tmpdir path [#281](https://github.com/puppetlabs/puppetlabs-stdlib/pull/281) ([hunner](https://github.com/hunner))
- Augeas isn't present on windows [#280](https://github.com/puppetlabs/puppetlabs-stdlib/pull/280) ([hunner](https://github.com/hunner))
- (FM-1587) Fix test issues on solaris 10 [#276](https://github.com/puppetlabs/puppetlabs-stdlib/pull/276) ([hunner](https://github.com/hunner))

## [4.2.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.2.2) - 2014-06-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.2.2...4.2.2)

## [3.2.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.2.2) - 2014-06-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.2.1...3.2.2)

### Added

- (PUP-2571) add 'before' functionality to file_line [#256](https://github.com/puppetlabs/puppetlabs-stdlib/pull/256) ([stbenjam](https://github.com/stbenjam))
- (MODULES-905) Add bool2str() and camelcase() for string manipulation [#255](https://github.com/puppetlabs/puppetlabs-stdlib/pull/255) ([mckern](https://github.com/mckern))

### Fixed

- Further fixes to tests for 14.04. [#265](https://github.com/puppetlabs/puppetlabs-stdlib/pull/265) ([apenney](https://github.com/apenney))
- Fixes for PE3.3. [#264](https://github.com/puppetlabs/puppetlabs-stdlib/pull/264) ([apenney](https://github.com/apenney))
- (MODULES-905) Narrow the confinement in bool2str [#258](https://github.com/puppetlabs/puppetlabs-stdlib/pull/258) ([mckern](https://github.com/mckern))
- Revert "Merge pull request #256 from stbenjam/2571-before" [#257](https://github.com/puppetlabs/puppetlabs-stdlib/pull/257) ([apenney](https://github.com/apenney))

## [4.2.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.2.1) - 2014-05-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.2.0...4.2.1)

## [4.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.2.0) - 2014-05-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.2.1...4.2.0)

### Added

- Adding more spec coverage [#247](https://github.com/puppetlabs/puppetlabs-stdlib/pull/247) ([hunner](https://github.com/hunner))
- Add more specs [#244](https://github.com/puppetlabs/puppetlabs-stdlib/pull/244) ([hunner](https://github.com/hunner))
- Add beaker tests for functions. [#243](https://github.com/puppetlabs/puppetlabs-stdlib/pull/243) ([hunner](https://github.com/hunner))
- Add beaker framework. [#234](https://github.com/puppetlabs/puppetlabs-stdlib/pull/234) ([apenney](https://github.com/apenney))
- Allow concat to take non-array second parameters [#222](https://github.com/puppetlabs/puppetlabs-stdlib/pull/222) ([mfoo](https://github.com/mfoo))

### Fixed

- Fix the stdlib functions that fail tests [#251](https://github.com/puppetlabs/puppetlabs-stdlib/pull/251) ([hunner](https://github.com/hunner))
- Add the missing shebangs and fix the wrong ones [#248](https://github.com/puppetlabs/puppetlabs-stdlib/pull/248) ([averi](https://github.com/averi))
- Fix the validate_augeas beaker tests [#245](https://github.com/puppetlabs/puppetlabs-stdlib/pull/245) ([hunner](https://github.com/hunner))
- Adjust the regular expression for facts. [#242](https://github.com/puppetlabs/puppetlabs-stdlib/pull/242) ([apenney](https://github.com/apenney))
- Make sure location_for is used when installing Puppet. [#233](https://github.com/puppetlabs/puppetlabs-stdlib/pull/233) ([apenney](https://github.com/apenney))
- Readd location_for [#232](https://github.com/puppetlabs/puppetlabs-stdlib/pull/232) ([apenney](https://github.com/apenney))
- hash example has misplaced comas [#221](https://github.com/puppetlabs/puppetlabs-stdlib/pull/221) ([jtreminio](https://github.com/jtreminio))

## [3.2.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.2.1) - 2014-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.1.0...3.2.1)

### Added

- (PUP-1459) Add support for root_home on OS X 10.9 [#215](https://github.com/puppetlabs/puppetlabs-stdlib/pull/215) ([blkperl](https://github.com/blkperl))
- (#23381) add is_bool() function [#211](https://github.com/puppetlabs/puppetlabs-stdlib/pull/211) ([jhoblitt](https://github.com/jhoblitt))
- Add rake tasks to validate and lint files and check with Travis [#208](https://github.com/puppetlabs/puppetlabs-stdlib/pull/208) ([ghoneycutt](https://github.com/ghoneycutt))
- (#16498) Added unit test for loadyaml function. [#185](https://github.com/puppetlabs/puppetlabs-stdlib/pull/185) ([lmello](https://github.com/lmello))
- Add delete_values() and delete_undef_values() functions [#166](https://github.com/puppetlabs/puppetlabs-stdlib/pull/166) ([ptomulik](https://github.com/ptomulik))
- Adding base64 function [#159](https://github.com/puppetlabs/puppetlabs-stdlib/pull/159) ([fiddyspence](https://github.com/fiddyspence))
- [#20862] Add functions to validate ipv4 and ipv6 addresses [#158](https://github.com/puppetlabs/puppetlabs-stdlib/pull/158) ([wfarr](https://github.com/wfarr))
- (#20684) Add array comparison functions, difference, intersection and un... [#155](https://github.com/puppetlabs/puppetlabs-stdlib/pull/155) ([AlexCline](https://github.com/AlexCline))
- add a "step" argument to range() [#56](https://github.com/puppetlabs/puppetlabs-stdlib/pull/56) ([hakamadare](https://github.com/hakamadare))

### Fixed

- calling rspec directly makes is_function_available.rb not pass ruby -c [#203](https://github.com/puppetlabs/puppetlabs-stdlib/pull/203) ([dreamlibrarian](https://github.com/dreamlibrarian))
- Fix the tests on osx [#200](https://github.com/puppetlabs/puppetlabs-stdlib/pull/200) ([bobtfish](https://github.com/bobtfish))
- delete_undef_values function fix bug #20681 [#184](https://github.com/puppetlabs/puppetlabs-stdlib/pull/184) ([lmello](https://github.com/lmello))
- delete_values() fix bug #20681. [#182](https://github.com/puppetlabs/puppetlabs-stdlib/pull/182) ([lmello](https://github.com/lmello))
- Minor grammar fix [#181](https://github.com/puppetlabs/puppetlabs-stdlib/pull/181) ([nibalizer](https://github.com/nibalizer))
-  bug # 20681 delete() function should not remove elements from original list [#178](https://github.com/puppetlabs/puppetlabs-stdlib/pull/178) ([lmello](https://github.com/lmello))
- (maint) fix RST formatting of has_interface_with code examples [#175](https://github.com/puppetlabs/puppetlabs-stdlib/pull/175) ([floatingatoll](https://github.com/floatingatoll))
- minor corrections to delete_values() [#170](https://github.com/puppetlabs/puppetlabs-stdlib/pull/170) ([ptomulik](https://github.com/ptomulik))
- Fix validate_slength, arg.length should be args[0].length [#169](https://github.com/puppetlabs/puppetlabs-stdlib/pull/169) ([hdeheer](https://github.com/hdeheer))
- ensure_resource: fix documentation typo [#165](https://github.com/puppetlabs/puppetlabs-stdlib/pull/165) ([bootc](https://github.com/bootc))
- Trivial documentation fix for upcase function. [#157](https://github.com/puppetlabs/puppetlabs-stdlib/pull/157) ([rohanrns](https://github.com/rohanrns))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.1.0) - 2013-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.0.2...4.1.0)

### Added

- (#20548) Allow an array of resource titles to be passed into the ensure_... [#152](https://github.com/puppetlabs/puppetlabs-stdlib/pull/152) ([AlexCline](https://github.com/AlexCline))
- Add a dirname function [#150](https://github.com/puppetlabs/puppetlabs-stdlib/pull/150) ([raphink](https://github.com/raphink))

## [4.0.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.0.2) - 2013-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.0.1...4.0.2)

### Added

- adds compatibility matrix [#144](https://github.com/puppetlabs/puppetlabs-stdlib/pull/144) ([ghoneycutt](https://github.com/ghoneycutt))

## [4.0.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.0.1) - 2013-04-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/4.0.0...4.0.1)

## [4.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.0.0) - 2013-04-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.2.0...4.0.0)

### Added

- Add floor function implementation and unit tests [#135](https://github.com/puppetlabs/puppetlabs-stdlib/pull/135) ([willaerk](https://github.com/willaerk))
- (#19272) Add has_element() function [#130](https://github.com/puppetlabs/puppetlabs-stdlib/pull/130) ([jhoblitt](https://github.com/jhoblitt))
- Add validate_augeas command [#114](https://github.com/puppetlabs/puppetlabs-stdlib/pull/114) ([raphink](https://github.com/raphink))

### Fixed

- (19864) num2bool match fix [#139](https://github.com/puppetlabs/puppetlabs-stdlib/pull/139) ([hakamadare](https://github.com/hakamadare))
- (maint) Fix getparam() spec failure on MRI 1.8 [#125](https://github.com/puppetlabs/puppetlabs-stdlib/pull/125) ([jeffmccune](https://github.com/jeffmccune))
- Fix typo in travis configuration [#122](https://github.com/puppetlabs/puppetlabs-stdlib/pull/122) ([jeffmccune](https://github.com/jeffmccune))
- maint: style guideline fixes [#112](https://github.com/puppetlabs/puppetlabs-stdlib/pull/112) ([dalen](https://github.com/dalen))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.2.0) - 2012-11-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.6.0...3.2.0)

## [2.6.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.6.0) - 2012-11-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.1.1...2.6.0)

## [3.1.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.1.1) - 2012-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.5.1...3.1.1)

### Fixed

- (maint) Fix spec failures resulting from Facter API changes between 1.x and 2.x [#100](https://github.com/puppetlabs/puppetlabs-stdlib/pull/100) ([jeffmccune](https://github.com/jeffmccune))

## [2.5.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.5.1) - 2012-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.1.0...2.5.1)

## [3.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.1.0) - 2012-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.5.0...3.1.0)

## [2.5.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.5.0) - 2012-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.0.1...2.5.0)

### Added

- Add pe facts to stdlib [#99](https://github.com/puppetlabs/puppetlabs-stdlib/pull/99) ([haus](https://github.com/haus))

## [3.0.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.0.1) - 2012-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/3.0.0...3.0.1)

### Fixed

- (Maint) Fix mis-use of rvalue functions as statements [#91](https://github.com/puppetlabs/puppetlabs-stdlib/pull/91) ([jeffmccune](https://github.com/jeffmccune))
- Revert "Merge branch 'hkenney-ticket/master/2157_remove_facts_dot_d'" [#89](https://github.com/puppetlabs/puppetlabs-stdlib/pull/89) ([jeffmccune](https://github.com/jeffmccune))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/3.0.0) - 2012-08-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.4.0...3.0.0)

### Added

- Add function ensure_resource and defined_with_params [#86](https://github.com/puppetlabs/puppetlabs-stdlib/pull/86) ([bodepd](https://github.com/bodepd))

### Fixed

- Ensure resource attempt 2 [#87](https://github.com/puppetlabs/puppetlabs-stdlib/pull/87) ([bodepd](https://github.com/bodepd))

## [2.4.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.4.0) - 2012-08-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.3.3...2.4.0)

### Added

- Add support for a 'match' parameter to file_line [#75](https://github.com/puppetlabs/puppetlabs-stdlib/pull/75) ([cprice404](https://github.com/cprice404))

### Fixed

- Fix up 2.3.x for new scope [#80](https://github.com/puppetlabs/puppetlabs-stdlib/pull/80) ([jeffmccune](https://github.com/jeffmccune))
- (#2157) Make facts_dot_d compatible with external facts [#77](https://github.com/puppetlabs/puppetlabs-stdlib/pull/77) ([HAIL9000](https://github.com/HAIL9000))

## [2.3.3](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.3.3) - 2012-05-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.3.2...2.3.3)

### Fixed

- fix regression in #11017 properly [#70](https://github.com/puppetlabs/puppetlabs-stdlib/pull/70) ([duritong](https://github.com/duritong))

## [2.3.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.3.2) - 2012-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.1.3...2.3.2)

### Fixed

- Make file_line default to ensure => present [#69](https://github.com/puppetlabs/puppetlabs-stdlib/pull/69) ([jeffmccune](https://github.com/jeffmccune))

## [2.1.3](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.1.3) - 2012-03-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.3.1...2.1.3)

## [2.3.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.3.1) - 2012-03-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/2.3.0...2.3.1)

### Fixed

- (#13091) Fix LoadError exception with puppet apply [#50](https://github.com/puppetlabs/puppetlabs-stdlib/pull/50) ([jeffmccune](https://github.com/jeffmccune))

## [2.3.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/2.3.0) - 2012-03-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.2.1...2.3.0)

### Added

- (#12357) Add ability to display an error message from validate_re [#47](https://github.com/puppetlabs/puppetlabs-stdlib/pull/47) ([jeffmccune](https://github.com/jeffmccune))
- (#12357) Add validate_absolute_path() function [#46](https://github.com/puppetlabs/puppetlabs-stdlib/pull/46) ([jeffmccune](https://github.com/jeffmccune))
- (#12776) Added validate_slength function and rspec test [#37](https://github.com/puppetlabs/puppetlabs-stdlib/pull/37) ([fiddyspence](https://github.com/fiddyspence))
- implement #11017 - make file_line type ensurable [#36](https://github.com/puppetlabs/puppetlabs-stdlib/pull/36) ([duritong](https://github.com/duritong))
- New str2saltedsha512 function for OS X Passwords [#27](https://github.com/puppetlabs/puppetlabs-stdlib/pull/27) ([glarizza](https://github.com/glarizza))
- (#11607) Add Rakefile to enable spec testing [#26](https://github.com/puppetlabs/puppetlabs-stdlib/pull/26) ([jeffmccune](https://github.com/jeffmccune))

### Fixed

- (#12357) Fix broken compatibility with Puppet 2.6 [#49](https://github.com/puppetlabs/puppetlabs-stdlib/pull/49) ([jeffmccune](https://github.com/jeffmccune))
- (#12357) Fix root_home fact on Windows [#45](https://github.com/puppetlabs/puppetlabs-stdlib/pull/45) ([jeffmccune](https://github.com/jeffmccune))
- (#12357) Make facter_dot_d look in Puppet[:confdir]/facts.d [#44](https://github.com/puppetlabs/puppetlabs-stdlib/pull/44) ([jeffmccune](https://github.com/jeffmccune))
- (#11873) time function spec failure on Fixnum matcher [#28](https://github.com/puppetlabs/puppetlabs-stdlib/pull/28) ([kbarber](https://github.com/kbarber))

## [v2.2.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.2.1) - 2011-12-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.1.2...v2.2.1)

## [v2.1.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.1.2) - 2011-12-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.2.0...v2.1.2)

### Added

- (#10802) add new function get_module_path [#25](https://github.com/puppetlabs/puppetlabs-stdlib/pull/25) ([bodepd](https://github.com/bodepd))

## [v2.2.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.2.0) - 2011-11-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.1.1...v2.2.0)

### Added

- (#9859) Add root_home fact and tests [#17](https://github.com/puppetlabs/puppetlabs-stdlib/pull/17) ([jeffmccune](https://github.com/jeffmccune))
- (#8925) Added new function called 'get_certificate' for retrieving [#13](https://github.com/puppetlabs/puppetlabs-stdlib/pull/13) ([kbarber](https://github.com/kbarber))

### Fixed

- (#10285) Refactor json to use pson instead. [#19](https://github.com/puppetlabs/puppetlabs-stdlib/pull/19) ([nanliu](https://github.com/nanliu))

## [v2.1.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.1.1) - 2011-08-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.1.0...v2.1.1)

## [v2.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.1.0) - 2011-08-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v2.0.0...v2.1.0)

### Added

- (#9080) Add facts from /etc/puppetlabs/facts.d [#14](https://github.com/puppetlabs/puppetlabs-stdlib/pull/14) ([jeffmccune](https://github.com/jeffmccune))

## [v2.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v2.0.0) - 2011-08-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v1.1.0...v2.0.0)

## [v1.1.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v1.1.0) - 2011-08-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v1.0.0...v1.1.0)

## [v1.0.0](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v1.0.0) - 2011-08-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/v0.1.7...v1.0.0)

## [v0.1.7](https://github.com/puppetlabs/puppetlabs-stdlib/tree/v0.1.7) - 2011-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.6...v0.1.7)

## [0.1.6](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.6) - 2011-06-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.5...0.1.6)

## [0.1.5](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.5) - 2011-06-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.4...0.1.5)

## [0.1.4](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.4) - 2011-05-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.3...0.1.4)

## [0.1.3](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.3) - 2011-05-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.2...0.1.3)

## [0.1.2](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.2) - 2011-05-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/0.1.1...0.1.2)

## [0.1.1](https://github.com/puppetlabs/puppetlabs-stdlib/tree/0.1.1) - 2011-05-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-stdlib/compare/b305bbeac7a0560a271f34026f936b88b88da477...0.1.1)
