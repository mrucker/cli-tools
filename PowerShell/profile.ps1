$PROJECTS = "$HOME\Projects"
$DESKTOP  = "$HOME\Desktop"

$specifyDirCommands  = '\b(Set-Location|sl|cd|chdir|Push-Location|pushd|pul)\b'
$specifyDirArguments ='^-(WorkingDirectory|wd|wo|wor|work)'

$dirSpecifiedByCommand  = [Environment]::CommandLine -match $specifyDirCommands
$dirSpecifiedByArgument = $PSVersionTable.PSEdition -ne 'Desktop' -and [Environment]::GetCommandLineArgs() -match $specifyDirArguments

$dirSpecified = $dirSpecifiedByCommand -or $dirSpecifiedByArgument

$Env:Path += ";$HOME\php"

New-Alias ex "C:\Windows\explorer.exe"
New-Alias n++ "C:\Program Files\Notepad++\notepad++.exe"

Set-PSReadlineOption -BellStyle None

function Prompt {
	Write-Host "PS" -NoNewline
	Write-Host " "  -NoNewline
	Write-Host $(pwd).Path -ForegroundColor Cyan  -NoNewline
	Write-Host ">"         -ForegroundColor White -NoNewline
	return " "
}

#for $Env:vscode you must manually add "vscode" to
#terminal.integrated.env.windows in workspace or 
#user vscode settings
if (-not $dirSpecified -and -not $Env:vscode) {
    cd $PROJECTS
}
