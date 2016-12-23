@echo off
SET clr=$false
IF [%1] NEQ [] (
  IF [%1] EQU [-clear] (
    SET clr=$true
  )
)
powershell -ExecutionPolicy Bypass create-eclipse-shortcuts.ps1 -Clear %clr%
