@echo off
set OLD_CD=%CD%
cd %~dp0\grammar
java -jar c:\c\Bin\antlr-4.7.1-complete.jar -Dlanguage=Cpp -package alf::parser -o ..\parser ALF.g4
cd %OLD_CD%
