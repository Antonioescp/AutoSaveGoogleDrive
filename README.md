# GoogleDrive AutoSave
Estos scripts sirven para conectarse a una aplicacion de google drive que tengas, puedes respaldar archivos con un solo click rapidamente.

escrito en ruby 2.6.6p146

## Requisitos 
Ademas de necesitar ruby, necesitaras instalar algunas gemas:
- zipping, para comprimir los archivos antes de subir
- json, para tratar con archivos json
- googleauth, api de autenticación de google
- google-api-client, api para google drive
- fileutils

todo esto lo puedes instalar desde la consola usando el comando 
	"gem i <nombre de gema>"

## Antes de usar
Para ejecutar un script de ruby necesitas abrir la consola en el directorio del script y usar el comando
	"ruby <nombre del script>"
	
Necesitas crear una aplicacion de google drive, puedes usar este link
https://developers.google.com/drive/api/v3/quickstart/js?authuser=1

-Bajas un poco y clickeas "Enable the drive API", pones de nombre "Autoguardado", lees los terminos y continuas

-Una vez termine de cargar haces click en "download client configuration" y le cambias el nombre a client.json y lo pones en la carpeta raiz de los scripts

	-Esto le servira al script para conectarse a tu app
	
-Ahora ejecutas el script "configurar.rb", te pedira el directorio de respaldo y una llave de autenticacion, copia y pega el codigo proporsionado por google
-Listo, has configurado tu aplicacion
-Añadir nombre de zips y directorios a dirs.txt en la raiz
-Ejecutar el script auto.rb, los directorios dentro de dirs.txt seran compresos y subidos a la nube en una carpeta llamada savedata en orden cronologico

## Directorios
En el archivo dirs.txt escribes el nombre del archivo zip y despues los directorios que quieres comprimir en ese archivo, ejemplo:

### contenido de dirs
bu_dir C:/Users/Antonio Escorcia/Documents/savedata_bu

.Dolphin
C:\Users\Antonio Escorcia\Documents\Dolphin Emulator\GC
C:\Users\Antonio Escorcia\Documents\Dolphin Emulator\Wii

.Cemu
D:\CleanInstall\Games\emu\cemu_1.21.2\SaveData, Updates and DLCs\usr\save

.GBA
D:/CleanInstall/Games/emu/VisualBoyAdvance-1.8.0-beta3/savedata
### fin de dirs
