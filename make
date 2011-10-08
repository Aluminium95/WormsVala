#! /bin/bash

src="src src/Objets src/Objets/IA src/Armes"
		
packages="gee-1.0 sdl sdl-gfx sdl-mixer config" # Paquets à utiliser
ccargs="lSDL_gfx lSDL_mixer" # Arguments passés au compilo C

vars[0]="MUSIQUE_DIR=`pwd`/Musique"
vars[1]="FOND_DIR=`pwd`/Images/Fonds"
vars[2]="LOCALE_DIR=`pwd`"
vars[3]="PACKAGE_NAME=MegaWorms"
vars[4]="DATA_DIR=`pwd`/Data"
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
	listevars="${listevars}-X -D$v "
done

### --- EXECUTING --- ###
CMD="valac $listedirs -o bin $listepaquets $listeccargs $listevars --vapidir vapi/"
$CMD
