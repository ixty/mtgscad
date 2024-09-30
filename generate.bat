cd /D "%~dp0"
set openscad=D:\softs\openscad-2024.04\openscad.exe

set args=--colorscheme DeepOcean --imgsize 1024,1024 -D "texture_enable=true"
%openscad% -D "OBJ=\"outer\"" -o r_outer.png --camera 38,46,46,76,0,30,401 %args% v3.scad
%openscad% -D "OBJ=\"inner\"" -o r_inner.png --camera 50,50,30,56,0,217,401 %args% v3.scad
%openscad% -D "OBJ=\"all\"" -o r_all.png --camera 50,50,30,56,0,217,401 %args% v3.scad

%openscad% -D "OBJ=\"inner\"" -o out_inner.stl %args% v3.scad
%openscad% -D "OBJ=\"outer\"" -o out_outer.stl %args% v3.scad

rem pause
