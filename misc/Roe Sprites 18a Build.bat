set stamp=%DATE% %TIME%

set stampdate=%stamp:~4,10%
set stamptime=%stamp:~-11,11%

set stampdate=%stampdate:~-4,4%%stampdate:~-10,2%%stampdate:~-7,2%

set stamptime=%stamptime:~0,2%%stamptime:~3,2%%stamptime:~6,2%%stamptime:~9,2%

set stamp=%stampdate:~0,4%-%stampdate:~4,2%%stampdate:~6,2%-%stamptime:~0,2%%stamptime:~2,2%-%stamptime:~4,2%%stamptime:~6,2%

echo DateTime: %stamp%

set timestamp=%stamp%

set compilerpath=C:\Program Files (x86)\FreeBASIC\fbc

set prjdrive=C
set prjroot=\AG47
set prjspc=roe 18a
set prjext=.bas
set prjres=.\rc\roe2.rc
set prjsuffix= 18a
set project=Roe Sprites

set debugspc=debug
set debugext=.txt

set revext=.log
set revfolder=Revision History

%prjdrive%:

set pathout=
set pathout=%pathout%%prjroot%
mkdir "%prjdrive%:%pathout%"
set pathout=%pathout%\%prjspc%
mkdir "%prjdrive%:%pathout%"
set pathout=%pathout%\%revfolder%
mkdir "%prjdrive%:%pathout%"
set pathout=%pathout%\%project%
mkdir "%prjdrive%:%pathout%"

set debugout=%prjdrive%:%prjroot%\%prjspc%\%debugspc%%debugext%

chdir "%prjdrive%:%prjroot%\%prjspc%\"

"%compilerpath%" "%prjdrive%:%prjroot%\%prjspc%\%project%%prjsuffix%%prjext%" -lang "fblite" -s gui "%prjres%" > "%debugout%"

cmd /c echo F | xcopy "%debugout%" "%pathout%\%debugspc% %timestamp%%revext%"

pause
sleep 10