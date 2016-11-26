$solutionDir = split-path $dte.Solution.Properties('Path').Value -parent;

function publish($version, $package) {
	if (!(test-path $package)) {
		throw ('Unable teo find nuget package ' + $package + ' for publishing');
	}
	nuget push $package;
}

$metadataPath = join-path $solutionDir 'metadata.xml';
if (!(test-path $metadataPath)) {
	throw ('unable to find solution metadata at ' + $metadataPath);
}
$metadata = [xml](get-content $metadataPath);
$metadata = $metadata.solution;
if (!$metadata) {
	throw ('metadata file  at ' + $metadataPath + ' is missing root solution node');
}

$version = $metadata.version;

publish $version (join-path $solutionDir ('ExpressiveAssertions.' + $version + '.nupkg'));
publish $version (join-path $solutionDir ('ExpressiveAssertions.' + $version + '.symbols.nupkg'));
publish $version (join-path $solutionDir ('ExpressiveAssertions.MSTest.' + $version + '.nupkg'));
publish $version (join-path $solutionDir ('ExpressiveAssertions.MSTest.' + $version + '.symbols.nupkg'));