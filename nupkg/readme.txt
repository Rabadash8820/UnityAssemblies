
            .:dx,  ,xd:.
        .'lkXWMX;  ;XMWXkc'.
     .;o0NMMMMNk'  'kNMMMMN0o;.
   .dKWMMMMXkl,.    .,lkXMMMMW0o.      _    _       _ _
   :0XXNWMW0:.        .:0WMNXKOx,     | |  | |     (_) |
   ;OKKKKXNWNKxc'..'cxKNNK0Okxxd,     | |  | |_ __  _| |_ _   _
   ;OKK0dlx0XNNWXKKXNXKOxo:lxxxd,     | |  | | '_ \| | __| | | |
   ;OKKO; .':dOKXXK0kdc,.  ,dxxd,     | |__| | | | | | |_| |_| |
   ;OKKO;     ,x0Okko'     ,dxxd,      \____/|_| |_|_|\__|\__, |
   ;O0kl.     .d0Okkl.     .:oxd,                          __/ |
   .:,...,'.  .d0Okkl.   ... .';.                         |___/
     .:dO0Oxl,;x0Okkl'':ldxdl;.
     .;ok0KKK0O00Okkxdxxxxxo:,.
        .,cdO0KK0Okkxxxdl;..
            .;ok0Okxoc,.
               .,;,'.



Thank you for installing the Unity3D NuGet package!

To use this package, add lines like the following to your .csproj file (or any imported MSBuild project file).

    <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
            <UnityVersion>2023.2.20f1</UnityVersion>
            <!-- or -->
            <UnityProjectPath>$(MSBuildProjectDirectory)\relative\path\to\UnityProject</UnityProjectPath>
        </PropertyGroup>
        <ItemGroup>
            <PackageReference Include="Unity3D" Version="3.0.0" />
        </ItemGroup>
    </Project>

For complete documentation, see the README on GitHub: https://github.com/Rabadash8820/UnityAssemblies/blob/master/README.md