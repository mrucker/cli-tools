cd $PROJECTS

$ENV:PATH += "$TOOLS\cURL\bin;"
$ENV:PATH += "$TOOLS\7-Zip\Application\;"
$ENV:PATH += "$env:appdata\npm\;"

New-Alias ex C:\Windows\explorer.exe
New-Alias n++ "$TOOLS\Notepad++\Notepad++.exe"

Set-PSReadlineOption -BellStyle None

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
