mode con lines=20000 cols=200

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
