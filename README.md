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

tambien necesitas crear una aplicacion en google drive

## Uso

Para correr un script de ruby necesitas abrir la consola en el directorio del script y usar el comando
	"ruby <nombre del script>"

- Abrir la consola en el directorio donde estan los scripts
- Ejecutar el script configurar.rb
	- Aqui te pedira poner el directorio donde se guardaran los archivos rar, los archivos comprimidos de cada directorio a respaldar, asegurate de que el directorio exista
	- Tambien configuraras la informacion del cliente de tu aplicacion de google drive para poder conectarte
- Se te creará un archivo dirs.txt en la raiz, aqui escribe los directorios que deseas respaldar y el nombre de los archivos zip
	- Usa un punto para los nombres de los archivos zip
	- Despues de los nombres puedes poner un directorio por linea