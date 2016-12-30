cd $MY_PROJECTS_DIR

$ENV:PATH   += ";$MY_TOOLS_DIR\PuTTY"
$ENV:PATH   += ";$MY_TOOLS_DIR\cURL"

New-Alias ex C:\Windows\explorer.exe
New-Alias n++ "$MY_TOOLS_DIR\Notepad++\Notepad++.exe"

function Prompt {
	Write-Host "PS" -NoNewline
	Write-Host " "  -NoNewline
	Write-Host $(pwd).Path -ForegroundColor Cyan  -NoNewline
	Write-Host ">"         -ForegroundColor White -NoNewline
	return " "
}

Export-ModuleMember -function Prompt
Export-ModuleMember -Alias ex
Export-ModuleMember -Alias n++
