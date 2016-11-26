param ($solutionDir, $projectDir);

$metadataPath = join-path $solutionDir 'metadata.xml';
if (!(test-path $metadataPath)) {
	throw ('unable to find solution metadata at ' + $metadataPath);
}
$sai = join-path $projectDir 'Package.nuspec';

if (!(test-path $sai)) {
	throw ('unable to update nuget package version ' + $sai + ' because it does not exist');
}


$metadata = [xml](get-content $metadataPath);
$metadata = $metadata.solution;
if (!$metadata) {
	throw ('metadata file  at ' + $metadataPath + ' is missing root solution node');
}

$data = [xml](get-content $sai);
$updated = $false;
if (!$data.package.metadata.version) {
	throw ('nuget package ' + $sai + ' did not contain the appropriate metadta version element');
} elseif ($data.package.metadata.version -ne $metadata.version) {
	$data.package.metadata.version = $metadata.version;
	$updated = $true;
}
if (!$data.package.metadata.releaseNotes) {
	throw ('nuget package ' + $sai + ' did not contain the appropriate metadta releasenotes element');
} elseif ($data.package.metadta.releaseNotes -ne $metadata.releaseNotes) {
	$data.package.metadata.releaseNotes = $metadata.releaseNotes;
	$updated = $true;
}

if ($data.package.metadata.dependencies) {
  write-host 'checking dependencies';
  foreach ($dependency in $data.package.metadata.dependencies.group.dependency) {
    write-host ('checking dependency ' + $dependency.id);
	if ($dependency.id.StartsWith('ExpressiveAssertions') -and $dependency.version -ne $metadata.version) {
		$dependency.version = $metadata.version;
		$updated = $true;
	}
  }
}

if ($updated) {
	write-host ('updating nuget package for ' + $sai + ' from metadata');
	$data.Save($sai);
} else {
	write-host ('no update to nuget package ' + $sai + ' required...');
}