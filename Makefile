## Makefile du projet !

PROGRAM = WormsVala
 
 
# for most cases the following two are the only you'll need to change
# add your source files here
SRC =	src/main.vala \
		src/application.vala \
		src/aff.vala \
		src/sound.vala \
		src/gerant.vala \
		src/physique.vala \
		src/terrain.vala \
		src/menu.vala \
		src/bouton.vala \
		src/utils.vala \
			src/Objets/objet.vala \
			src/Objets/personnage.vala \
			src/Objets/joueur.vala \
			src/Objets/projectile.vala \
				src/Objets/IA/ia.vala \
			src/Armes/arme.vala \
			src/Armes/armeCac.vala \
			src/Armes/armeDist.vala
			
 
# add your used packges here
PKGS = 	--pkg gee-1.0 \
		--pkg sdl \
		--pkg sdl-gfx \
		--pkg sdl-mixer \
		--pkg config

CONFIG =	-X -DMUSIQUE=\"`pwd`/Musique\" \
			-X -DFOND=\"`pwd`/Images/Fonds\" \
			-X -DLOCALE=\"`pwd`\" \
			-X -DDATA=\"`pwd`/Data\"
			
LINK = 	-X -lSDL -X -lSDL_gfx -X -lSDL_mixer

# vala compiler
VALAC = valac --enable-experimental --thread
 
# compiler options for a debug build
VALACOPTS = -D DEBUG -g --save-temps --enable-mem-profiler 
 
# set this as root makefile for Valencia
BUILD_ROOT = 1
 
# the 'all' target build a debug build
all:
	@$(VALAC) $(VALACOPTS)$(SRC) -o $(PROGRAM) -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG) 
	
 
# the 'release' target builds a release build
# you might want to disabled asserts also
release: clean
	@$(VALAC) -X -O2 $(SRC) -o WormsValaRelease -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG)

 
# clean all built files
clean:
	@rm -v -fr *~ *.c $(PROGRAM)
