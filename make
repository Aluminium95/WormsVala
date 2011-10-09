#! /bin/bash

src="src src/Objets src/Objets/IA src/Armes"
		
packages="gee-1.0 sdl sdl-gfx sdl-mixer config" # Paquets à utiliser
ccargs="lSDL_gfx lSDL_mixer" # Arguments passés au compilo C

# Définition des constantes du paquet 
vars[0]="MUSIQUE=\"`pwd`/Musique\""
vars[1]="FOND=\"`pwd`/Images/Fonds\""
vars[2]="LOCALE=\"`pwd`\""
vars[4]="DATA=\"`pwd`/Data\""

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

listevars=''
for v in $vars
do
	listevars="-X ${listevars}-D$v "
done

### --- EXECUTING --- ###
CMD="valac -D DEBUG -g --save-temps $listedirs -o WormsVala -X -I\"`pwd`/config.h\" --vapidir vapi/ $listepaquets $listeccargs $listevars "
$CMD
