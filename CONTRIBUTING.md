# How to contribute to the Unity Assemblies project

## Overview

Like Unity, **we only support Unity's [LTS versions](https://unity3d.com/unity/qa/lts-releases) and the Tech Stream versions for the current year.** That said, we are willing to accept bug reports and Pull Requests for issues related to other versions or their documentation.

The Unity Assemblies project is a **volunteer effort**. Please be understanding if it takes us time to respond to your Issues or Pull Requests.

Thanks for contributing! :heart: :heart: :heart:

### Did you find a bug?

* **Ensure the bug was not already reported** by searching our [GitHub Issues](https://github.com/DerploidEntertainment/UnityAssemblies/issues).
* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/DerploidEntertainment/UnityAssemblies/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

### Did you write a patch that fixes a bug?

* Awesome! Thank you!
* Open a new GitHub [Pull Request](https://github.com/DerploidEntertainment/UnityAssemblies/pulls) with the patch.
* Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.
* Before submitting, please ensure you have not introduced any other regressions by reading our [testing](#testing) guidelines below.

### Did you fix whitespace, format code, or make a purely cosmetic patch?

Changes that are cosmetic in nature and do not add anything substantial to the stability, functionality, or testability of this package may not require thorough testing, but still require a PR. As usual, these PRs may be approved or denied at our discretion, as we decide what counts as well-formatted code. :stuck_out_tongue:

### Do you intend to add a new feature or change an existing one?

Open an Issue to suggest your change. GitHub issues are primarily intended for bug reports and fixes; however, they also serve as a decent platform for managing feature requests at scale, and keeping all conversation about those requests transparent and publicly accessible.

### Do you have questions about the source code?

Ask any question about how this package or how to use it in an Issue. Make sure you've thoroughly read our README documentation first!

### Do you want to contribute to the README documentation?

* Awesome! Thank you!
* Open a new GitHub Pull Request. The rules here are the same as for any other PR, described above.

## Testing

This repo contains a [test solution](./test) to ensure that all MSBuild properties work as intended in projects targeting supported versions of Unity. When opening a PR, please ensure that you have tested all of your changes with this solution. The solution contains the following:

* A set of solution configurations to allow quick and easy testing of all supported Unity versions. These configurations use the _project_ configurations described below.
* A collection of MSBuild `.props` files with properties that simplify testing the supported Unity versions:
  * `Directory.Build.props`: contains the various project configurations that we support. MSBuild imports this `.props` file into a project before all others, [by convention](https://docs.microsoft.com/en-us/visualstudio/msbuild/customize-your-build#directorybuildprops-and-directorybuildtargets). These configurations use the naming convention `<Framework>_<UnityVersion>`, with Unity verions containing only the major and minor version separated by an underscore. For example, the configuration to test a .NET Standard 2.0 project against Unity 2021.1.x is called `Standard20_2021_1`. The file contains mappings from these configuration names to the correct `TargetFramework` values. The file also maps configuration names to custom `ConfigurationVersionNum` properties, which represent the target Unity version as a number so that we can do numeric comparisons on it (e.g., `20211` for 2021.1.x).
  * `UnityAssetsPath.props`: contains the actual relative paths to the test Unity projects for each supported Unity version. Several of our short-hand MSBuild properties reference assemblies stored within a Unity project's `Library/` folder. Therefore, we maintain a collection of test Unity projects under the `unity/` folder so that those references can be satisfied. These projects use the naming convention `Unity3D_<Version>`, where the verion contains only the major and minor version separated by an underscore. For example, the test project for Unity 2021.1.x is called `Unity3D_2021_1`. This `.props` file defines the `UnityProjectPath` property that all test projects will use to reference their Unity assemblies.
  * `UnityVersion.props`: contains the full Unity versions that we use for each Unity minor release. Each `ConfigurationVersionNum` (from the `Directory.Build.props` file) is mapped to a specific `UnityVersion` (used by all of our other short-hand properties). For example, `20211` could be mapped to to `2021.1.3f1`. The actual patch versions that we use for testing may change from time to time, as new versions change the paths to existing assemblies, or introduce issues when referencing assemblies from particular Unity package versions. You will need to install these Unity versions (at least, those _supported_ Unity versions) locally in order to build the test solution, otherwise you will get build errors about missing references. Alternatively, you can tweak this file locally to point at the actual versions of Unity that you have installed (as long as they have the same major/minor version numbers).
* Two test C# projects:
  * `TestAllRefs`: contains code to test all of the references for which we provide short-hand MSBuild properties. Within the `.csproj` file, you can see how we add MSBuild `Reference` items for the various short-hand properties, along with `Condition` attributes against the `ConfigurationVersionNum` property to make sure that we only reference the assemblies supported by a particular version of Unity. The test script in this project references a number of types that will only compile if the correct assemblies have been referenced. The file contains some `#if` directives so that types are only referenced when targeting the versions of Unity that support them. When adding tests for new Unity versions (the new Unity test project and the new VS solution configuration), you should add some conditionally compiled code to this test script that will only compile successfully when targeting that new Unity version. The goal is to rule out false positives: just because one solution configuration builds doesn't mean that they all will!
  * `TestMinimal`: contains code to test the minimal use case of adding this NuGet package: a `UnityVersion` property and nothing else. The test script for this project simply defines a class derived from `UnityEngine.MonoBehaviour`.

"Running" the tests consists of building the solution in each of the defined solution configurations. If all builds succeed, then the tests passed! To do this, just change the active solution configuration in Visual Studio and select "Build > Build Solution". Consult our [troubleshooting](#troubleshooting) guidelines (or past [Issues](https://github.com/DerploidEntertainment/UnityAssemblies/issues)) if you run into any problems.

### Troubleshooting

Rapidly changing MSBuild properties/items in a solution can lead to weird, transient errors. In all cases, you can try the following (in order of increasing time/effort):

* Use "Build > Rebuild Solution" instead of just "Build". This cleans the solution before building it again.
* Restart Visual Studio. This refreshes some internal caches.
* Clear all VS-generated files from the solution folder. I.e., close Visual Studio, then delete the hidden `.vs/` folder and the `bin/` and `obj/` folders under each test C# project. This resets _all_ caches, essentially reverting the solution to when you first cloned it. Obviously, VS will have to re-generate those folders next time you open the solution, but that shouldn't take long, as this solution is pretty tiny.
* Make sure you have installed the necessary VS modules. For targeting .NET 4.x or .NET Standard x, you will need to install the corresponding SDKs from the Visual Studio installer.

If none of the above work, make sure that the assemblies being referenced by your current solution configuration _do_ exist on disk. Common reasons that they wouldn't include:

* Typos in the `.props` and `.csproj` files. If you edited those files, make sure you used the correct naming conventions for all paths and MSBuild properties
* Incorrect `Condition` attributes in the `.props` or `.csproj` files. If you edited those files, make sure you adjusted the `Condition`s so that you're not trying to reference assemblies/types that aren't actually included in the currently targeted Unity version. For example, `Unity.Analytics.StandardEvents.dll` is only included in Unity 2019.2+, so you can ensure that it's only referenced in the appropriate solution configurations with a condition like `Condition="'$(ConfigurationVersionNum)'>='20192'"`.
* Ensure that you've opened the targeted Unity version at least once before attempting to build the test solution. Assemblies in the `Library/` folder will not be generated until you do so.
* Ensure that you've installed the correct Unity packages (and versions of those packages). This is mainly relevant if you are adding a new Unity test project, or changing an existing one. For example, the `NewtonsoftJsonPath` short-hand property references a `Newtonsoft.Json.dll` file that will only be present in a Unity project's `Library/` folder if that project includes the latest version of the `com.unity.nuget.newtonsoft-json` package. These packages should be added through Unity's Package Manager window, so that the correct updates are made to the project's `Packages/manifest.json` _and_ `Packages/packages-lock.json` files.
