![](./icon.png)

# Unity Assemblies

This repository contains the source code for the [`UnityAssemblies` NuGet package](https://www.nuget.org/packages/UnityAssemblies).

`UnityAssemblies` allows developers to effectively reference assemblies of the Unity game engine (e.g., `UnityEngine.dll`) as NuGet packages.

## Usage

In your project's `.csproj` file, add the following properties:

```xml
<PropertyGroup>
    <UnityVersion>2019.1.6f1</UnityVersion>
    <ReferenceUnityEngine>true</ReferenceUnityEngine>
</PropertyGroup>
```

## FAQ

- **Is this legal?** We surely hope so!

- **How does it work?** MSBuild, baby.
