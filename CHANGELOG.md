# Changelog

All notable changes to the [Unity3D NuGet package](https://www.nuget.org/packages/Unity3D/) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.1.0 - 2025-12-01

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v3.1.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/3.1.0).

### Changed in in 3.1.0

- Change the hard-coded value for `UnityVersion` when no Unity version is set from `SET_VERSION_OR_PROJECT` to a more informative `PLEASE_SET_UNITY_VERSION_OR_PROJECT_PATH`
- GitHub Releases starting with this version are immutable to protect dependents against supply chain attacks

### Fixed in 3.1.0

- Gracefully handle missing `$(UnityProjectPath)\ProjectVersion.txt` paths by setting `UnityVersion` to the hard-coded value: `UNITY_PROJECT_VERSION_TXT_NOT_FOUND`

## 3.0.1 - 2025-05-22

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v3.0.1) or [nuget.org](https://www.nuget.org/packages/Unity3D/3.0.1).

### Added in 3.0.1

- Internal: test project for Unity 6.1

### Fixed in 3.0.1

- `NUnitAssembly` value for _all_ supported Unity versions

## 3.0.0 - 2024-07-16

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v3.0.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/3.0.0).

### Added in 3.0.0

- Internal: test project for Unity 6 Beta release

### Fixed in 3.0.0

- `NUnitAssembly` value for Unity 6+ projects

## 3.0.0-rc1 - 2024-07-16

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v3.0.0-rc1) or [nuget.org](https://www.nuget.org/packages/Unity3D/3.0.0-rc1).

### Changed in 3.0.0-rc1

- All Unity module assemblies are now referenced by default (including the one named `UnityEngine.dll`), rather than the monolithic `UnityEngine.dll`,
  so projects don't have to remove the default references in order to work with UPM package assemblies.
- Default references can be easily toggled off by setting the `IncludeDefaultUnityAssemblyReferences` property to `False`
- All short-hand properties and default references are now added by a `.targets` file rather than `.props`,
  removing the need to move `UnityVersion` and/or `UnityProjectPath` property definitions to a `Directory.Build.props` file

### Removed in 3.0.0-rc1

- `UnityAnalyticsStandardEvents*` MSBuild properties for Unity 2020.3+ projects, since those paths have never existed on those Unity versions

## 2.1.3 - 2023-08-16

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.1.3) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.1.3).

### Changed in 2.1.3

- Internal: Added a `--no-pack` option to the publish script for easier testing
- Split up the main Readme into multiple Markdown files under `docs/` so that different documentation versions can exist side-by-side in perpetuity

### Fixed in 2.1.3

- `$(NunitAssembly)` property now uses `net*` rather than `net35` to account for later versions of Unity's "Custom NUnit" package that use a `net40` version of the assembly

### Added in 2.1.3

- README documentation about using this package in CI/CD Pipelines
- Internal: test projects for Tech Stream Unity releases up through 2023.2

## 2.1.2 - 2023-04-26

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.1.2) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.1.2).

### Fixed in 2.1.2

- The relative path in the package `readme.txt` file to be based off `$(MSBuildProjectDirectory)`

## 2.1.1 - 2023-02-17

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.1.1) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.1.1).

### Fixed in 2.1.1

- The `Directory.Build.props` snippet's syntax in the package `readme.txt` file

## 2.1.0 - 2023-01-27

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.1.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.1.0).

### Changed in 2.1.0

- Newtonsoft.Json short-hand properties now use the path in Unity's install folder for Unity 2022.2+
- All short-hand properties for UPM assemblies now include `@` in the name, to prevent name conflicts for assemblies with "nested namespace" names

### Removed in 2.1.0

- Readme content specifically for 1.x versions of this package, as they are now deprecated

## 2.0.1 - 2022-06-01

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.0.1) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.0.1).

### Changed in 2.0.1

- All documentation and package details now reference the Rabadash8820 GitHub repository (transferred from DerploidEntertainment)

## 2.0.0 - 2022-06-01

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.0.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.0.0).

### Added in 2.0.0

- Internal: this changelog!

### Changed in 2.0.0

- Package icon to use new Unity logo

## 2.0.0-rc2 - 2022-05-30

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.0.0-rc2) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.0.0-rc2).

### Added in 2.0.0-rc2

- `UnityVersionMajor`, `UnityVersionMinor`, `UnityVersionPatch`, and `UnityVersionAsNumber` props for manipulation of Unity versions as numbers
- Documentation on using the numeric Unity version properties in MSBuild files
- Support documentation to main README
- Internal: test projects for Tech Stream Unity releases up through 2022.1

### Changed in 2.0.0-rc2

- Updated usage notes in all Readme documents
- Updated available short-hand properties in all Readme documents
- `OSInstallRoot` to `OSInstallRootPath` and `UnityInstallRoot` to `UnityInstallRootPath`, to be consistent with other prop names
- Assembly short-hand properties now defined conditionally based on `UnityVersion`

## [2.0.0-rc1] - 2022-05-21

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v2.0.0-rc1) or [nuget.org](https://www.nuget.org/packages/Unity3D/2.0.0-rc1).

### Added in 2.0.0-rc1

- Many new short-hand properties, with more consistent naming (relative paths end in `Dir` or `Assembly`, absolute paths end in `Path`)

### Changed in 2.0.0-rc1

- Unity version can now be parsed automatically from the `ProjectVersion.txt` file in a Unity project, if not set explicitly (requires `UnityProjectPath` to be set)
- Reference Include paths no longer need to start with `$(UnityInstallRoot)\$(UnityVersion)`\. Most paths will now use a single short-hand property.
- If neither `UnityVersion` nor `UnityProjectPath` is explicitly set, then `UnityVersion` is set to a constant string to explain the issue.
- `UnityVersion` or `UnityProjectPath` must be set in a `Directory.Build.props`, not the project file.
- ASCII art in package readme.txt to use new Unity logo

## [1.7.0] - 2020-12-31

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v1.7.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/1.7.0).

### Added in 1.7.0

- Root paths for Linux

## [1.6.0] - 2020-12-17

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v1.6.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/1.6.0).

### Added in 1.6.0

- Suggested `TargetFramework` notes in main README
- Internal: tests for Unity 2020.2.x

### Changed in 1.6.0

- Contributor Covenant to v2.0
- Clarified which Unity versions are officially supported in main README

### Fixed in 1.6.0

- Root paths for MacOS (thanks to input from GitHub user [Sorrowful-free](https://github.com/Sorrowful-free))

## [1.5.0] - 2020-08-24

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v1.5.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/1.5.0).

### Added in 1.5.0

- Short-hand properties for iOS- and Android-specific assemblies

## [1.4.0] - 2020-07-27

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v1.4.0) or [nuget.org](https://www.nuget.org/packages/Unity3D/1.4.0).

### Added in 1.4.0

- Short-hand property for Newtonsoft.Json
- Internal: test projects for Unity 2019.4.x and 2020.1.x

### Changed in 1.4.0

- Documentation about which Unity packages are necessary for which MSBuild short-hand properties

## [1.3.1] - 2020-03-11

Download from [GitHub Releases](https://github.com/Rabadash8820/UnityAssemblies/releases/tag/v1.3.1) or [nuget.org](https://www.nuget.org/packages/Unity3D/1.3.1).

### Added in 1.3.1

- Internal: test projects for Unity 2019.3.x

### Fixed in 1.3.1

- Some property conditions in the main `.props` file

## [1.3.0] - 2019-12-23

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.3.0).

### Added in 1.3.0

- Short-hand properties for more locations, including assemblies within a Unity project folder
- Internal: some test Unity scenes in various Unity versions, for testing builds that reference Library/ or Asset Store assemblies
- README instructions on removing the default `UnityEngine.dll` reference
- README instructions on referencing assemblies in Packages, Asset Store assets, and Unity modules

### Changed in 1.3.0

- Internal: test solution is now more flexible, containing fewer projects that can each be built with a different target framework and version of Unity
- Main README's usage section now better organized into sub-sections

### Removed in 1.3.0

- Unnecessary `UNITY_ASSERTIONS` define

### Fixed in 1.3.0

- Missing `UnityModulesPath` property :facepalm:

## [1.2.0] - 2019-08-21

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.2.0).

### Changed in 1.2.0

- All short-hand assembly properties now use the same casing as the referenced DLL files (e.g., `UnityEngineUIPath`, not `UnityEngineUiPath`)

### Added in 1.2.0

- New `UnityManagedPath` and `UnityExtensionsPath` properties to clean up the props file

## [1.1.0] - 2019-06-20

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.1.0).

First stable release.

## [1.1.0-rc2] - 2019-06-20

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.1.0-rc2).

Final preparations for first stable version.

## [1.1.0-rc1] - 2019-06-19

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.1.0-rc1).

### Changed in 1.1.0-rc1

References are now added as `Reference` items, not magic MSBuild properties.

## [1.0.0-rc1] - 2019-06-17

Download from [nuget.org](https://www.nuget.org/packages/Unity3D/1.0.0-rc1).

Initial package release.
