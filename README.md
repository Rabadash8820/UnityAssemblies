# Unity Assemblies

![Unity logo, trademarked by Unity Technologies](./nupkg/icon.png)

[![NuGet package](https://img.shields.io/nuget/v/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![NuGet downloads](https://img.shields.io/packagecontrol/dd/Unity3D.svg)](https://nuget.org/packages/Unity3D)
[![License](https://img.shields.io/github/license/DerploidEntertainment/UnityAssemblies.svg)](./LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](./CODE_OF_CONDUCT.md)

This repository contains the source code for the [`Unity3D` NuGet package](https://www.nuget.org/packages/Unity3D).

`Unity3D` allows developers to effectively reference assemblies of the Unity game engine (e.g., `UnityEngine.dll`) as NuGet packages.

_Unity® and the Unity logo are trademarks of Unity Technologies._

## Contents

- [Basic Usage](#basic-usage)
- [Why Another NuGet Package for Unity?](#why-another-nuget-package-for-unity)
- [Usage](#usage)
  - [Editing the project file](#editing-the-project-file)
  - [Choosing a `TargetFramework`](#choosing-a-targetframework)
  - [Referencing additional Unity assemblies](#referencing-additional-unity-assemblies)
  - [Referencing assemblies stored in a Unity project](#referencing-assemblies-stored-in-a-unity-project)
  - [Referencing assemblies at non-default install locations](#referencing-assemblies-at-non-default-install-locations)
  - [Removing the default reference to UnityEngine.dll](#removing-the-default-reference-to-unityengine.dll)
  - [Referencing the Unity core modules](#referencing-the-unity-core-modules)
- [Available Short-Hand Assembly Properties](#available-short-hand-assembly-properties)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

## Basic Usage

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <TargetFramework>netstandard2.0</TargetFramework>
        <UnityVersion>2021.2.2f1</UnityVersion>
    </PropertyGroup>
    <ItemGroup>
        <PackageReference Include="Unity3D" Version="1.7.0" />
    </ItemGroup>
</Project>
```

## Why Another NuGet Package for Unity?

Yes, it's true, there are a number of good NuGet packages for Unity already available on [nuget.org](https://www.nuget.org/packages?q=unity3d). Unfortunately, most of these packages are no longer being updated and have a number of issues. Almost all of them fall into one of two categories:

1. **Containing the actual Unity binaries within the package.** These packages include [Unity3D.SDK](https://www.nuget.org/packages/Unity3D.SDK/) by amelkor, [UnityEngine](https://www.nuget.org/packages/UnityEngine/) by Leanwork, [Unity3D.UnityEngine](https://www.nuget.org/packages/Unity3D.UnityEngine/) and [Unity3D.UnityEngine.UI](https://www.nuget.org/packages/Unity3D.UnityEngine.UI) by Dzmitry Lahoda, and [UnityEngine5](https://www.nuget.org/packages/UnityEngine5/) by Taiyoung Jang. The problem with these packages (aside from the questionable legality of re-distributing Unity Technologies' binaries), is that a new version of the package must be pushed for each new version of Unity. When these packages stop being updated (which has happened in almost every case), then they are no longer useful because they don't allow you to program against the latest Unity APIs. Most of them do not have versions for Unity 2019.1+, and/or do not support the new .NET Standard 2.0 profile.
2. **Containing some kind of script that adds references to assemblies from a particular installed version of Unity.** The main package in this category is [Unity3D.DLLs](https://www.nuget.org/packages/Unity3D.DLLs/) by Precision Mojo, LLC. This package uses a PowerShell script to add references to the latest version of Unity installed on a user's machine. This is powerful, as it theoretically makes the package forward-compatible with all versions of Unity yet to come. Unfortunately, this package has not been updated since 2013, meaning that many of the NuGet/PowerShell conventions that it relied upon are no longer supported in the newest versions of Visual Studio. Even when the package was current, it located the Unity assemblies in a brittle and complex (though clever) manner that does not support the newer Unity Hub install locations, assumed that there was only one Unity installation per machine, and, more importantly, only worked on Windows (using the Windows registry).

Moreover, only Dzmitry Lahoda's packages seem to recognize the need for _other_ Unity assemblies besides just `UnityEngine`. As more advanced Unity users will know, `UnityEngine.dll` doesn't contain everything. Editor scripts also require a reference to `UnityEditor.dll`; UI types like `Text` and `Button` require a reference to `UnityEngine.UI.dll`; assemblies from Asset Store assets are stored in the project folder under `Assets/`; and more and more types from `UnityEngine.dll` are being split into other assemblies as Unity continues to break up editor features into Packages.

Thus, here at Derploid Entertainment, we created the `Unity3D` package with the following goals:

- Add the Unity assembly references programmatically, so that the package is forward-compatible
- Use standard MSBuild tooling to add the references, rather than clunky scripts written in another language that may not be supported by future versions of Visual Studio
- Easily reference additional Unity assemblies by adding simple `Reference` items to the project file, rather than finding and calling some obscure script
- All references must work cross-platform (on Windows/MacOS/Linux)
- Configuration should be minimal: just a Unity version, a project path for assemblies stored in the Unity project, and an optional install location for non-default cases.

## Usage

**Don't freak out!** The [basic usage](#basic-usage) example above will satisfy the large majority of use cases. The usage options below are for more advanced setups.

### Editing the project file

As shown in the basic example above, our package only requires a `UnityVersion` property to be up and running. `UnityVersion` must be a complete version string, in the format used by Unity Hub (the values boxed in red in the screenshot below).

![Unity version strings highlighted in the Unity Hub interface](./images/unity-versions.png)

To edit a project file in Visual Studio:

- **When targeting .NET Standard (recommended):** just double-click on the project in the Solution Explorer
- **When targeting .NET 4.x:** right click on the project in the Solution Explorer, click `Unload project`, then right click again to select `Edit <YourProject>.csproj`. When you're done editing the file, right click on the project again and select `Reload project`. Having to unload the project to edit it can be cumbersome, so check out this excellent [article by Scott Hanselman](https://www.hanselman.com/blog/UpgradingAnExistingNETProjectFilesToTheLeanNewCSPROJFormatFromNETCore.aspx) for instructions on migrating to the newer, leaner SDK syntax that .NET Standard uses.

### Choosing a `TargetFramework`

For new projects, you should use the modern "SDK-style" .csproj files, which have a root `<Project Sdk="...">` element rather than `<Project ToolsVersion="...">`. This style yields smaller, more readable project files, and simplifies portability with projects built against other .NET runtimes. You should then use one of the following .NET Standard `TargetFramework`s:

- For Unity 2021.2+, use `netstandard2.1`
- For Unity 2021.1 and below, use `netstandard2.0`

If, however, you are working with an existing, older project, then you may be forced to use one of the following .NET 4.x `TargetFramework`s:

- For Unity 2021.2+, use `net48` :
- For Unity 2020.2 - 2021.1, use `net472`
- For Unity 2020.1 and below, use `net461`

If you don't, you will see errors like:

```log
The primary reference ... could not be resolved because it has an indirect dependency on the assembly ... which was built against the ".NETFramework,Version=v4.[x]" framework. This is a higher version than the currently targeted framework ".NETFramework,Version=v4.[y]".
```

### Referencing additional Unity assemblies

By default, we only add a reference to `UnityEngine.dll`, but there are several other Unity assemblies that you might need to reference for your project. These include, but are certainly not limited to, `UnityEditor.dll` for writing custom editors, or `UnityEngine.UI.dll` for referencing UI types like `Text` and `Button`. To reference these assemblies, add `Reference` items to your `.csproj`, like so:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <!-- Same as above... -->
    <ItemGroup>
        <Reference Include="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEditorPath)" Private="false" />
        <Reference Include="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEngineUIPath)" Private="false" />
    </ItemGroup>
</Project>
```

Note the use of the `UnityInstallRoot`, `UnityVersion`, and `*Path` MSBuild properties. These properties spare you from having to remember the default Unity install path or the relative paths for any Unity assemblies, and they also let the references work across platforms (Windows/MacOS/Linux). See below for a [list of short-hand assembly properties](#available-short-hand-assembly-properties) that we provide.

Also note the use of [`Private="false"`](https://docs.microsoft.com/en-us/visualstudio/msbuild/common-msbuild-project-items#reference). This basically means "don't copy the referenced assembly to the output folder". This is recommended, so that Unity assemblies aren't being copied around unnecessarily, since they're automatically linked with managed plugins inside Unity.

If you want to reference a Unity assembly for which there is no short-hand property, you can just hard-code the path into the `Reference` item yourself. We always recommend starting with the `$(UnityInstallRoot)\$(UnityVersion)\` properties though, as they let your project files build cross-platform, and let you edit your Unity version string in one place.

### Referencing assemblies stored in a Unity project

You may need to reference assemblies stored in a Unity project folder (i.e., under `Assets/` or `Library/`). This is especially common when your code and Unity project are stored in the same repository, and you want to reference assemblies in Asset Store assets or Packages that you've installed. In these cases, the path in your `Reference` items should be relative paths, so that they stay cross-platform. We recommend defining an MSBuild property called `$(UnityProjectPath)` to store this relative path, so that you can use it as a short-hand for multiple `Reference`s. Moreover, we provide a couple short-hand properties for common assembly locations under the project root. For example, if you want to raise Standard Events with the [Analytics package](https://docs.unity3d.com/Manual/com.unity.analytics.html) and use the  [Addressables](https://docs.unity3d.com/Manual/com.unity.addressables.html) workflow, then your `.csproj` would look something like:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <!-- Same as above... -->
        <UnityProjectPath>/relative/path/to/unity/project</UnityProjectPath>
    </PropertyGroup>
    <ItemGroup>
        <Reference Include="$(UnityProjectPath)\$(UnityAnalyticsStandardEventsPath)" Private="false" />
        <Reference Include="$(UnityProjectPath)\$(UnityScriptAssembliesPath)\Unity.Addressables.dll" Private="false" />
    </ItemGroup>
</Project>
```

Make sure the project has been opened in Unity recently, so that the `Library/` folder actually contains the necessary assemblies!

Also note that, while we do provide short-hand properties for a couple assemblies under the `PackageCache` folder (see [full list](#available-short-hand-assembly-properties) below), we do *not* provide short-hand properties for assemblies stored in the `ScriptAssemblies` folder. That folder is completely flat, so you can just reference assemblies there by filename.

### Referencing assemblies at non-default install locations

Because Unity Hub is the tool [recommended by Unity Technologies](https://docs.unity3d.com/Manual/GettingStartedInstallingUnity.html) for installing Unity, we check for Unity assemblies within the Hub's default install locations (using the `UnityInstallRoot` property). If you are not using Unity Hub, or you are using a non-default install location, just set `UnityInstallRoot` to a different path. For example, if you were using a Windows machine and your Unity version was installed without the Hub in a `Unity\` folder on your `V:` drive, then your `.csproj` would look something like:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <UnityVersion>2021.2.2f1</UnityVersion>
        <UnityInstallRoot>V:\Unity</UnityInstallRoot>
    </PropertyGroup>
    <!-- etc. -->
</Project>
```

**Warning: When changing the `UnityInstallRoot` property (or `OSInstallRoot`), it is up to you to keep the paths cross-platform.**

### Removing the default reference to UnityEngine.dll

You may not want to keep our default reference to `UnityEngine.dll`, e.g., if you only need a reference to some other Unity assembly, or want to reference Unity's module assemblies directly. To remove the `Reference` from your project, simply use the MSBuild Item remove syntax, i.e., add the following line to an `<ItemGroup>` in your `.csproj`:

```xml
<Reference Remove="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEnginePath)" />
```

**Warning: If using directory imports, be sure to put the above line in `Directory.Build.targets`, not `Directory.Build.props`, otherwise you'll be trying to remove the Reference before it's been added!**

### Referencing the Unity core modules

`UnityEngine.dll` is actually built up from multiple smaller "module" assemblies stored in the `UnityModulesPath`. These modules contain types related to Audio, Animation, Particle Systems, Navigation, etc. If you are writing a managed plugin that references assemblies from a Package, you may get confusing compiler errors when using APIs from the Package that return types defined in a module. For example, if you reference the Unity UI Package from Unity 2019.2+, and use it to access `ScrollRect.velocity` (which returns a `Vector2`), you would see an error like `Error CS0012 The type 'Vector2' is defined in an assembly that is not referenced. You must add a reference to assembly 'UnityEngine.CoreModule, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null'.`. This is because the Unity UI Package's assembly doesn't use the `Vector2` type from `UnityEngine.dll`, it uses the type from `UnityEngine.CoreModule`, which is a module assembly. Therefore, the default reference to `UnityEngine.dll` added by this NuGet package does not satisfy the compiler.

The solution is to [remove our default reference](#removing-the-default-reference-to-unityengine.dll) to `UnityEngine.dll`, and then reference each module that you need individually. So, for this particular example, your `.csproj` might look like the following:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <!-- Same as above... -->
    <ItemGroup>
        <Reference Include="$(UnityProjectPath)\$(UnityScriptAssembliesPath)\UnityEngine.UI.dll" Private="false" />
        <!-- Other Package assembly references -->
        <Reference Remove="$(UnityInstallRoot)\$(UnityVersion)\$(UnityEnginePath)" />
        <Reference Include="$(UnityInstallRoot)\$(UnityVersion)\$(UnityModulesPath)\UnityEngine.CoreModule.dll" Private="false" />
        <!-- Other module references -->
    </ItemGroup>
</Project>
```

We do *not* provide short-hand properties for assemblies stored in `UnityModulesPath`. The folder is completely flat, so you can just reference assemblies there by filename. If you're unsure of which modules to reference, check out the Unity Scripting Manual. Every type includes an `Implemented in` note at the top of the page, telling you in which of Unity's core modules the type is implemented. For example, here is a screenshot of the manual page for `Vector2`:

![Unity Scripting Manual page for Vector2, showing that the type is implemented in UnityEngine.CoreModule](./images/unity-modules-docs.png)

**Warning: There is a Unity module called `UnityEngine.dll`. This is not to be confused with the `UnityEngine.dll` under `$(UnityInstallRoot)/Editor/Data/Managed`. If you have [removed the default UnityEngine.dll](#removing-the-default-reference-to-unityengine.dll) from your project, then you may still need to reference this module, for types like `GUIElement`, `Network`, `ProceduralMaterial`, etc.**

## Available Short-Hand Assembly Properties

Note that *all* of the following properties can be overwritten by setting the property manually in your project file. For example, in a `PropertyGroup` in your `.csproj`:

```xml
<UnityEngineUIPath>path/to/UnityEngine.UI.dll</UnityEngineUIPath>
```

Just be aware of which properties expect absolute paths, and which expect relative paths. As assembly paths change in future versions of Unity, you can continue referencing them by overwriting these properties, until we update the properties ourselves. This ability is why we say that this package is "forward-compatible".

The assembly paths under the `PackageCache` use the `*` wildcard. This saves you from hard-coding a package version and having to update it each time you update from Unity's Package Manager Window. Unity only stores one version of a Package in the `PackageCache` folder, so you don't need to worry about multiple versions of the same Package being referenced by the wildcard.

| Property | Unity Version | Default value | Comments |
|:---------|---------------|:--------------|:---------|
| `OSInstallRoot` | Any | `C:\Program Files` on Windows, `/Application` on MacOS, or `/home/<username>` on Linux. |  |
| `UnityInstallRoot` | Any | `$(OSInstallRoot)\Unity\Hub\Editor` |  |
| `UnityManagedPath` | Any | `Editor\Data\Managed` on Linux/Windows or `Unity.app\Contents\Managed` on MacOS. |  |
| `UnityModulesPath` | Any | `$(UnityManagedPath)\UnityEngine` | This folder contains assemblies for Unity's core modules like the Audio, Animation, and ParticleSystem modules. |
| `UnityExtensionsPath` | Any | `Editor\Data\UnityExtensions\Unity` on Linux/Windows or `Unity.app\Contents\UnityExtensions\Unity` on MacOS. |  |
| `UnityPlaybackEnginesPath` | Any | `Editor\Data\PlaybackEngines` | This folder contains target-platform-specific assemblies, e.g. those for iOS/Android. |
| `UnityAndroidPlayerPath` | Any | `$(UnityPlaybackEnginesPath)\AndroidPlayer` |  |
| `UnityiOSSupportPath` | Any | `$(UnityPlaybackEnginesPath)\iOSSupport` |  |
| `UnityBuiltInPackagesPath` | >= 2017.2 | `Editor\Data\Resources\PackageManager\BuiltInPackages` | This folder contains Unity's built-in Packages, like IMGUI and TerrainPhysics. |
| `UnityEnginePath` | Any | `$(UnityManagedPath)\UnityEngine.dll` | This reference is added by default. See above for [instructions to remove it](#removing-the-default-reference-to-unityengine.dll). |
| `UnityEditorPath` | Any | `$(UnityManagedPath)\UnityEditor.dll` |  |
| `UnityEngineUIPath` | <= 2019.2 | `$(UnityExtensionsPath)\GUISystem\UnityEngine.UI.dll`. | In Unity 2019.2+, use `$(UnityProjectPath)\$(UnityScriptAssembliesPath)\UnityEngine.UI.dll` instead. |
| `UnityEngineTestRunnerPath` | <= 2019.2 | `$(UnityExtensionsPath)\TestRunner\UnityEngine.TestRunner.dll` | In Unity 2019.2+, use `$(UnityProjectPath)\$(UnityScriptAssembliesPath)\UnityEngine.TestRunner.dll` instead. |
| `UnityProjectPath` | Any | N/A | This property has no default value. Point it at the root folder of your Unity project, so that you can more easily reference Package and Asset Store assemblies (as [described above](#referencing-assemblies-stored-in-a-unity-project)). |
| `UnityPackageCachePath` | >= 2017.2 | `Library\PackageCache` |  |
| `UnityScriptAssembliesPath` | Any | `Library\ScriptAssemblies` |  |
| `NewtonsoftJsonPath` | >= 2019.3 | `$(UnityPackageCachePath)\com.unity.nuget.newtonsoft-json*\Runtime\Newtonsoft.Json.dll` | Requires installation of the [Performance Testing Extension](https://docs.unity3d.com/Packages/com.unity.test-framework.performance@1.0/manual/index.html) for Unity Test Runner package. |
| `NunitPath` | >= 2019.2 | `$(UnityPackageCachePath)\com.unity.ext.nunit*\net35\unity-custom\nunit.framework.dll` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@1.1/manual/index.html) package. |
| `MoqPath` | 2019.2, 2019.3 | `$(UnityPackageCachePath)\nuget.moq*\Moq.dll` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@1.1/manual/index.html) package. |
| `UnityAnalyticsStandardEventsPath` | >= 2019.2 | `$(UnityPackageCachePath)\com.unity.analytics*\AnalyticsStandardEvents\Unity.Analytics.StandardEvents.dll` | Requires installation of the [Analytics Library](https://docs.unity3d.com/Packages/com.unity.analytics@3.3/manual/index.html) package. |
| `UnityEditorAndroidExtensionsPath` | Any | `$(UnityAndroidPlayerPath)\UnityEditor.Android.Extensions.dll` | See types under `UnityEditor > UnityEditor.Android` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |
| `UnityEditoriOSExtensionsCommonPath` | Any | `$(UnityiOSSupportPath)\UnityEditor.iOS.Extensions.Common.dll` | See types under `UnityEditor > UnityEditor.iOS` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |
| `UnityEditoriOSExtensionsXcodePath` | Any | `$(UnityiOSSupportPath)\UnityEditor.iOS.Extensions.Xcode.dll` | See types under `UnityEditor > UnityEditor.iOS` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |

## FAQ

1. **Why would I use this NuGet package?** The primary, intended use case for this NuGet is for Unity developers writing [managed plugins](https://docs.unity3d.com/Manual/UsingDLL.html) (pre-compiled DLLs that will be imported into Unity) that also depend on Unity APIs. It allows developers to reference the Unity assemblies via `Reference` items in their project file, just like they might reference any other NuGet package or local assembly, but without having to remember Unity's assembly paths or keep them up-to-date and cross-platform. With the option to [use Unity as a library](https://blogs.unity3d.com/2019/06/17/add-features-powered-by-unity-to-native-mobile-apps/) in 2019.3+, developers might also use this package in native mobile apps created with [Xamarin](https://dotnet.microsoft.com/apps/xamarin), or in really any library or executable that needs access to the Unity APIs.
1. **How does this work?** This NuGet package [imports an MSBuild .props file](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package#including-msbuild-props-and-targets-in-a-package) into your project, which adds the various properties and `Reference` items at build time.
1. **Are the `Reference` paths really cross-platform?** Yes, but only paths that begin with the default `$(OSInstallRoot)` or `$(UnityInstallRoot)` properties. This works through a magical little combination of [MSBuild Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions) and the [`IsOsPlatform()` Property Function](https://docs.microsoft.com/en-us/visualstudio/msbuild/property-functions#msbuild-property-functions). Open the [Unity3D.props](./nupkg/build/Unity3D.props) file to see how we do it. :wink:
1. **Is this package officially maintained by Unity Technologies?** No, it is maintained by a few wild and crazy guys at Derploid Entertainment. However, we will be submitting this package to Unity Technologies as it gains traction, **_so that maybe we can finally have an officially supported NuGet package from Unity!_**
1. **If not, how is this legal?** We're not actually distributing the Unity assembly binaries, just MSBuild files that reference them. This NuGet package won't add anything if you don't actually have a version of Unity installed on your machine.
1. **Can you help me solve [error] in Unity version [version]?** Possibly. We only test compatibility with, and offer support for, the latest Unity [LTS releases](https://unity3d.com/unity/qa/lts-releases) and the TECH stream releases of the current year. Unity does not officially support versions older than that, so neither do we! That said, if you're having an issue with an older version of Unity, there's a good chance that we've seen it ourselves, so feel free to [open an Issue](https://github.com/DerploidEntertainment/UnityAssemblies/issues)!
1. **With which Unity versions has this package been tested?** 2018.4, 2019.4, 2020.1, 2020.3, 2021.1, 2021.2
1. **Why hasn't this repository been updated since [date]?** The Unity3D NuGet package is very simple, with most of its functionality contained in a [single small file](./nupkg/build/Unity3D.props). Between that, and the package's use of forward-compatible properties like `UnityVersion` that can be tweaked at design time, this repository simply does not require frequent updates. This does _not_ mean that this project is dead; at Derploid, we still use the package in almost every project. Most changes going forward will be to add more short-hand assembly properties, especially for popular third-party assemblies published on the Asset Store, and to add test projects for new versions of Unity.

## Contributing

Please refer to our [Contributing guide](./CONTRIBUTING.md).

## License

[MIT](./LICENSE)
