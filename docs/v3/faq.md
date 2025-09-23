# Unity3D v3 - FAQ

- [Usage](./usage.md)
- [Available Short-Hand Properties](./short-hand-properties.md)
- -> FAQ

1. **Why would I use this NuGet package?**
    The primary, intended use case for this NuGet is for Unity developers writing [managed plugins](https://docs.unity3d.com/Manual/UsingDLL.html)
    (pre-compiled DLLs that will be imported into Unity) that also depend on Unity APIs.
    It allows developers to reference the Unity assemblies via `Reference` items in their project files, just like they might reference any other NuGet package or local assembly,
    without having to remember Unity's assembly paths or keep them up-to-date and cross-platform.
    With the option to [use Unity as a library](https://blogs.unity3d.com/2019/06/17/add-features-powered-by-unity-to-native-mobile-apps/) in 2019.3+,
    developers might also use this package in native mobile apps created with [Xamarin](https://dotnet.microsoft.com/apps/xamarin),
    or in really any library or executable that needs access to the Unity APIs.
1. **How does this work?**
    This NuGet package [imports an MSBuild .targets file](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package#including-msbuild-props-and-targets-in-a-package) into your project,
    which adds the various properties and `Reference` items at build time.
    The Unity version can be set via a `UnityVersion` MSBuild property or
    parsed from the `ProjectVersion.txt` file of the Unity project at `UnityProjectPath` (using `File.ReadAllText`)
    in an [MSBuild static property function](https://docs.microsoft.com/en-us/visualstudio/msbuild/property-functions?static-property-functions).
1. **Are the `Reference` paths really cross-platform?**
    Yes, but only paths that begin with the default `$(OSInstallRootPath)` and `$(UnityInstallRootPath)` properties, or with a custom relative or cross-platform base path that you define.
    This works through a magical little combination of [MSBuild Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions)
    and the [`IsOsPlatform()` Property Function](https://docs.microsoft.com/en-us/visualstudio/msbuild/property-functions#msbuild-property-functions).
1. **Is this package officially maintained by Unity Technologies?**
    No, it is maintained by [one wild and crazy guy](https://github.com/Rabadash8820).
    However, this package will be submitted to Unity Technologies as it gains traction,
    **_so that maybe we can finally have an officially supported NuGet package for Unity assemblies!_**
1. **If not, how is this package legal?**
    Well, it's not actually distributing the Unity assembly binaries, just MSBuild files that reference them.
    This NuGet package won't do anything (except add some build warnings) if you haven't actually installed a version of Unity on your machine.
1. **Can you help me solve [error] in Unity [version]?**
    Possibly. Compatibility is only tested with, and support offered for, the latest Unity [LTS releases](https://unity3d.com/unity/qa/lts-releases) and the TECH stream releases of the current year.
    Unity does not officially support versions older than that, so neither does this package!
    That said, if you're having an issue with an older version of Unity, there's a good chance that someone in this community has seen it before,
    so feel free to [open an Issue](https://github.com/Rabadash8820/UnityAssemblies/issues)!
1. **With which Unity versions has this package been officially tested?**
    In the following:
    - 6 LTS, 6.1, 6.2
    - 2023.2, 2023.1
    - 2022.3 LTS, 2022.2, 2022.1
    - 2021.3 LTS, 2021.2, 2021.1
    - 2020.3 LTS, 2020.1
    - 2019.4 LTS
    - 2018.4 LTS
1. **Can I use this package in my CI/CD Pipeline?**
    Most likely, [yes](./usage.md#cicd-pipelines)!
1. **Why hasn't this repository been updated since [date]?**
    This NuGet package is very simple, with most of its functionality contained in a [single file](../../nupkg/build/Unity3D.targets).
    Between that, and the package's use of forward-compatible properties like `UnityVersion` that can be tweaked at design time,
    this repository simply does not require frequent updates.
    Most changes going forward will be to add more short-hand properties, and to add test projects for new versions of Unity.
