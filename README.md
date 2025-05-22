# Unity3D NuGet Package

![Unity logo, trademarked by Unity Technologies](./nupkg/icon.png)

[![NuGet package](https://img.shields.io/nuget/v/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![NuGet downloads](https://img.shields.io/packagecontrol/dd/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![Changelog (currently v3.0.1)](https://img.shields.io/badge/changelog-v3.0.1-blue.svg)](./CHANGELOG.md)
[![License](https://img.shields.io/github/license/Rabadash8820/UnityAssemblies.svg)](./LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](./CODE_OF_CONDUCT.md)
[![Issues closed](https://img.shields.io/github/issues-closed/Rabadash8820/UnityAssemblies)](https://github.com/Rabadash8820/UnityAssemblies/issues)

This repository contains the source code for the [`Unity3D` NuGet package](https://www.nuget.org/packages/Unity3D).

It allows .NET developers to reference assemblies of the Unity game engine (e.g., `UnityEngine.dll`) as NuGet packages.

If you find this package useful, consider supporting its development!

<a href="https://www.buymeacoffee.com/shundra882n" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 40px !important;width: 145px !important;" ></a>

_Unity® and the Unity logo are trademarks of Unity Technologies._

## Contents

- [Usage](#usage)
- [Why Another NuGet Package for Unity?](#why-another-nuget-package-for-unity)
- [Support](#support)
- [Contributing](#contributing)
- [License](#license)

## Usage

1. Install this NuGet package (See [MS Docs](https://docs.microsoft.com/en-us/nuget/consume-packages/overview-and-workflow#ways-to-install-a-nuget-package) for instructions)
2. For v3 of this NuGet package, add lines like the following to your .csproj file (or any imported MSBuild project file)
    ```xml
    <PropertyGroup>
        <UnityProjectPath>$(MSBuildProjectDirectory)\relative\path\to\UnityProject</UnityProjectPath>
        <!-- Or -->
        <UnityVersion>6000.0.49f1</UnityVersion>
    </PropertyGroup>
    ```

This satisfies the large majority of use cases.

For more advanced setups, see the full usage docs for your version of this NuGet package:

- [3.x](docs/v3/usage.md)
- [2.x](docs/v2/usage.md)
- [1.x](https://github.com/Rabadash8820/UnityAssemblies/blob/v1.7.0/README.md) (deprecated and no longer maintained)

## Why Another NuGet Package for Unity?

It's true, there are a number of good NuGet packages for Unity [already available on nuget.org](https://www.nuget.org/packages?q=unity3d).
Unfortunately, most of these packages are no longer updated and have various issues. Almost all of them fall into one of two categories:

1. **Containing the actual Unity binaries within the package.** These packages include:
    - [Unity3D.SDK](https://www.nuget.org/packages/Unity3D.SDK/) by amelkor (Deprecated)
    - [UnityEngine](https://www.nuget.org/packages/UnityEngine/) by Leanwork
    - [Unity3D.UnityEngine](https://www.nuget.org/packages/Unity3D.UnityEngine/) and [Unity3D.UnityEngine.UI](https://www.nuget.org/packages/Unity3D.UnityEngine.UI) by Dzmitry Lahoda
    - [UnityEngine5](https://www.nuget.org/packages/UnityEngine5/) by Taiyoung Jang
    - [Unity3D.Editor](https://www.nuget.org/packages/Unity3D.UnityEditor) by DavidTimber

    The problem with these packages (aside from the questionable legality of re-distributing Unity Technologies' binaries),
    is that a new version of the package must be pushed for each new version of Unity.
    When these packages stop being updated (which has happened in almost every case),
    then they are no longer useful because they don't allow you to program against the latest Unity APIs.
    Most of them do not have versions for Unity 2019.1+, and/or do not support the modern .NET Standard profiles.
2. **Containing some kind of script that adds references to assemblies from a particular installed version of Unity.**
    The main package in this category is [Unity3D.DLLs](https://www.nuget.org/packages/Unity3D.DLLs/) by Precision Mojo, LLC.
    This package uses a PowerShell script to add references to the latest version of Unity installed on a user's machine.
    which is powerful, as it theoretically makes the package forward-compatible with all versions of Unity yet to come.
    Unfortunately, this package has not been updated since 2013, meaning that many of the NuGet/PowerShell conventions that it relied upon are no longer supported in the newest versions of Visual Studio.
    Even when the package was current, it located the Unity assemblies in a clever but brittle manner that does not support the newer Unity Hub install locations,
    assumed that there was only one Unity installation per machine, and, more importantly, only worked on Windows (using the Windows registry).
    Not to mention, it's hard to collaborate on a project that always uses the latest installed Unity version on every contributor's machine.

Moreover, only Dzmitry Lahoda's and DavidTimber's packages seem to recognize the need for _other_ Unity assemblies besides just `UnityEngine`.
As more advanced Unity users will know, `UnityEngine.dll` doesn't contain everything.
Editor scripts also require a reference to `UnityEditor.dll`,
UI types like `Text` and `Button` require a reference to `UnityEngine.UI.dll`,
assemblies from Asset Store assets are stored in the project folder under `Assets/`,
and many types were split from the Unity assemblies as Unity broke up editor features into Packages.

Therefore, this NuGet package was designed with the following goals:

- Add Unity assembly references programmatically, so that the package is forward-compatible
- Add references via standard MSBuild tooling, rather than clunky scripts in unfamiliar or unsupported programming languages
- Allow devs to reference additional Unity assemblies with simple `Reference` items in the project file, rather than by calling some obscure script
- Provide short-hand MSBuild properties for the most common Unity assemblies, with paths that resolve on all dev platforms (Windows/MacOS/Linux)
- Require minimal configuration: just a Unity version or Unity project path, and optional path overrides for non-default setups

## Support

Issues and support questions may be posted on this repository's [Issues page](https://github.com/Rabadash8820/UnityAssemblies/issues).
Please check if your Issue has already been answered/addressed by a previous Issue before creating a new one. 🙏

## Contributing

Please refer to the [Contributing guide](./CONTRIBUTING.md).

## License

[MIT](./LICENSE)
