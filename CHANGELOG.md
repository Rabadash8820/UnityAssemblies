# Changelog

All notable changes to the [Unity3D NuGet package](https://www.nuget.org/packages/Unity3D/) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Upcoming

## 2.0.0 - 2022-06-01

### Added

- Internal: this changelog!

### Changed

- Package icon to use new Unity logo

## 2.0.0-rc2 - 2022-05-30

### Added

- `UnityVersionMajor`, `UnityVersionMinor`, `UnityVersionPatch`, and `UnityVersionAsNumber` props for manipulation of Unity versions as numbers
- Documentation on using the numeric Unity version properties in MSBuild files
- Support documentation to main README
- Internal: test projects for Tech Stream Unity releases up through 2022.1

### Changed

- Updated usage notes in all Readme documents
- Updated available short-hand properties in all Readme documents
- `OSInstallRoot` to `OSInstallRootPath` and `UnityInstallRoot` to `UnityInstallRootPath`, to be consistent with other prop names
- Assembly short-hand properties now defined conditionally based on `UnityVersion`

## [2.0.0-rc1] - 2022-05-21

### Added

- Many new short-hand properties, with more consistent naming (relative paths end in `Dir` or `Assembly`, absolute paths end in `Path`)

### Changed

- Unity version can now be parsed automatically from the `ProjectVersion.txt` file in a Unity project, if not set explicitly (requires `UnityProjectPath` to be set)
- Reference Include paths no longer need to start with `$(UnityInstallRoot)\$(UnityVersion)`\. Most paths will now use a single short-hand property.
- If neither `UnityVersion` nor `UnityProjectPath` is explicitly set, then `UnityVersion` is set to a constant string to explain the issue.
- `UnityVersion` or `UnityProjectPath` must be set in a `Directory.Build.props`, not the project file.
- ASCII art in package readme.txt to use new Unity logo

## [1.7.0] - 2020-12-31

### Added

- Root paths for Linux

## [1.6.0] - 2020-12-17

### Added

- Suggested `TargetFramework` notes in main README
- Internal: tests for Unity 2020.2.x

### Changed

- Contributor Covenant to v2.0
- Clarified which Unity versions are officially supported in main README

### Fixed

- Root paths for MacOS (thanks to input from GitHub user [Sorrowful-free](https://github.com/Sorrowful-free))

## [1.5.0] - 2020-08-24

### Added

- Short-hand properties for iOS- and Android-specific assemblies

## [1.4.0] - 2020-07-27

### Added

- Short-hand property for Newtonsoft.Json
- Internal: test projects for Unity 2019.4.x and 2020.1.x

### Changed

- Documentation about which Unity packages are necessary for which MSBuild short-hand properties

## [1.3.1] - 2020-03-11

### Added

- Internal: test projects for Unity 2019.3.x

### Fixed

- Some property conditions in the main `.props` file

## [1.3.0] - 2019-12-23

### Added

- Short-hand properties for more locations, including assemblies within a Unity project folder
- Internal: some test Unity scenes in various Unity versions, for testing builds that reference Library/ or Asset Store assemblies
- README instructions on removing the default `UnityEngine.dll` reference
- README instructions on referencing assemblies in Packages, Asset Store assets, and Unity modules

### Changed

- Internal: test solution is now more flexible, containing fewer projects that can each be built with a different target framework and version of Unity
- Main README's usage section now better organized into sub-sections

### Removed

- Unnecessary `UNITY_ASSERTIONS` define

### Fixed

- Missing `UnityModulesPath` property :facepalm:

## [1.2.0] - 2019-08-21

### Changed

- All short-hand assembly properties now use the same casing as the referenced DLL files (e.g., `UnityEngineUIPath`, not `UnityEngineUiPath`)

### Added

- New `UnityManagedPath` and `UnityExtensionsPath` properties to clean up the props file

## [1.1.0] - 2019-06-20

First stable release.

## [1.1.0-rc2] - 2019-06-20

Final preparations for first stable version.

## [1.1.0-rc1] - 2019-06-19

### Changed

References are now added as `Reference` items, not magic MSBuild properties.

## [1.0.0-rc1] - 2019-06-17

Initial package release.
