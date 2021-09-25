@echo off
set "LOGFILE=log.txt"
echo. >> %LOGFILE%
echo %date% %time% >> %LOGFILE%

echo Starting Tensorflow with Jupyter in Docker...
docker run -d --name tensorflow-jupyter --mount type=bind,src="%USERPROFILE%\Documents\Tensorflow Jupyter Notebooks",dst="/tf/Tensorflow Jupyter Notebooks" -it -p 8888:8888 tensorflow/tensorflow:latest-gpu-jupyter >> %LOGFILE% 2>&1

if %errorlevel% == 0 goto success

if %errorlevel% == 127 (
    echo Docker is not running, please start Docker Desktop.
    goto error
) else (
    if %errorlevel% == 125 (
        echo Container exists, starting it...
        echo Starting container >> %LOGFILE%

        REM Reset errorlevel to 0
        type nul>nul

        docker start tensorflow-jupyter >> %LOGFILE% 2>&1

        goto success
    ) else (
        echo Failed to start container: error %errorlevel%
        goto error
    )
)

:error
echo Error %errorlevel% >> %LOGFILE%
echo For more information see: %cd%\%LOGFILE%
pause
exit /b %errorlevel%

:success
echo Success >> %LOGFILE%
echo Done!
timeout /t 2 > NUL
exit /b 0