@echo off
echo ===========================================================
echo !! Powered by Teracy                                     !!
echo !! This script will install VirtualBox and Vagrant on    !!
echo !! your computer. Please say NO during the setup when    !! 
echo !! you see the message "Restart your computer". We will  !!
echo !! do it when complete.                                  !!
echo ===========================================================
echo ...........................................................                                                            

echo Step 1: DOWNLOAD and INSTALL VIRTUAL BOX
pause

IF NOT EXIST c:\vbox.exe (
	url2disk.exe -i http://dlc.sun.com.edgesuite.net/virtualbox/4.3.12/VirtualBox-4.3.12-93733-Win.exe -o c:\vbox.exe	
	)

echo Virtual Box is installing
START /wait /b C:\vbox.exe

pause

echo ...........................................................   

echo Step 2: DOWNLOAD and INSTALL VAGRANT
pause

IF NOT EXIST c:\vgrant.msi (
	url2disk https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.msi c:\vgrant.msi
	)

echo Vagrant is installing
start /wait /b C:\vgrant.msi

echo ...........................................................   

echo Check Environment Variable

set pathToInsert=%ProgramFiles%\Oracle\VirtualBox
setx path "%pathToInsert%;%PATH%" 

echo ...........................................................   

setlocal
:PROMPT
SET /P AREYOUSURE=Do you want to restart your computer now. It will apply changes and config (y/N)?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
	shutdown.exe /l 
:END
endlocal

pause

