                               
                   ........    
              .............    
             .,*(%&@&,......   
        ...,%@@@@@@%,..*&,..                  _ _         
      ...,%@@@@@@@%...(@@(...                (_) |        
    ...,%@@@@@@@@#...#@@@&,...    _   _ _ __  _| |_ _   _ 
  ..................%@@@@@#.     | | | | '_ \| | __| | | |
  .....,,,,,,,,,,...(@@@@@(..    | |_| | | | | | |_| |_| |
    ..../&@@@@@@@&,../@@@&,...    \__,_|_| |_|_|\__|\__, |
      ..../&@@@@@@&,../@@/...                        __/ |
        ..../&@@@@@@*..*%,..                        |___/ 
             ...,*(%&/......   
              .............    
                     ......    

Thank you for installing the Unity3D NuGet package!

Example .csproj file (using Unity 2019.2.12f1, targeting .NET Standard 2.0 profile):

    <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
            <TargetFramework>netstandard2.0</TargetFramework>
            <UnityVersion>2019.2.12f1</UnityVersion>
        </PropertyGroup>
        <ItemGroup>
            <PackageReference Include="Unity3D" Version="1.3.0" />
        </ItemGroup>
    </Project>

For complete documentation, see our README on GitHub: https://github.com/DerploidEntertainment/UnityAssemblies/blob/master/README.md