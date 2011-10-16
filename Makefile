## Makefile du projet !

PROGRAM = WormsVala
 
 
# Sources du programme
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
			
 
# Paquets utilisés
PKGS = 	--pkg gee-1.0 \
		--pkg sdl \
		--pkg sdl-gfx \
		--pkg sdl-mixer \
		--pkg config

# Variables définies à la compilation
CONFIG =	-X -DMUSIQUE=\"`pwd`/Musique\" \
			-X -DFOND=\"`pwd`/Images/Fonds\" \
			-X -DLOCALE=\"`pwd`\" \
			-X -DDATA=\"`pwd`/Data\"

# Link des librairies SDL
LINK = 	-X -lSDL -X -lSDL_gfx -X -lSDL_mixer

# Commande pour compiler
VALAC = valac --enable-experimental --thread
 
# Option de debug
VALACOPTS = -D DEBUG -g --save-temps --enable-mem-profiler 
 
# set this as root makefile for Valencia
BUILD_ROOT = 1
 
# Le projet par défaut : debug
all:
	@$(VALAC) $(VALACOPTS)$(SRC) -o $(PROGRAM) -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG) 
	
 
# Le projet Release : non debug, optimisé 
release: clean
	@rm -v -fr $(PROGRAM)
	@$(VALAC) --disable-assert -X -O2 $(SRC) -o WormsValaRelease -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG)

 
# clean all built files
clean:
	@rm -v -fr src/*~ src/*.c \
		src/Objets/*.c src/Objets/*~ \
		src/Objets/IA/*.c src/Objets/IA/*~ \
		src/Armes/*.c Armes/*~
