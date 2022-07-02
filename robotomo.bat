:loop
robocopy "x:\cryoemdata\appion\21dec06a\serialem_frames" "d:\21dec06a_tomo\frames" *.tif 
robocopy "x:\cryoemdata\appion\21dec06a" "d:\21dec06a_tomo" *mdoc   
timeout /t 60
goto loop
