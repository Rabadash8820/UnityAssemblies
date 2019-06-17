![Unity logo, trademarked by Unity Technologies](./icon.png)

# Unity Assemblies

This repository contains the source code for the [`Unity3D` NuGet package](https://www.nuget.org/packages/Unity3D).

`Unity3D` allows developers to effectively reference assemblies of the Unity game engine (e.g., `UnityEngine.dll`) as NuGet packages.

## Why another NuGet package for Unity?

Yes, it's true, there are a number of good NuGet packages already available on [nuget.org](https://www.nuget.org/). Unfortunately, most of these packages are no longer being updated and have a number of issues. Almost all of them fall into one of two categories:

1. **Containing the actual Unity binaries within the package.** These packages include [UnityEngine](https://www.nuget.org/packages/UnityEngine/) by Leanwork, [Unity3D.UnityEngine](https://www.nuget.org/packages/Unity3D.UnityEngine/) and [Unity3D.UnityEngine.UI](https://www.nuget.org/packages/Unity3D.UnityEngine.UI) by Dzmitry Lahoda, and [UnityEngine5](https://www.nuget.org/packages/UnityEngine5/) by Taiyoung Jang. The problem with these packages (aside from the questionable legality of re-distributing Unity Technologies' binaries), is that a new version of the package must be pushed for each new version of Unity. When these packages stop being updated (which has happened in almost every case), then they are no longer useful because they don't allow you to program against the latest Unity APIs. Most of them do not have versions for Unity 2019.1+, and/or do not support the new .NET Standard 2.0 profile.
2. **Containing some kind of script that adds references to assemblies from a particular installed version of Unity.** The main package in this category is [Unity3D.DLLs](https://www.nuget.org/packages/Unity3D.DLLs/) by Precision Mojo, LLC. This package uses a PowerShell script to add references to the latest version of Unity installed on a user's machine. This is powerful, as it theoretically makes the package forward-compatible with all versions of Unity yet to come. Unfortunately, this package has not been updated since 2013, meaning that many of the NuGet/PowerShell conventions that it relied upon are no longer supported in the newest versions of Visual Studio. Even when the package was current, it located the Unity assemblies in a brittle and complex (though clever) manner that does not support the newer Unity Hub install locations and, more importantly, only worked on Windows (involving the Windows registry).

Moreover, only Dzmitry Lahoda's packages seem to recognize the need for _other_ Unity assemblies besides just `UnityEngine`. As more advanced Unity users will know, `UnityEngine.dll` doesn't contain everything. Editor scripts also require a reference to `UnityEditor.dll`; if you want to use the Unity Test Runner, then you have to reference `UnityEngine.TestRunner.dll`; and the list goes on...

Thus, we at Derploid Entertainment created the `Unity3D` package with the following goals:
- Add the Unity assembly references programmatically, so that the package is forward-compatible
- Use built-in MSBuild properties/items to add the references, rather than clunky scripts that may not be supported by future versions of Visual Studio
- Opt in to references to the other Unity assemblies by adding simple boolean properties to the project file, rather than having to call some hard-to-find-and-use script
- All references must work on Windows _and_ Mac (and Linux, when its officially supported...)
- Configuration should be minimal: just a Unity version and an optional install location for non-default cases
- Submit this package to Unity Technologies, **_so that maybe we can finally have an officially supported NuGet package for Unity!_** (we'll keep this repo updated on the status of that)

## Usage

Here is a minimal example of `.csproj` file making use of this package. The project is targeting .NET Standard and referencing the `UnityEngine` assembly from Unity 2019.1.6f1:

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <TargetFramework>netstandard2.0</TargetFramework>
        <UnityVersion>2019.1.6f1</UnityVersion>
    </PropertyGroup>
    <ItemGroup>
        <PackageReference Include="Unity3D" Version="1.*" />
    </ItemGroup>
</Project>
```

As you can see, our package requires a `UnityVersion` property for the version of Unity whose assemblies you want to reference. `UnityVersion` must be a complete version string, in the format used by Unity Hub (the values boxed in red in the screenshot below).

![Unity version strings highlighted in the Unity Hub interface. For example, "2019.1.6f1"](./unity-versions.png)

By default, we only add a reference to `UnityEngine`, but there are several other references to which you can opt in. To add a reference to Unity assembly `X`, add a `<ReferenceX>true</ReferenceX>` property to your `.csproj`. The supported `ReferenceX` properties are:

| Property | Unity assembly referenced | Default | Path property | Use case |
|----------|---------------------------|---------|---------------|----------|
| `ReferenceUnityEngine` | UnityEngine | `true` | `$(UnityEngineAssembly)` | Projects with any classes that inherit `MonoBehaviour` or reference Unity types. |
| `ReferenceUnityEditor` | UnityEditor | `false` | `$(UnityEditorAssembly)` | Projects with Editor scripts (e.g., classes inheriting `Editor`, `EditorWindow`, or `PropertyDrawer`). |
| `ReferenceUnityEngineUi` | UnityEngine.UI | `false` | `$(UnityEngineUiAssembly)` | Projects that reference Unity UI types (e.g., `Text`, `Image`, `Button`). |
| `ReferenceUnityEngineTestRunner` | UnityEngine.TestRunner | `false` | `$(UnityEngineTestRunnerAssembly)` | Projects with NUnit tests to be run by the Unity Test Runner. |

So, for example, if you were writing an Editor plugin that needed to reference `UnityEngine`, `UnityEngine.UI`, and `UnityEditor`, then your `.csproj` would include the following properties:

```xml
<ReferenceUnityEngine>true</ReferenceUnityEngine>   <!-- Optional -->
<ReferenceUnityEditor>true</ReferenceUnityEditor>
<ReferenceUnityEngineUi>true</ReferenceUnityEngineUi>
```

Because Unity Hub is the tool [recommended by Unity Technologies](https://docs.unity3d.com/Manual/GettingStartedInstallingUnity.html) for installing Unity, we check for Unity assemblies within the Hub's default install locations, which are:

- **Windows**: C:\Program Files\Unity\Hub\Editor
- **Mac**: /Application/Unity/Hub/Editor

If you are not using Unity Hub, or you are using a custom install location, then you must add a `UnityLocation` property to indicate where your Unity versions are installed. For example, if you were using a Windows machine and your Unity versions were installed in a `Unity\` folder on your `V:` drive, then your `.csproj` would look something like:

```xml
<PropertyGroup>
    <!-- ... -->
    <UnityVersion>2019.1.6f1</UnityVersion>
    <UnityLocation>V:\Unity</UnityLocation>
</PropertyGroup>
<!-- ... -->
```

If for any reason you need to customize the actual `Reference` items used in your project, then we also provide a set of MSBuild properties with the actual paths of the various Unity assemblies. These properties were given in the `Path property` column of the table above. For example, to explicitly add a reference to `UnityEngine.UI.dll`, your `.csproj` would include the following lines:

```xml
<Reference Include="UnityEngine.UI.dll">
    <HintPath>$(UnityEngineUiAssembly)</HintPath>
</Reference>
```

## FAQ

### How is this legal?

We're not actually distributing the UnityEngine DLLs, just MSBuild properties that reference them. This NuGet package won't do anything (except show a warning) if you don't actually have a version of Unity installed.

### How does this work?

Through a little bit of MSBuild magic. When you add `<ReferenceX>true</ReferenceX>` to your project file, we are adding an MSBuild `Reference` item to assembly `X` behind the scenes. So, in effect, this NuGet just saves you the clicks of adding an assembly reference within Visual Studio. However, if you did add a reference manually, then the `HintPath` would be platform-specific; i.e., if you added the reference on a Windows machine, then the reference path would not exist on a Mac machine. This NuGet sets the assembly paths based on the current OS, so the references will work cross-platform.
