cd $MY_PROJECTS_DIR

$ENV:GIT_SSH = "$MY_TOOLS_DIR\PuTTY\PLINK.EXE"
$ENV:PATH   += ";$MY_TOOLS_DIR\SourceControl\Git\Cmd"
$ENV:PATH   += ";$MY_TOOLS_DIR\SourceControl\GitTfs"
$ENV:PATH   += ";$MY_TOOLS_DIR\SourceControl\Mercurial"
$ENV:PATH   += ";$MY_TOOLS_DIR\SourceControl\Svn\bin"
$ENV:PATH   += ";$MY_TOOLS_DIR\PuTTY"
$ENV:PATH   += ";$MY_TOOLS_DIR\cURL"
$ENV:PATH   += ";C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE"

New-Alias ex C:\Windows\explorer.exe
New-Alias n++ "$MY_TOOLS_DIR\Notepad++\Notepad++.exe"

function Start-Pageant { 
	
	$pageantProcess = Get-Process | ? { $_.ProcessName -eq 'pageant' }
	$alreadyStarted = $pageantProcess -ne $NULL
	
	if(-not $alreadyStarted) {
		PAGEANT $MY_SSH_PPK
	}
}

function Prompt {
	Write-Host "PS" -NoNewline
	Write-Host " "  -NoNewline
	Write-Host $(pwd).Path -ForegroundColor Cyan  -NoNewline
	Write-Host ">"         -ForegroundColor White -NoNewline
	return " "
}

Export-ModuleMember -function Prompt
Export-ModuleMember -function Start-Pageant
Export-ModuleMember -Alias ex
Export-ModuleMember -Alias n++
