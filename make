#! /bin/bash

valac *.vala Armes/*.vala Objets/*.vala Objets/IA/*.vala -o bin --pkg gee-1.0  --pkg gstreamer-0.10 --pkg gtk+-3.0
