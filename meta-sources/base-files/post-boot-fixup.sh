#!/bin/bash

echo "This script will only work if all required packages are installed! These currently are: shared-mime-info, glib-networking, glib, gsettings-desktop-schemas, gdk-pixbuf, dbus and gtk+3"

echo "Running update-mime-database to get the mime database"
update-mime-database /usr/share/mime/
echo "Running gio-querymodules to generate gio cache"
gio-querymodules /usr/lib/gio/modules/
echo "Running glib-compile-schemas to get gtk3 working"
glib-compile-schemas /usr/share/glib-2.0/schemas/
echo "Running gdk-pixbuf-query-loaders to get gtk3 working"
gdk-pixbuf-query-loaders --update-cache
echo "Running gtk-query-immodules-3.0 to get gtk3 working"
gtk-query-immodules-3.0 --update-cache
#echo "Running gtk-query-immodules-2.0 to get gtk2 working"
#gtk-query-immodules-2.0 --update-cache
echo "Creating dbus memes...."
mkdir -p /run/dbus
echo "Launching dbus..."
dbus-daemon --system

exit 0
