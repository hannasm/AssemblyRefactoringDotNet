param ($solutionDir);

$metadataPath = join-path $solutionDir 'metadata.xml';
if (!(test-path $metadataPath)) {
	throw ('unable to find solution metadata at ' + $metadataPath);
}
$sai = join-path $solutionDir 'SharedAssemblyInfo.cs';

if (test-path $sai) {
	if ( (get-item $sai).LastWriteTime -gt (get-item $metadataPath).LastWriteTime) {
		write-host 'Determined that shared assemblyInfo.cs is up-to-date, skipping code generator...';
		exit 0;
	}
}

write-host 'generating SharedAssemblyInfo.cs from metadata';

$metadata = [xml](get-content $metadataPath);
$metadata = $metadata.solution;
if (!$metadata) {
	throw ('metadata file  at ' + $metadataPath + ' is missing root solution node');
}

'using System.Reflection;' | out-file -Force $sai;
'using System.Runtime.CompilerServices;' | out-file -Append $sai;
'using System.Runtime.InteropServices;'  | out-file -Append $sai;

'[assembly: AssemblyVersion("' + $metadata.version + '")]'  | out-file -Append $sai;
'[assembly: AssemblyFileVersion("' + $metadata.version + '")]'  | out-file -Append $sai;