
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

Example .csproj file (using Unity 2021.2.2f1, targeting .NET Standard 2.1 profile):

    <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
            <TargetFramework>netstandard2.1</TargetFramework>
            <UnityVersion>2021.2.2f1</UnityVersion>
        </PropertyGroup>
        <ItemGroup>
            <PackageReference Include="Unity3D" Version="1.7.0" />
        </ItemGroup>
    </Project>

For complete documentation, see our README on GitHub: https://github.com/DerploidEntertainment/UnityAssemblies/blob/master/README.md