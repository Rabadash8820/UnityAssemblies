
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

To use this package, define a Directory.Build.props file in the same folder as your .csproj file (or any of its parent folders),
and add code like the following:

    <!-- Directory.Build.props -->
    <Project>
        <PropertyGroup>
            <UnityVersion>2023.1.8f1</UnityVersion>
            <!-- or -->
            <UnityProjectPath>$(MSBuildProjectDirectory)\relative\path\to\UnityProject</UnityProjectPath>
        </PropertyGroup>
    </Project>

Then, make sure your .csproj file looks something like this:

    <!-- YourProject.csproj -->
    <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
            <TargetFramework>netstandard2.1</TargetFramework>
        </PropertyGroup>
        <ItemGroup>
            <PackageReference Include="Unity3D" Version="2.1.3" />
        </ItemGroup>
        <!-- Other properties/items -->
    </Project>

For complete documentation, see the README on GitHub: https://github.com/Rabadash8820/UnityAssemblies/blob/master/README.md