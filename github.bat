@echo off 
git init 
git add -A

rem set /p repo="Enter Repo Name : "
git remote add origin https://github.com/tahaTWM/ToDoApp_FullApp.git

rem set /p id="Enter Commit Message : "
set TM=%DATE%, %TIME%

git commit -m "%TM%"

rem set /p branch="main or master ? "
rem if %branch% == main (git branch -M %branch%) 


git push -u origin master --force 
set /p id="it is Done Press any key to close.."
