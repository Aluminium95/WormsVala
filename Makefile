## Makefile du projet !

PROGRAM = WormsVala
 
 
# Sources du programme
SRC =	"src"/*.vala \
			"src/Objets"/*.vala \
				"src/Objets/IA"/*.vala \
			"src/Armes"/*.vala 

 
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
	@$(VALAC) $(VALACOPTS) $(SRC) -o $(PROGRAM) -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG) 
	
 
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
