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
	bitsadmin /transfer NETFX  /download /priority normal http://dlc.sun.com.edgesuite.net/virtualbox/4.3.12/VirtualBox-4.3.12-93733-Win.exe c:\vbox.exe
	)

echo Virtual Box is installing
START /wait /b C:\vbox.exe

pause

echo ...........................................................   

echo Step 2: DOWNLOAD and INSTALL VAGRANT
pause

IF NOT EXIST c:\vgrant.msi (
	bitsadmin.exe /transfer NETFX  /download /priority normal "http://d29vzk4ow07wi7.cloudfront.net/1171d5178b706f9a9ed11163d39a4be1c7300387?response-content-disposition=attachment%3Bfilename%3D%22vagrant_1.6.3.msi%22&Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHAqOi8vZDI5dnprNG93MDd3aTcuY2xvdWRmcm9udC5uZXQvMTE3MWQ1MTc4YjcwNmY5YTllZDExMTYzZDM5YTRiZTFjNzMwMDM4Nz9yZXNwb25zZS1jb250ZW50LWRpc3Bvc2l0aW9uPWF0dGFjaG1lbnQlM0JmaWxlbmFtZSUzRCUyMnZhZ3JhbnRfMS42LjMubXNpJTIyIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNDAxOTU2Mzg3fSwiSXBBZGRyZXNzIjp7IkFXUzpTb3VyY2VJcCI6IjAuMC4wLjAvMCJ9fX1dfQ__&Signature=aXWv4dSNwQOkL0E9q19KL5al5MnuZuxIPhR2gPtFFEAak5VNuBCSH7F-ISpezB3C8uuqYKDQx~6a6y~YqeazHUFGJmys9sWLsT6J6qwq89Hp2kxy5Hzn7u02n1-1CEc5nZ4x49vVZmzCTK~J-1BDySPEd-elkt3zZioZ60zrCwvl6DYruRErigo89IHWNcAJa1srvXyr9mQlGnud1NUeK8jMHaF0kV2Lq0M92ELxw7BFNuw3PAlnwDc0JLSFUf~f1URT9s6fuD3nYg7kViQPa8IBtTIBT9WOmxA6EOPQG-i-lrzpuSs3ca6RU1reUwNXiuHNNHGgD5Pab9PDa5dPnQ__&Key-Pair-Id=APKAIQIOJCQ5764M5VTQ" c\vgrant.msi
	)

echo Vagrant is installing
start /wait /b C:\vgrant.msi

echo ...........................................................   

echo Check Environment Variable

set pathToInsert=%ProgramFiles%\Oracle\VirtualBox
setx Teracy "%pathToInsert%" 

echo ...........................................................   

setlocal
:PROMPT
SET /P AREYOUSURE=Do you want to restart your computer now. It will apply changes and config (y/N)?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
	echo restart
	::shutdown.exe /l 
:END
endlocal

pause

