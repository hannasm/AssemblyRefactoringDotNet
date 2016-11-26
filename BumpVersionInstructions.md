* Update README text to indicate current version
* Update Nuget Package Link in README.md
* Update source tag link in README.md
* Update Changelog at bottom of REAMDE.md
* Update Version Number in metadata.xml
* Update release notes in metadata.xml
  * build should automatically update package.nuspec and sharedAssemblyInfo.cs
* run 'powershell GenerateNugetPackages.ps1' from a visual studio command prompt (nuget needs to be on the path too)
* run 'powershell PublishNugetPackages.ps1' from a visual studio command prompt (nuget needs to be on the path and API key needs to be set)
* create tag for release on github