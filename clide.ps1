$env:PATH += ";C:\Program Files\Java\jdk1.8.0_251\bin\"
$env:PATH += ";$env:USERPROFILE\Documents\gVimPortable\App\vim\vim80\"

$Run = $true
$Head = "cl[ide]"
#$editor = (Get-Command notepad -errorAction SilentlyContinue).Name
$editor = (Get-Command vim -errorAction SilentlyContinue).Name
$CWD = (Get-Location).Path
$Name = "cl[ide]"
$Version = "0.0.05"
$USER = $env:USERNAME
$ProgDir = "$env:USERPROFILE\Documents\Programs"
$PowerShellHome = "$ProgDir\PowerShell"
$PythonHome = "$ProgDir\Python"
$JavaHome = "$ProgDir\Java"
$PowerShellRun = (Get-Command PowerShell -errorAction SilentlyContinue).Name
$PythonRun = (Get-Command Python -errorAction SilentlyContinue).Name
$JavaCpl = (Get-Command javac -errorAction SilentlyContinue).Name
$JavaRun = (Get-Command java -errorAction SilentlyContinue).Name
$pg = ""
$Lang = ""

function MenuHelp
{
	"------------------[($Head) Menu]------------------"
	
}

function EnsureLangs
{
	$PsHere = ""
	$PyHere = ""
	$JaHere = ""
	if ($PowerShellRun)
	{
		$PsHere = "PowerShell"
	}
	if ($PythonRun)
	{
		$PyHere = "Python"
	}	
	if ($JavaRun)
	{
		$JaHere = "Java"
	}
	$pg = "$PsHere $PyHere $JaHere"
	return $pg.Trim()
}

function EnsureDirs
{
	if (! (Test-Path $ProgDir))
	{
		mkdir $ProgDir
	}
	if ($PowerShellRun)
	{
		if (! (Test-Path $PowerShellHome))
		{
			mkdir $PowerShellHome
		}
	}
	if ($PythonRun)
	{
		if (! (Test-Path $PythonHome))
		{
			mkdir $PythonHome
		}
	}
	if ($JavaRun)
	{
		if (! (Test-Path $JavaHome))
		{
			mkdir $JavaHome
		}
	}
}

function pgDir
{
	param (
		[string]$getLang
		)
	$ChosenDir = ""
	if ($getLang -eq "PowerShell")
	{
		$ChosenDir = $PowerShellHome
	}
	if ($getLang -eq "Python")
	{
		$ChosenDir = $PythonHome
	}
	if ($getLang -eq "Java")
	{
		$ChosenDir = $JavaHome
	}
	return $ChosenDir
}

#Get Language
function pgLang
{
	param (
		[string]$getLang
		)
		
	$LangArray = $pg.Split(" ")
	$lp = 0 
	$end = $LangArray.count
	$ChosenLang = "no"
	while ($lp -ne $end)
	{
		if ($getLang -eq $LangArray[$lp])
		{
			$ChosenLang = $getLang
			break
		}
		$lp++
	}
	return $ChosenLang
}

function editCode
{
	param (
		[string[]]$UserIn
		)
	$Lang = $UserIn[0]
	$Code = $UserIn[1]
	switch($Lang) {
		"PowerShell"{
			if ($Code -like "*.ps1")
			{
				& $editor $Code
			}
		}
		"Python"{
			if ($Code -like "*.py")
			{
				& $editor $Code
			}
		}
		"Java"{
			if ($Code -like "*.java")
			{
				& $editor $Code
			}
		}
	}
}

function readCode
{
	param (
		[string[]]$UserIn
		)
	$Lang = $UserIn[0]
	$Code = $UserIn[1]
	switch($Lang) {
		"PowerShell"{
			if ($Code -like "*.ps1")
			{
				more $Code
			}
		}
		"Python"{
			if ($Code -like "*.py")
			{
				more $Code
			}
		}
		"Java"{
			if ($Code -like "*.java")
			{
				more $Code
			}
		}
	}
}

function selectCode
{
	param (
		[string[]]$UserIn
		)
	$Code = $UserIn[0]
	$Name = $UserIn[1]
	$OldCode = $UserIn[2]
	switch($Code) {
		"PowerShell"{
			if (! ($Name -like "*.ps1"))
			{
				$Name = "$Name.ps1"
			}
		}
		"Python"{
			if (! ($Name -like "*.py"))
			{
				$Name = "$Name.py"
			}
		}
		"Java"{
			if (! ($Name -like "*.java"))
			{
				$Name = "$Name.java"
			}
		}
		default {
			$Name = $OldCode
		}
	}
	return $Name
}

function RunCode
{
	param (
		[string[]]$UserIn
		)
	$Lang = $UserIn[0]
	$Name = $UserIn[1]
	$Project = $UserIn[2]
	$Type = $UserIn[3]
	switch($Lang) {
		"PowerShell"{
			if ($Name -like "*.ps1")
			{
				& $PowerShellRun $Name
			}
		}
		"Python"{
			if ($Name -like "*.py")
			{
				& $PythonRun $Name
			}
		}
		"Java"{
			if ($Name -like "*.java")
			{
				$Name = ($Name).replace(".java","")
				& $JavaRun $Name
			}
		}
	}
}

function compileCode
{
	param (
		[string[]]$UserIn
		)
	$Lang = $UserIn[0]
	$Name = $UserIn[1]
	$Project = $UserIn[2]
	$Type = $UserIn[3]
	switch($Lang) {
		"PowerShell"{
			if ($Name -like "*.ps1")
			{
				"[PowerShell Code Compiled]"
			}
			$null >> $Name
		}
		"Python"{
			if ($Name -like "*.py")
			{
				"[Python Code Compiled]"
			}
		}
		"Java"{
			if ($Name -like "*.java")
			{
				& $JavaCpl $Name
				"[Java Code Compiled (CLASS)]"
			}
		}
	}
}

function newCode
{
	param (
		[string[]]$UserIn
		)
	$Lang = $UserIn[0]
	$Name = $UserIn[1]
	$Project = $UserIn[2]
	$Type = $UserIn[3]
	switch($Lang) {
		"PowerShell"{
			if (! ($Name -like "*.ps1"))
			{
				$Name = "$Name.ps1"
			}
			$null >> $Name
		}
		"Python"{
			if (! ($Name -like "*.py"))
			{
				$Name = "$Name.py"
			}
			$PythonTemplate = Test-Path $PythonHome\newPython.py
			if ($PythonTemplate)
			{
				$Name = ($Name).replace(".py","")
				& $PythonRun newPython.py -n $Name --cli --main --shell -w -r -o
				$Name = "$Name.py"
			}
			else
			{
				$null >> $Name
			}
		}
		"Java"{
			if (! ($Name -like "*.java"))
			{
				$Name = "$Name.java"
			}
			$JavaTemplate = Test-Path $JavaHome\newJava.class
			if ($JavaTemplate)
			{
				$Name = ($Name).replace(".java","")
				& $JavaRun newJava --user $USER -n $Name --main -w -r -u
				$Name = "$Name.java"
			}
			else
			{
				$null >> $Name
			}
		}
		default {
			$Name = $OldCode
		}
	}
	return $Name
}

#Run Program
function Actions
{
	param (
		[string[]]$UserPrompt
	)
	$Lang = $UserPrompt[0]
	$Code = $UserPrompt[1]
	while ($Run)
	{
		#User Input
		if ($Code)
		{
			$UserIn = Read-Host -Prompt "$Name($Lang){$Code}>"
		}
		else
		{
			$UserIn = Read-Host -Prompt "$Name($Lang)>"
		}
		#Split into array
		$UserArray = $UserIn.Split(" ")
		$TheAction = $UserArray[0].ToLower()
		switch($TheAction) {
			"get-childItem" {
				(Get-ChildItem).name
			}
			"ls" {
				(Get-ChildItem).name
			}
			"ll" {
				Get-ChildItem
			}
			"clear-host" {
				Clear-Host
			}
			"clear" {
				Clear-Host
			}
			"set" {
				$Code = selectCode($Lang,$UserArray[1],$Code)
			}
			"unset" {
				$Code = ""
			}
			"set-location" {
				"set-location of dir"
			}
			"use" {
				$getLang = pgLang($UserArray[1])
				if ($getLang -ne "no")
				{
					$Lang = $getLang
					$GoTo = pgDir($Lang)
					Set-Location $GoTo
					$Code = ""
				}
			}
			"powershell" {
				$getLang = pgLang("PowerShell")
				if ($getLang -ne "no")
				{
					$Lang = $getLang
					$GoTo = pgDir($Lang)
					Set-Location $GoTo
					$Code = ""
				}
			}
			"python" {
				$getLang = pgLang("Python")
				if ($getLang -ne "no")
				{
					$Lang = $getLang
					$GoTo = pgDir($Lang)
					Set-Location $GoTo
					$Code = ""
				}
			}
			"java" {
				$getLang = pgLang("Java")
				if ($getLang -ne "no")
				{
					$Lang = $getLang
					$GoTo = pgDir($Lang)
					Set-Location $GoTo
					$Code = ""
				}
			}
			"new" {
				$CodeName = $UserArray[1]
				switch($CodeName) {
					"-v" {
						"Template Version"
					}
					"--version" {
						"Template Version"
					}
					"--help" {
						"new code help"
					}
					"-h" {
						"new code help"
					}
					default {
						if ($CodeName)
						{
							$Code = newCode($Lang,$CodeName,"","")
						}
						else
						{
							"newCodeHelp $Lang"
						}
					}
				}
			}
			"edit" {
				if ($Code)
				{
					editCode($Lang,$Code)
				}
			}
			"ed" {
				if ($Code)
				{
					editCode($Lang,$Code)
				}
			}
			"add" {
				"add code"
			}
			"read" {
				readCode($Lang,$Code)
			}
			"search" {
				"search for element"
			}
			"create" {
				switch($UserArray[1]) {
					"jar" {
						"make manafest.mf"
					}
					"args" {
						"make prgram args"
					}
					"reset" {
						"clear stuff"
					}
				}
			}
			"cpl" {
				compileCode($Lang,$Code,"","")
			}
			"exe" {
				RunCode($Lang,$Code,"","")
			}
			"run" {
				RunCode($Lang,$Code,"","")
			}
			"version" {
				$Version
			}
			"help" {
				MenuHelp
			}
			#Exit cl[ide]
			"exit" {
				Set-Location $CWD
				$Run = $false
			}
		}
	}
}

$pg = EnsureLangs
EnsureDirs
"~Choose a language~"
$getLang="no"
while ($getLang -eq "no")
{
	$UserIn = Read-Host -Prompt "$Name($pg)>"
	if ($UserIn -eq "exit")
	{
		break
	}
	else
	{
		$getLang = pgLang($UserIn)
	}
}
$GoTo = pgDir($getLang)
Set-Location $GoTo
if ($getLang -ne "no")
{
	Actions($getLang)
}