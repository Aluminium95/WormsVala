x = screen_w -- Récupère la largeur de l'écran
y = screen_h -- Récupère la hauteur de l'écran

filetab = scandir("/home/aluminium95/code/Vala/WormsVala/Data/Levels/")

for n,v in ipairs(filetab) do
	if v:match(".*\.lua") then
		io.write (v, "\n")
	end
	end

bouton (x/3 - 100,40,"Quitter.png", "QUITTER") -- Ajoute le bouton quitter
bouton (x/3 * 2 -100, 40, "Commencer.png", "COMMENCER") -- Ajoute le bouton commencer
bouton (x/2 -100, 200, "Resume.png", "CONTINUER") -- Ajoute le bouton continuer
