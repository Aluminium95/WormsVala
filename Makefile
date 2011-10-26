## Makefile du projet !

# Nom du programme et nom du dossier dans usr/share
PROGRAM = worms-vala

# Sources du programme + vapi
SRC =	"src"/*.vala \
		"src/Objets"/*.vala \
			"src/Objets/IA"/*.vala \
			"src/Armes"/*.vala \
		"src/Menu"/*.vala \
		"src/Scripts"/*.vala \
		"vapi"/*.vapi


# Paquets utilisés
PKGS = 	--pkg gee-1.0 \
		--pkg sdl \
		--pkg sdl-gfx \
		--pkg sdl-mixer \
		--pkg sdl-image \
		--pkg gio-2.0 \
		--pkg lua

# Variables définies à la compilation
CONFIG =	-X -DMUSIQUE=\"`pwd`/Musique\" \
			-X -DFOND=\"`pwd`/Images/Fonds\" \
			-X -DSPRITES=\"`pwd`/Images/Sprites\" \
			-X -DMENUIMG=\"`pwd`/Images/Menu\" \
			-X -DDATA=\"`pwd`/Data\" \

IMPORT_CONFIG = -X -I\"`pwd`/config.h\"

# Link des librairies SDL
LINK = 	-X -lSDL -X -lSDL_gfx -X -lSDL_mixer -X -lSDL_image

# Commande pour compiler
VALAC = valac --enable-experimental --thread

# Option de debug
VALACOPTS = -D DEBUG -g --save-temps --enable-mem-profiler 
 
# Makefile principal pour Valencia
BUILD_ROOT = 1

# Le projet par défaut : debug
all:
	@$(VALAC) $(VALACOPTS) $(SRC) -o $(PROGRAM) $(IMPORT_CONFIG) $(PKGS) $(LINK) $(CONFIG)
	
 
# Le projet Release : non debug, optimisé 
release: clean
	@rm -v -fr $(PROGRAM)
	@$(VALAC) --disable-assert -X -O2 $(SRC) -o $(PROGRAM)-release $(IMPORT_CONFIG) $(PKGS) $(LINK) $(CONFIG)
 
# Supprime tous les fichiers « inutiles »
.PHONY : clean
clean:
	@rm -v -fr src/*~ src/*.c \
		src/Objets/*.c src/Objets/*~ \
		src/Objets/IA/*.c src/Objets/IA/*~ \
		src/Menu/*.c src/Menu/*~ \
		src/Armes/*.c src/Armes/*~ \ \
		src/Scripts/*.c src/Scripts/*~ \
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
	
	# Modification des permissions des fichiers 
	@chmod -R u+rw "/usr/share/$(PROGRAM)"
	
	# Installation du .desktop
	@cp ./DesktopIntegration/WormsVala.desktop "/usr/share/applications/$(PROGRAM).desktop"
	@chmod u+x "/usr/share/applications/$(PROGRAM).desktop"
	
	# Installation des icones
	@cp ./DesktopIntegration/48.png "/usr/share/icons/hicolor/48x48/apps/$(PROGRAM).png"
	@cp ./DesktopIntegration/64.png "/usr/share/icons/hicolor/64x64/apps/$(PROGRAM).png"
	@cp ./DesktopIntegration/128.png "/usr/share/icons/hicolor/128x128/apps/$(PROGRAM).png"
	@cp ./DesktopIntegration/Icon.svg "/usr/share/icons/hicolor/scalable/apps/$(PROGRAM).svg"
	
	# Installation de la man page
	@cp ./DesktopIntegration/$(PROGRAM).6.gz "/usr/share/man/man6/$(PROGRAM).6.gz"
	
	# Déplacement du programme dans /usr/bin
	@mv $(PROGRAM) "/usr/bin/$(PROGRAM)"
	
# Désinstalle le jeu 
.PHONY : uninstall
uninstall: clean
	# Supression des données du programme
	@rm -v -fr -r "/usr/share/$(PROGRAM)"
	
	# Supression du programme lui même
	@rm -v -fr "/usr/bin/$(PROGRAM)"
	
	# Supression de l'intégration au desktop
	@rm -v -fr "/usr/share/applications/$(PROGRAM).desktop"
	@rm -v -fr "/usr/share/icons/hicolor/48x48/apps/$(PROGRAM).png"
	@rm -v -fr "/usr/share/icons/hicolor/64x64/apps/$(PROGRAM).png"
	@rm -v -fr "/usr/share/icons/hicolor/128x128/apps/$(PROGRAM).png"
	@rm -v -fr "/usr/share/icons/hicolor/scalable/apps/$(PROGRAM).svg"
	@rm -v -fr "/usr/share/man/man6/$(PROGRAM).6.gz"
	
	@echo "Désinstallé avec succès"
