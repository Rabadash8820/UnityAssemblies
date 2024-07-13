# Unity3D v2 - Available Short-Hand Properties

- [Usage](./usage.md)
- -> Available Short-Hand Properties
- [FAQ](./faq.md)

Note that, unless otherwise noted, _any_ of the following properties can be overwritten by setting the property manually in `Directory.Build.props`.
For example, to change the UI assembly's path, you could set:

```xml
<UnityEngineUIPath>path\to\UnityEngine.UI.dll</UnityEngineUIPath>
```

As assembly paths change in future versions of Unity, you can continue referencing them by overwriting these properties, until the properties are updated in this package.
This ability makes this NuGet package truly "forward-compatible".
You can manually override the property for a single assembly (e.g., `UnityEnginePath`),
or for many assemblies under the same absolute/relative base path (e.g., `UnityModulesPath` or `UnityModulesDir`).

Generally, properties named `*Path` are absolute paths, and properties named `*Dir` or `*Assembly` are relative paths.
Most assembly path properties (e.g., `UnityPackageCachePath`) are a combination of a relative path property (e.g., `UnityPackageCacheDir`)
and a base path, which might use another short-hand property.
Through clever use of these properties, you can even reference assemblies from more than one Unity project.
You might do this if you wanted to reference an assembly at the same relative path in two different Unity projects under different conditions.
You could use the same _relative_ short-hand property in both cases, but set the base path conditionally.

The assembly paths under the `Library/PackageCache` folder use the `*` wildcard.
This spares you from hard-coding a UPM package version and updating it every time you update the package in Unity's Package Manager window.
Unity only stores one version of a Package in the `PackageCache` folder, so you don't need to worry about multiple versions of the same Package being referenced by the wildcard.
When adding references to other UPM package assemblies, you should precede the `*` wildcard with `%40`
(an [MSBuild-escaped](https://learn.microsoft.com/en-us/visualstudio/msbuild/how-to-escape-special-characters-in-msbuild#to-use-an-msbuild-special-character-as-a-literal-character) `@` character)
to prevent conflicts with "sub-namespace" assembly names.
For example, you could reference both `org.nuget.microsoft.extensions.logging%40*\Microsoft.Extensions.Logging.dll` and
`org.nuget.microsoft.extensions.logging.abstractions%40*\Microsoft.Extensions.Logging.Abstractions.dll`, without the former's wildcard overwriting the latter.

**Note: It is worth repeating that, unless otherwise noted, _any_ of these properties can be manually overridden.**

| Property | Default value | Comments |
|:---------|:--------------|:---------|
| `OSInstallRootPath` | `C:\Program Files` on Windows, `/Application` on MacOS, or `/home/<username>` on Linux. |  |
| `UnityVersionMajor` | 0 | Major version parsed from `UnityVersion` (e.g., `2021` from `2021.3.5f1`). Cannot be overriden. |
| `UnityVersionMinor` | 0 | Minor version parsed from `UnityVersion` (e.g., `3` from `2021.3.5f1`). Cannot be overriden. |
| `UnityVersionPatch` | 0 | Patch version parsed from `UnityVersion` (e.g., `5f1` from `2021.3.5f1`). Cannot be overriden. |
| `UnityVersionAsNumber` | 0.0 | Equals `$(UnityVersionMajor).$(UnityVersionMinor)`. Cannot be overriden. Useful for making numeric comparisons against the Unity version in MSBuild Conditions. |
| `UnityInstallRootDir` | `Unity\Hub\Editor` | Referenced by `UnityInstallRootPath`. |
| `UnityInstallRootPath` | `$(OSInstallRootPath)\$(UnityInstallRootDir)` |  |
| `UnityVersionInstallPath` | `$(UnityInstallRootPath)\$(UnityVersion)` |  |
| `UnityManagedDir` | `Editor\Data\Managed` on Linux/Windows or `Unity.app\Contents\Managed` on MacOS. | Referenced by `UnityManagedPath`. |
| `UnityManagedPath` | `$(UnityVersionInstallPath)\$(UnityManagedDir)` |  |
| `UnityExtensionsDir` | `Editor\Data\UnityExtensions\Unity` on Linux/Windows or `Unity.app\Contents\UnityExtensions\Unity` on MacOS. | Referenced by `UnityExtensionsPath`. |
| `UnityExtensionsPath` | `$(UnityVersionInstallPath)\$(UnityExtensionsDir)` |  |
| `UnityModulesDir` | `UnityEngine` | Referenced by `UnityModulesPath`. |
| `UnityModulesPath` | `$(UnityManagedPath)\$(UnityModulesDir)` | This folder contains assemblies for Unity's core modules like the Audio, Animation, and ParticleSystem modules. References to those assemblies are added by default in version 2.2.0+. See [instructions for removing them](./usage.md#removing-the-default-reference-to-unityenginedll). |
| `UnityPlaybackEnginesDir` | `Editor\Data\PlaybackEngines` | Referenced by `UnityPlaybackEnginesPath`. |
| `UnityPlaybackEnginesPath` | `$(UnityVersionInstallPath)\$(UnityPlaybackEnginesDir)` | This folder contains target-platform-specific assemblies, e.g. those for iOS/Android. |
| `UnityAndroidPlayerDir` | `$(UnityPlaybackEnginesDir)\AndroidPlayer` | Referenced by `UnityAndroidPlayerPath`. |
| `UnityAndroidPlayerPath` | `$(UnityVersionInstallPath)\$(UnityAndroidPlayerDir)` |  |
| `UnityiOSSupportDir` | `$(UnityPlaybackEnginesDir)\iOSSupport` | Referenced by `UnityiOSSupportPath`. |
| `UnityiOSSupportPath` | `$(UnityVersionInstallPath)\$(UnityiOSSupportDir)` |  |
| `UnityScriptAssembliesDir` | `Library\ScriptAssemblies` | Referenced by `UnityScriptAssembliesPath`. |
| `UnityScriptAssembliesPath` | `$(UnityProjectPath)\$(UnityScriptAssembliesDir)` |  |
| `UnityBuiltInPackagesDir` | `Editor\Data\Resources\PackageManager\BuiltInPackages` | Referenced by `UnityBuiltInPackagesPath`. Only defined if `UnityVersion` is >= 2017.2. |
| `UnityBuiltInPackagesPath` | `$(UnityVersionInstallPath)\$(UnityBuiltInPackagesDir)` | This folder contains assemblies from Unity's built-in Packages, like IMGUI and TerrainPhysics (for all other UPM Package assemblies, see `UnityPackageCachePath`). Only defined if `UnityVersion` is >= 2017.2. |
| `UnityProjectPath` | N/A | This property has no default value. Set it to the absolute path of the root folder of your Unity project, so that you can easily reference Package and Asset Store assemblies (as [described above](./usage.md#referencing-assemblies-stored-in-a-unity-project)). |
| `UnityPackageCacheDir` | `Library\PackageCache` | Referenced by `UnityPackageCachePath`. Only defined if `UnityVersion` is >= 2017.2. |
| `UnityPackageCachePath` | `$(UnityProjectPath)\$(UnityPackageCacheDir)` | This folder contains assemblies from UPM packages (for built-in Packages, see `UnityBuiltInPackagesPath`). Only defined if `UnityVersion` is >= 2017.2. |
| `UnityEnginePath` | `$(UnityManagedPath)\UnityEngine.dll` | This reference is added by default in versions 2.1.3 and below. See [instructions to remove it](./usage.md#removing-the-default-reference-to-unityenginedll). |
| `UnityEditorPath` | `$(UnityManagedPath)\UnityEditor.dll` |  |
| `UnityEngineUIPath` | `$(UnityScriptAssembliesPath)\UnityEngine.UI.dll` for Unity 2019.3+, `$(UnityExtensionsPath)\GUISystem\UnityEngine.UI.dll` for Unity 2019.2 and below |  |
| `UnityEngineTestRunnerPath` | `$(UnityScriptAssembliesPath)\UnityEngine.TestRunner.dll` for Unity 2019.3+, `$(UnityExtensionsPath)\TestRunner\UnityEngine.TestRunner.dll` for Unity 2019.2 and below |  |
| `UnityEditorAndroidExtensionsPath` | `$(UnityAndroidPlayerPath)\UnityEditor.Android.Extensions.dll` | See types under `UnityEditor > UnityEditor.Android` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |
| `UnityEditoriOSExtensionsCommonPath` | `$(UnityiOSSupportPath)\UnityEditor.iOS.Extensions.Common.dll` | See types under `UnityEditor > UnityEditor.iOS` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |
| `UnityEditoriOSExtensionsXcodePath` | `$(UnityiOSSupportPath)\UnityEditor.iOS.Extensions.Xcode.dll` | See types under `UnityEditor > UnityEditor.iOS` in the [Unity Scripting API docs](https://docs.unity3d.com/ScriptReference/index.html) |
| `NewtonsoftJsonAssembly` | `com.unity.nuget.newtonsoft-json%40*\Runtime\Newtonsoft.Json.dll` | Requires installation of the [Performance Testing Extension](https://docs.unity3d.com/Packages/com.unity.test-framework.performance@latest/index.html) for Unity Test Runner package. Referenced by `NewtonsoftJsonPath`. Only defined if `UnityVersion` is between 2019.3 and 2022.1, inclusive. |
| `NewtonsoftJsonPath` | `$(UnityPackageCachePath)\$(NewtonsoftJsonAssembly)` for Unity 2019.3-2022.1, `$(UnityManagedPath)\Newtonsoft.Json.dll` for Unity 2022.2+ | In Unity 2019.3-2022.1, requires installation of the [Performance Testing Extension](https://docs.unity3d.com/Packages/com.unity.test-framework.performance@latest/index.html) for Unity Test Runner package. No extra installations required in Unity 2022.2+. |
| `NunitAssembly` | `com.unity.ext.nunit%40*\net35\unity-custom\nunit.framework.dll` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@latest/index.html) package. Referenced by `NunitPath`. Only defined if `UnityVersion` is >= 2019.2. |
| `NunitPath` | `$(UnityPackageCachePath)\$(NunitAssembly)` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@latest/index.html) package. Only defined if `UnityVersion` is >= 2019.2. |
| `MoqAssembly` | `nuget.moq%40*\Moq.dll` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@latest/index.html) package. In Unity 2020.1+, [download Moq from NuGet](https://www.nuget.org/packages/moq/) and import it as a managed plugin. Referenced by `MoqPath`. Only defined if `UnityVersion` is between 2019.2 and 2019.3, inclusive. |
| `MoqPath` | `$(UnityPackageCachePath)\$(MoqAssembly)` | Requires installation of the [Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@latest/index.html) package. In Unity 2020.1+, [download Moq from NuGet](https://www.nuget.org/packages/moq/) and import it as a managed plugin. Only defined if `UnityVersion` is between 2019.2 and 2019.3, inclusive. |
| `UnityAnalyticsStandardEventsAssembly` | `com.unity.analytics%40*\AnalyticsStandardEvents\Unity.Analytics.StandardEvents.dll` | Requires installation of the [legacy Analytics Library](https://docs.unity3d.com/Packages/com.unity.analytics@latest/index.html) package. Referenced by `UnityAnalyticsStandardEventsPath`. Only defined if `UnityVersion` is >= 2019.2. |
| `UnityAnalyticsStandardEventsPath` | `$(UnityPackageCachePath)\$(UnityAnalyticsStandardEventsAssembly)` | Requires installation of the [legacy Analytics Library](https://docs.unity3d.com/Packages/com.unity.analytics@latest/index.html) package. Only defined if `UnityVersion` is >= 2019.2. |
