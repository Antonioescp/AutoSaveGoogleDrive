require_relative "clases/postloader.rb"

# Carga los credenciales guardados

# comprueba si existe un archivo de configucarion
if File.exist? "client.json"
  # pregunta si usar existente o crear uno nuevo
  puts "Desea conservar los credenciales que ya existen?(y/n)"
  opcion = gets.chomp
end

if opcion == "y"
  # carga el archivo existente
  puts "Archivo encontrado de credenciales, cargando..."
  cliente = abrir_json "client.json"
else
  # creaa uno nuevo
  puts "Creando credenciales..."
  cliente = crear_credenciales
end
opcion = ''

# Archivo de configuracion
config_file = Hash.new(nil)

# arreglo para el contenido del archivo de configuracion
config_file["contenido"] = []

# si el archivo de configuracion existe
if File.exist? "dirs.txt"
  puts "Cargando archivo de configuracion..."
  # lo abre
  config_file["contenido"] = leer_txt_split "dirs", "\n"
  # verifica si ya hay un directorio para los archivos
  # comprimidos
  if config_file["contenido"][0].include? "bu_dir"
    puts "Ya existe un directorio de guardado(en el archivo dirs.txt)"
  else
    puts "No existe directorio de respaldo, por favor ingresa uno"
    puts "Lugar donde se guardaran los archivos comprimidos"
    print "> "
    # guarda el directorio donde se guardaran los archivos comprimidos
    config_file["contenido"] << "bu_dir "+clean(gets.chomp)
    # crea o actualiza el archivo de configuracion
    puts "Creando archivo de configuracion..."
    guardar_txt_split "dirs", config_file["contenido"]
    puts "nuevo directorio guardado!"
  end
else
  puts "Creando archivo de configuracion..."
  puts "Ingresa tu directorio de respaldo, donde quieres que los zips sean creados"
  print "> "
  config_file["contenido"][0] = "bu_dir "+clean(gets.chomp)
  puts "Guardando archivo..."
  guardar_txt_split "dirs", config_file["contenido"]
end
opcion = ''

# Conecta a google drive
puts "Creando conexion..."
cloud = GoogleDrive.new
puts "Conexion establecida"

puts "Configurado con exito"

puts "Ahora escribe los directorios en el archivo dirs.txt!"
puts "\t-Los nombres de archivos comprimidos se inician con un punto"
puts "\t-Los directorios van despues de los nombres de los archivos comprimidos"
puts "\t-Un directorio por linea"
puts "\t-Para un nuevo archivo comprimido solo necesitas poner un punto y su nombre"