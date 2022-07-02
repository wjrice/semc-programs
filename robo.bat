:loop
robocopy "x:\cryoemdata\leginon\22mar25a\rawdata" "d:\22mar25a" *-DW.mrc
robocopy "d:\22mar25a\particles" "x:\cryoemdata\appion\22mar25a\warp\particles"
robocopy "d:\22mar25a" "x:\cryoemdata\appion\22mar25a\warp" good*.star
robocopy "d:\22mar25a" "x:\cryoemdata\appion\22mar25a\warp" all*.star
timeout /t 60
goto loop