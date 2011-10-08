#! /bin/bash

src="src src/Objets src/Objets/IA src/Armes"
		
packages="gee-1.0 sdl sdl-gfx sdl-mixer" # Paquets à utiliser
ccargs="lSDL_gfx lSDL_mixer" # Arguments passés au compilo C


### --- COMPUTING --- ###
listedirs=''
for dir in $src
do
	listedirs="${listedirs}$dir/*.vala "
done

listeccargs=''
for arg in $ccargs
do 
	listeccargs="${listeccargs}-X -$arg "
done

listepaquets=''
for pkg in $packages
do
	listepaquets="${listepaquets}--pkg ${pkg} "
done

### --- EXECUTING --- ###
CMD="valac $listedirs -o bin $listepaquets $listeccargs"
$CMD
