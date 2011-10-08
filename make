#! /bin/bash

valac *.vala Armes/*.vala Objets/*.vala Objets/IA/*.vala -o bin --pkg gee-1.0  --pkg sdl --pkg sdl-gfx --pkg sdl-mixer -X -lSDL_gfx -X -lSDL_mixer
