@echo off

:: BatchGotAdmin
:-------------------------------------
REM
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set "params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

@echo off
echo ===========================================================
echo !! Powered by Teracy                                     !!
echo !! This script will install VirtualBox and Vagrant on    !!
echo !! your computer. Please say NO during the setup when    !!
echo !! you see the message "Restart your computer". We will  !!
echo !! do it when complete.                                  !!
echo ===========================================================
echo ...........................................................
echo Prepare and downloading resources
copy /y NUL c:\dp.ps1 >NUL

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/teracy-official/dev/v0.4.2/scripts/Download-File.ps1', 'c:\dp.ps1')"

echo Prepare completed

echo.

echo --- Findding installed vagrant and virtualbox ---
echo.

setlocal EnableDelayedExpansion
set vagrantV=0.0
set vboxV=0.0
set restart="false"

set LF=^

:findVagrant
echo.
echo ..............Findding vagrant..............
echo.

for /F "skip=1 tokens=1" %%a in ('wmic product where "Name like 'vagrant'" get Version') do (
	set "item=%%a"
	call :removeCR
	if !vagrantV! EQU 0.0 (
			if not "!item!"=="" set vagrantV=!item!
		)
)

IF %ERRORLEVEL% NEQ 0 GOTO vagrantNotfound
IF %vagrantV% EQU 0.0 GOTO vagrantNotfound

set vagrantVs=%vagrantV:.=%

if %vagrantVs% LSS 162 (
		echo Vagrant found with version %vagrantV% that is not valid, process next step
		GOTO processVagrant
	)
echo Vagrant found with a valid version (%vagrantV%)
GOTO findVBox


:vagrantNotfound
echo Vagrant notfound, process to download
GOTO processVagrant

:findVBox
echo.
echo ..............Findding virtualbox.............
echo.

for /F "skip=1 tokens=1" %%b in ('wmic product where "Name like 'Oracle VM VirtualBox%%'" get Version') do (
	set "item=%%b"
	call :removeCR
	if !vboxV! EQU 0.0 (
			if not "!item!"=="" set vboxV=!item!
		)
)

IF %ERRORLEVEL% NEQ 0 GOTO vboxNotfound
IF %vboxV% EQU 0.0 GOTO vboxNotfound

set vboxVs=%vboxV:.=%


if %vboxVs% LSS 4312 (
		echo VirtualBox found with version %vboxV% that is not valid, process next step
		GOTO processVBox
	)
echo VirtualBox found with a valid version (%vboxV%)
GOTO mainProcess

:vboxNotfound
echo VirtualBox notfound, process to download
GOTO processVBox

:processVBox
echo.
echo --- DOWNLOAD and INSTALL VIRTUAL BOX ---
echo.

copy /y NUL c:\vbox.exe >NUL
powershell -ExecutionPolicy RemoteSigned -File "c:\dp.ps1" "http://download.virtualbox.org/virtualbox/4.3.20/VirtualBox-4.3.20-96997-Win.exe" "c:\vbox.exe"


echo Virtual Box is installing
START /wait /b C:\vbox.exe

set restart="true"

GOTO mainProcess

echo ...........................................................

:processVagrant
echo.
echo --- DOWNLOAD and INSTALL VAGRANT ---
echo.

copy /y NUL c:\vgrant.msi >NUL
powershell -ExecutionPolicy RemoteSigned -File "c:\dp.ps1" "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1.msi" "c:\vgrant.msi"

echo Vagrant is installing
start /wait /b C:\vgrant.msi

set restart="true"

GOTO findVBox

:mainProcess

set pathToInsert=%ProgramFiles%\Oracle\VirtualBox
setx path "%pathToInsert%;%PATH%"

echo.

:: delete temp file
IF EXIST c:\vgrant.msi del c:\vgrant.msi
IF EXIST c:\vbox.exe  del c:\vbox.exe
IF EXIST c:\dp.ps1  del c:\dp.ps1

if %restart% EQU "false" GOTO END


SET /P AREYOUSURE=Do you want to restart your computer now. It will apply changes and config (y/N)?


IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

shutdown.exe /r

:END

pause

goto :eof
:removeCR

:removeCR
set "Item=%Item%"
exit /b


:exit
