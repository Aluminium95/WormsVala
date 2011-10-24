## Makefile du projet !

# Nom du programme et nom du dossier dans usr/share
PROGRAM = WormsVala

# Sources du programme + vapi
SRC =	"src"/*.vala \
		"src/Objets"/*.vala \
			"src/Objets/IA"/*.vala \
			"src/Armes"/*.vala \
	"vapi"/*.vapi


# Paquets utilisés
PKGS = 	--pkg gee-1.0 \
	--pkg sdl \
	--pkg sdl-gfx \
	--pkg sdl-mixer \
	--pkg sdl-image

# Variables définies à la compilation
CONFIG =	-X -DMUSIQUE=\"`pwd`/Musique\" \
			-X -DFOND=\"`pwd`/Images/Fonds\" \
			-X -DSPRITES=\"`pwd`/Images/Sprites\" \
			-X -DMENUIMG=\"`pwd`/Images/Menu\" \
			-X -DDATA=\"`pwd`/Data\"

IMPORT_CONFIG = -X -I\"`pwd`/config.h\"

# Link des librairies SDL
LINK = 	-X -lSDL -X -lSDL_gfx -X -lSDL_mixer -X -lSDL_image

# Commande pour compiler
VALAC = valac --enable-experimental --thread
 
# Option de debug
VALACOPTS = -D DEBUG -g --save-temps --enable-mem-profiler 
 
# set this as root makefile for Valencia
BUILD_ROOT = 1
 
# Le projet par défaut : debug
all:
	@$(VALAC) $(VALACOPTS) $(SRC) -o $(PROGRAM) $(IMPORT_CONFIG) $(PKGS) $(LINK) $(CONFIG)
	
 
# Le projet Release : non debug, optimisé 
release: clean
	@rm -v -fr $(PROGRAM)
	@$(VALAC) --disable-assert -X -O2 $(SRC) -o WormsValaRelease $(IMPORT_CONFIG) $(PKGS) $(LINK) $(CONFIG)
 
# Supprime tous les fichiers « inutiles »
.PHONY : clean
clean:
	@rm -v -fr src/*~ src/*.c \
		src/Objets/*.c src/Objets/*~ \
		src/Objets/IA/*.c src/Objets/IA/*~ \
		src/Armes/*.c Armes/*~ \
		*~
		
# Installe le jeu sur le système !
.PHONY : install
install : clean
	@rm -v -fr $(PROGRAM)
	# Compilation du programme
	@$(VALAC) --disable-assert -X -O2 $(SRC) -o $(PROGRAM) $(IMPORT_CONFIG) $(PKGS) $(LINK)
	
	# Création du répertoire du programme
	@mkdir -p "/usr/share/$(PROGRAM)"
	
	# Copie des données du programme
	@cp -R ./Images/ "/usr/share/$(PROGRAM)/Images"
	@cp -R ./Musique/ "/usr/share/$(PROGRAM)/Musique"
	@cp -R ./Data/ "/usr/share/$(PROGRAM)/Data"

	@chmod -R u+rw "/usr/share/$(PROGRAM)"
	
	# Déplacement du programme dans /usr/bin
	@mv WormsVala "/usr/bin/$(PROGRAM)"
	
# Désinstalle le jeu 
.PHONY : uninstall
uninstall: clean
	@rm -v -fr -r "/usr/share/$(PROGRAM)"
	@rm -v -fr "/usr/bin/$(PROGRAM)"
	@echo "Désinstallé avec succès"
