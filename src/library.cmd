@echo off
SetLocal

if [%1] == [--help] (
	call :helpAction
	exit /b 1
) else if [%1] == [/?] (
	call :helpAction
	exit /b 1
)  else if [%1] == [-h] (
	call :helpAction
	exit /b 1
) else if [%1] == [] (
	call :helpAction
	exit /b 1
)

if [%1] == [-a] (
	call :addAction %2 %3
) else if [%1] == [--add] (
	call :addAction %2 %3
) else if [%1] == [/a] (
	call :addAction %2 %3
) else if [%1] == [/add] (
	call :addAction %2 %3
)

if [%1] == [-r] (
	call :removeAction %2 %3
) else if [%1] == [--remove] (
	call :removeAction %2 %3
) else if [%1] == [/r] (
	call :removeAction %2 %3
) else if [%1] == [/remove] (
	call :removeAction %2 %3
)

goto :EOF

:helpAction
	call :help
exit /b %errorlevel%

:addAction
	call :add %1 %2
	
	if errorlevel (
		echo.The folder could not be linked to.
	) else (
		echo.The folder was successfully linked to in the library.
	)
exit /b %errorlevel%

:removeAction
	call :remove %1 %2

	if errorlevel (
		echo.The folder could not be removed.
	) else (
		echo.The folder was successfully removed from the library.
	)
exit /b %errorlevel%



:help
	echo.Manages libraries and allows the addition of network shares.
	echo.
	echo.library ^[ --add, -a ^| --remove, -r ^] %%folder%% %%library%%

:add
	:: check if folder parameter was given
	if [%1] == [] (
		:: set placeholder value so batch won't refuse to parse the code
		set folder=NUL

		echo.No folder given.
		echo.Syntax:
		echo.library ^[ --add, -a ^| --remove, -r ^] %%folder%% %%library%%
		exit /b 1

	) else (
		set folder=%1
	)

	:: check if library parameter was given
	if [%1] == [] (
		:: set placeholder value so batch won't refuse to parse the code
		set library=NUL

		echo.No library given.
		echo.Syntax:
		echo.library ^[ --add, -a ^| --remove, -r ^] %%folder%% %%library%%
		exit /b 1

	) else (
		set library=%2
	)

	:: wether the links folder already exists
	if not exist %appdata%\LibraryLinks (
		mkdir %appdata%\LibraryLinks
	)
	
	:: take the last folder from path
	for %%f in (%folder%) do set foldername=%%~nxf
	
	:: wether we have a network location or not
	if [%folder:~0,2%] == [\\] (

		:: set the target path
		set tempPath=%appdata%\LibraryLinks\%foldername%

		:: because batch refuses to build the path if not given a second of time
		:: yup, thats the strange batch voodoo magic you've heard about.
		timeout 1 1>nul 2>&1
		
		:: create a temporary link target
		mkdir %tempPath% 1>nul 2>&1
		if errorlevel (
			echo.The temporary target could not be created. Check permissions.
			exit /b 1
		)

		:: add the temporary target to the library
		%~dp0shlib\shlib add "%appdata%\Microsoft\Windows\Libraries\%library%.library-ms" "%tempPath%" 1>nul 2>&1
		if errorlevel (
			echo.The folder could not be added to the library.
			exit /b 1
		)

		:: remove the temporary target
		rmdir /q %tempPath% 1>nul 2>&1
		if errorlevel (
			echo.The temporary target could not be removed. Check permissions.
			exit /b 1
		)

		:: make a soft link to the real path
		mklink /d %tempPath% %folder% 1>nul 2>&1
		if errorlevel (
			echo.The link to the network directory could not be created. Check permissions.
			exit /b 1
		)
		
		:: finished successfully
		exit /b 0
	) else (
		:: add the target to the library
		%~dp0shlib\shlib add "%appdata%\Microsoft\Windows\Libraries\%library%.library-ms" "%folder%" 1>nul 2>&1
		if errorlevel (
			echo.The folder could not be added to the library.
			exit /b 1
		)
	)

:remove
	:: check if folder parameter was given
	if [%1] == [] (
		:: set placeholder value so batch won't refuse to parse the code
		set folder=NUL

		echo.No folder given.
		echo.Syntax:
		echo.library ^[ --add, -a ^| --remove, -r ^] %%folder%% %%library%%
		exit /b 1

	) else (
		set folder=%1
	)

	:: check if library parameter was given
	if [%1] == [] (
		:: set placeholder value so batch won't refuse to parse the code
		set library=NUL

		echo.No library given.
		echo.Syntax:
		echo.library ^[ --add, -a ^| --remove, -r ^] %%folder%% %%library%%
		exit /b 1

	) else (
		set library=%2
	)

	:: take the last folder from path
	for %%f in (%folder%) do set foldername=%%~nxf
	
	:: wether we have a network location or not
	if [%folder:~0,2%] == [\\] (

		:: set the target path
		set tempPath=%appdata%\LibraryLinks\%foldername%

		:: because batch refuses to build the path if not given a second of time
		:: yup, thats the strange batch voodoo magic you've heard about.
		timeout 1 1>nul 2>&1
		
		:: remove the softlink (contrary to "del", "rmdir" will only delete the link, not the target)
		rmdir /q %tempPath% 1>nul 2>&1
		if errorlevel (
			echo.The link file could not be removed. Check permissions.
			exit /b 1
		)
	)

	:: remove the target from the library
	%~dp0shlib\shlib remove "%appdata%\Microsoft\Windows\Libraries\%library%.library-ms" "%folder%" 1>nul 2>&1
	if errorlevel (
		echo.The folder could not be removed from the library.
		exit /b 1
	)

EndLocal
