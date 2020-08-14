$PROJECTS = "$HOME\Projects"
$TOOLS    = "$HOME\Tools"
$DESKTOP  = "$HOME\Desktop"

$specifyDirCommands  = '\b(Set-Location|sl|cd|chdir|Push-Location|pushd|pul)\b'
$specifyDirArguments ='^-(WorkingDirectory|wd|wo|wor|work)'

$dirSpecifiedByCommand  = [Environment]::CommandLine -match $set_dir_comands
$dirSpecifiedByArgument = $PSVersionTable.PSEdition -ne 'Desktop' -and [Environment]::GetCommandLineArgs() -match $set_dir_arguments

$dirSpecified = $dirSpecifiedByCommand -or $dirSpecifiedByArgument

#for $Env:vscode you must manually add "vscode" to
#terminal.integrated.env.windows in workspace or 
#user vscode settings
if (-not $dirSpecified -and -not $Env:vscode) {
    cd $PROJECTS
}

$ENV:PATH += ";"
$ENV:PATH += "$TOOLS\7-Zip\Application\;"
$ENV:PATH += "$TOOLS\hugo\;"

New-Alias ex C:\Windows\explorer.exe
New-Alias n++ "$TOOLS\Notepad++\Notepad++.exe"

Set-PSReadlineOption -BellStyle None

#this assumes that bash for windows is enabled
function vim ($file){
	bash -c "vim -c 'setlocal ff=dos' $($file -replace '\\', '/' -replace ' ', '\ ')"
}

function Prompt {
	Write-Host "PS" -NoNewline
	Write-Host " "  -NoNewline
	Write-Host $(pwd).Path -ForegroundColor Cyan  -NoNewline
	Write-Host ">"         -ForegroundColor White -NoNewline
	return " "
}

Export-ModuleMember -function Prompt, vim -Alias ex, n++ -Variable PROJECTS, TOOLS, DESKTOP