# Versioning
This is version 1.0.0 of the assembly refactoring Library

This package is available from nuget at: https://www.nuget.org/packages/AssemblyRefactoringDotNet/1.0.0

The source for this release is available on github at: https://github.com/hannasm/AssemblyRefactoringDotNet/releases/tag/1.0.0

# AssemblyRefactoringDotNet
This is a library for performing post-compilation refactorings on 
.NET assemblies. 

At this point this really has only been thought out to solve 
a very specific problem related to shared libraries and DLL 
versioning. In this use case, a library published through nuget 
(or whatever other means) in binary form creates a hard dependency
on this library going forward. If another nuget package takes a 
dependency on this same library, but the version of the dependency 
is different, you have a major issue of trying to resolve these
versioning conflicts. If this same situation occurs across multiple
dependencies with a deep hierarchy, you may be forced to
choose between the libraries with incompatible dependencies.

This dll versioning issue is not necesarry though. Through the use of 
assembly refactoring, you can relocate a version of the conflicting DLLs 
to a different namespace, and with a different filename. You can further 
relocate any references to the DLL in downstream assemblies. This creates 
a perfectly legal overlap between two versions of the same code base
in a single process. 

There may still be issues to resolve. The two different versions will not be 
compatible in terms of type safety, but you can at least compile and write code, 
and you should in many cases be able to create wrappers between the two libraries 
if sharing is necesarry.

# Usage

The easiest way to use this code is to load the dll into a running powershell environment
and invoke the requisite methods directly. It is also possible to reference the dll and create a 
managed application in any form of your choosing to use these methods.

An example of refactoring using powershell follows:

$binPath = 'C:\test\bin'
$targetDll = join-path $binPath 'AssemblyRefactoring.Test.dll'
$newDll = join-path $binPath 'AssemblyRefactoring.Test.V2.dll'
$targetNS = 'AssemblyRefactoring.TestDll';
$newNS = 'AssemblyRefactoring.TestDll.V2';
$oldAssemREf = $oldNS;
$oldAssem = $oldNS;
$newAssemRef = $newNS;
$newAssem = $newNS;

import-module (join-path $binPath 'AssemblyRefactoring.dll');

$x = new-object AssemblyRefactoring.AssemblyRefactoringContext $targetDll
$x.RenameNamespace($oldNS, $newNS);
$x.RenameAssemblyReference($oldAssemRef, $newAssemRef);
$x.RenameAssemblyName($oldAssem,$newAssem);
$x.Save( $newDll )

# Testing

There is currently no automated testing available for this project. The code, at one point,
was verified manually to properly refactor assemblies, including deep dependency hierarchies,
but this is always going to be rolling target as new scenarios that i currentlty
haven't accounted for present themselves. 


# Changelog

## 1.0.0
  * This initial release covers the basic use case for which the library, thus far, has been developed, and nothing more

