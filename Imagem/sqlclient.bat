@echo off

REM Script para instala��o do Client do SQL Server

REM Testa qual a vers�o do sistema operacional. X86 ou AMD64
IF %PROCESSOR_ARCHITECTURE%==x86 msiexec /package C:\Smart\Pb12dk\32\sqlncli.msi /passive
IF %PROCESSOR_ARCHITECTURE%==AMD64 msiexec /package C:\Smart\Pb12dk\64\sqlncli.msi /passive

Exit