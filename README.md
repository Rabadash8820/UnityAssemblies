# Unity Assemblies

![Unity logo, trademarked by Unity Technologies](./icon.png)

[![NuGet package](https://img.shields.io/nuget/v/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![NuGet package](https://img.shields.io/packagecontrol/dd/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![NuGet package](https://img.shields.io/github/license/DerploidEntertainment/UnityAssemblies.svg)](./LICENSE)

This repository contains the source code for the [`Unity3D` NuGet package](https://www.nuget.org/packages/Unity3D).

`Unity3D` allows developers to effectively reference assemblies of the Unity game engine (e.g., `UnityEngine.dll`) as NuGet packages.

## Contents

- [Basic Usage](#basic-usage)
- [Why Another NuGet Package for Unity?](#why-another-nuget-package-for-unity)
- [Usage](#usage)
- [Available Short-Hand Assembly Properties](#available-short-hand-assembly-properties)
- [FAQ](#faq)
- [License](#license)

## Basic Usage

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <TargetFramework>netstandard2.0</TargetFramework>
        <UnityVersion>2019.2.6f1</UnityVersion>
    </PropertyGroup>
    <ItemGroup>
        <PackageReference Include="Unity3D" Version="1.2.0" />
    </ItemGroup>
</Project>
```

## Why Another NuGet Package for Unity?

Yes, it's true, there are a number of good NuGet packages already available on nuget.org. Unfortunately, most of these packages are no longer being updated and have a number of issues. Almost all of them fall into one of two categories:

1. **Containing the actual Unity binaries within the package.** These packages include [UnityEngine](https://www.nuget.org/packages/UnityEngine/) by Leanwork, [Unity3D.UnityEngine](https://www.nuget.org/packages/Unity3D.UnityEngine/) and [Unity3D.UnityEngine.UI](https://www.nuget.org/packages/Unity3D.UnityEngine.UI) by Dzmitry Lahoda, and [UnityEngine5](https://www.nuget.org/packages/UnityEngine5/) by Taiyoung Jang. The problem with these packages (aside from the questionable legality of re-distributing Unity Technologies' binaries), is that a new version of the package must be pushed for each new version of Unity. When these packages stop being updated (which has happened in almost every case), then they are no longer useful because they don't allow you to program against the latest Unity APIs. Most of them do not have versions for Unity 2019.1+, and/or do not support the new .NET Standard 2.0 profile.
2. **Containing some kind of script that adds references to assemblies from a particular installed version of Unity.** The main package in this category is [Unity3D.DLLs](https://www.nuget.org/packages/Unity3D.DLLs/) by Precision Mojo, LLC. This package uses a PowerShell script to add references to the latest version of Unity installed on a user's machine. This is powerful, as it theoretically makes the package forward-compatible with all versions of Unity yet to come. Unfortunately, this package has not been updated since 2013, meaning that many of the NuGet/PowerShell conventions that it relied upon are no longer supported in the newest versions of Visual Studio. Even when the package was current, it located the Unity assemblies in a brittle and complex (though clever) manner that does not support the newer Unity Hub install locations and, more importantly, only worked on Windows (involving the Windows registry).

Moreover, only Dzmitry Lahoda's packages seem to recognize the need for _other_ Unity assemblies besides just `UnityEngine`. As more advanced Unity users will know, `UnityEngine.dll` doesn't contain everything. Editor scripts also require a reference to `UnityEditor.dll`; UI types like `Text` and `Button` require a reference to `UnityEngine.UI.dll`; and the list goes on...

Thus, here at Derploid Entertainment, we created the `Unity3D` package with the following goals:

- Add the Unity assembly references programmatically, so that the package is forward-compatible
- Use built-in MSBuild tooling to add the references, rather than clunky scripts that may not be supported by future versions of Visual Studio
- Easily references additional Unity assemblies by adding simple `Reference` items to the project file, rather than calling some hard-to-find-and-use script
- All references must work cross-platform (on Windows/Mac)
- Configuration should be minimal: just a Unity version and an optional install location for non-default cases

## Usage

As shown in the basic example above, our package only requires a `UnityVersion` property to be up and running. `UnityVersion` must be a complete version string, in the format used by Unity Hub (the values boxed in red in the screenshot below).

![Unity version strings highlighted in the Unity Hub interface. For example, "2019.2.6f1"](./unity-versions.png)

To edit a project file in Visual Studio:

- **When targeting .NET Standard (recommended):** just double-click on the project in the Solution Explorer
- **When targeting .NET 4.x:** right click on the project in the Solution Explorer, click `Unload project`, then right click again to select `Edit <YourProject>.csproj`. When you're done editing the file, right click on the project again and select `Reload project`.

By default, we only add a reference to `UnityEngine.dll`, but there are several other Unity assemblies that you might need to reference for your project. These include, but are certinaly not limited to, `UnityEditor.dll` for writing custom editors, or `UnityEngine.UI.dll` for referencing UI types like `Text` and `Button`. To reference these assemblies, add `Reference` items to your `.csproj`, like so:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <!-- Same as above... -->
    <ItemGroup>
        <Reference Include="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEditorPath)" Private="false" />
        <Reference Include="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEngineUIPath)" Private="false" />
    </ItemGroup>
</Project>
```

Note the use of the `UnityInstallRoot`, `UnityVersion`, and `*Path` MSBuild properties. These properties spare you from having to remember the default Unity install path or the relative paths for any Unity assemblies, and they also let the references work across platforms (Windows/Mac). See below for a [list of short-hand assembly properties](#available-short-hand-assembly-properties) that we provide.

If you want to reference a Unity assembly for which there is no short-hand property, you can just hard-code the path into the `Reference` item yourself. We always recommend starting with the `$(UnityInstallRoot)\$(UnityVersion)\` properties though, as they let your project files build cross-platform, and let you edit your Unity version string in one place.

Because Unity Hub is the tool [recommended by Unity Technologies](https://docs.unity3d.com/Manual/GettingStartedInstallingUnity.html) for installing Unity, we check for Unity assemblies within the Hub's default install locations, as shown above. If you are not using Unity Hub, or you are using a non-default install location, just set `UnityInstallRoot` to a different path. For example, if you were using a Windows machine and your Unity versions were installed in a `Unity\` folder on your `V:` drive, then your `.csproj` would look something like:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <UnityVersion>2019.2.6f1</UnityVersion>
        <UnityInstallRoot>V:\Unity</UnityInstallRoot>
    </PropertyGroup>
    <!-- etc. -->
</Project>
```

**Warning: When changing the `UnityInstallRoot` property, it is up to you to keep the paths cross-platform.**

## Available Short-Hand Assembly Properties

| Property | Default value |
|----------|---------------|
| `OSInstallRoot` | `C:\Program Files` on Windows or `/Application` on Mac. |
| `UnityInstallRoot` | `$(OSInstallRoot)\Unity\Hub\Editor` |
| `UnityManagedPath` | `Editor\Data\Managed` |
| `UnityModulesPath` | `$(UnityManagedPath)\UnityEngine` |
| `UnityExtensionsPath` | `Editor\Data\UnityExtensions\Unity` |
| `UnityEnginePath` | `$(UnityManagedPath)\UnityEngine.dll` |
| `UnityEditorPath` | `$(UnityManagedPath)\UnityEditor.dll` |
| `UnityEngineUIPath` | `$(UnityExtensionsPath)\GUISystem\UnityEngine.UI.dll` |
| `UnityEngineTestRunnerPath` | `$(UnityExtensionsPath)\TestRunner\UnityEngine.TestRunner.dll` |

## FAQ

1. **How does this work?** This NuGet package [imports an MSBuild .props file](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package#including-msbuild-props-and-targets-in-a-package) into your project, which adds the various properties and `Reference` items at build time.
1. **Are the `Reference` paths really cross-platform?** Yes, but only paths that begin with the default `$(OSInstallRoot)` or `$(UnityInstallRoot)` properties. This works through a magical little combination of [MSBuild Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions?view=vs-2019) and the [`IsOsPlatform()` Property Function](https://docs.microsoft.com/en-us/visualstudio/msbuild/property-functions?view=vs-2019#msbuild-property-functions). Open the [Unity3D.props](./nupkg/build/Unity3D.props) file to see how we do it ;)
1. **Is this package officially maintained by Unity Technologies?** No, it is maintained by a few wild and crazy guys at Derploid Entertainment. However, we will be submitting this package to Unity Technologies as it gains traction, **_so that maybe we can finally have an officially supported NuGet package from Unity!_**
1. **If not, how is this legal?** We're not actually distributing the Unity assembly binaries, just MSBuild files that reference them. This NuGet package won't add anything if you don't actually have a version of Unity installed.

## License

[MIT](./LICENSE)
