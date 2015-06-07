$script:_projects             = $NULL
$script:_projectRootDirectory = "$HOME\My Projects"
$script:_projectPatterns      = ('*.sln')

if(Test-Path function:\TabExpansion){
	Copy function:\TabExpansion function:\MyProjects-OriginalTabExpansion
}

function Get-Projects {
	param(
		[switch] $refresh
	)
	
	$projectsNotInitialized = $NULL -eq $script:_projects
    
	if($projectsNotInitialized -or $refresh){
		$script:_projects = gci -path $script:_projectRootDirectory -recurse -include $script:_projectPatterns
	}

	return $script:_projects
}

function Start-Projects {
	Param([Parameter(ValueFromPipeline=$True)] [string] $projectNames)

	Process {
		foreach($projectName in $projectNames) {
			$projectWithSameName       = Get-Projects | ? { $_.Name -eq $projectName }
			$projectExistsWithSameName =  $projectWithSameName -ne $NULL
			
			if($projectExistsWithSameName) {
				"Opening $($projectWithSameName.FullName)"
				ii $projectWithSameName.FullName
			}
			else {
				"Sorry but no project with the name $projectName was found."
			}
		}
	}
}

function TabExpansion([string] $line, [string] $lastword) {
	if($line -eq "Start-Projects $lastword" -or $line -eq "SP $lastword") {
		$(Get-Projects).Name | ? { $_ -match $lastword  }
	}
	else {
		MyProjects-OriginalTabExpansion $line $lastword
	}
}



Export-ModuleMember -function Get-Projects
Export-ModuleMember -function Start-Projects
Export-ModuleMember -function TabExpansion
Export-ModuleMember -Alias GP
Export-ModuleMember -Alias SP
