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
			-X -DSPRITES=\"`pwd`\" \
			-X -DMENUIMG=\"`pwd`\" \
			-X -DDATA=\"`pwd`/Data\"

# Variables définies à la compilation pour l'installation
CONFIG_INSTALL = 	-X -DMUSIQUE=\"/usr/share/WormsVala/Musique\" \
					-X -DFOND=\"/usr/share/WormsVala/Images/Fonds\" \
					-X -DSPRITES=\"/usr/share/WormsVala/Images/Sprites\" \
					-X -DMENUIMG=\"/usr/share/WormsVala/Images/Menu\" \
					-X -DDATA=\"/usr/share/WormsVala/Data\"
					

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
.PHONY : clean
clean:
	@rm -v -fr src/*~ src/*.c \
		src/Objets/*.c src/Objets/*~ \
		src/Objets/IA/*.c src/Objets/IA/*~ \
		src/Armes/*.c Armes/*~
		
# Installe le jeu sur le système !
.PHONY : install
install : clean
	@rm -v -fr $(PROGRAM)
	# Compile avec les bons flags
	@$(VALAC) --disable-assert -X -O2 $(SRC) -o WormsVala -X -I\"`pwd`/config.h\" --vapidir vapi/ $(PKGS) $(LINK) $(CONFIG_INSTALL)
	
	# Crée le répertoire qui contient les Datas
	@mkdir -p "/usr/share/WormsVala"
	
	# Copie les fichiers 
	@cp -R ./Images/ "/usr/share/WormsVala/Images"
	@cp -R ./Musique/ "/usr/share/WormsVala/Musique"
	@cp -R ./Data/ "/usr/share/WormsVala/Data"
	
	# Copie le programme
	@mv WormsVala "/usr/bin/WormsVala"
	
# Désinstalle le jeu 
.PHONY : uninstall
uninstall: clean
	@rm -v -fr -r "/usr/share/WormsVala"
	@rm -v -fr "/usr/bin/WormsVala"
	@echo "Désinstallé avec succès"
