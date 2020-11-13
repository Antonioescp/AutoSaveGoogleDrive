require_relative "clases/postloader.rb"

# Carga los credenciales guardados
puts "Desea conservar los credenciales que ya existen?(y/n)"
opcion = gets.chomp

if opcion == "y"
  if File.exist? "client.json"
    puts "Archivo encontrado de credenciales, cargando..."
    cliente = abrir_json "client.json"
  else
    puts "El archivo no existe"
    puts "Creando credenciales..."
    cliente = crear_credenciales
  end
else
  puts "Creando credenciales..."
  cliente = crear_credenciales
end
opcion = ''

# Archivo de configuracion
config_file = Hash.new(nil)
if File.exist? "config.json"
  puts "Cargando archivo de configuracion..."
  config_file = abrir_json "config.json"
  puts "Desea cambiar el directorio de respaldo?(y/n)"
  opcion = gets.chomp
  if opcion == 'y'
    puts "Ingresa el nuevo directorio"
    config_file["bu_dir"] = clean(gets.chomp)
    guardar_json config_file, "config.json"
    puts "nuevo directorio guardado!"
  end
else
  puts "Creando archivo de configuracion..."
  puts "Ingresa tu directorio de respaldo, donde quieres que los zips sean creados"
  config_file["bu_dir"] = clean(gets.chomp)
  puts "Guardando archivo..."
  guardar_json config_file, "config.json"
end
opcion = ''

# Conecta a google drive
puts "Creando conexion..."
cloud = GoogleDrive.new
puts "Conexion establecida"

# guarda los directorios
if config_file["directorios"]
  if config_file["directorios"].empty?
    puts "No hay directorios en el archivo de configuracion"
  else
    puts "Desea usar los directorios en el archivo de configuracion?(y/n)"
    opcion = gets.chomp
  end
end

if opcion.empty?
  puts "Cuantos directorios va a guardar?"
  cantidad = gets.to_i
  config_file["directorios"] = guardar_info_de_carpetas cantidad
  puts "Sobreescribir directorios?(y/n)"
  opcion = gets.chomp
  if opcion == "y"
    guardar_json config_file, "config.json"
    config_file = abrir_json "config.json"
  end
end

puts "Configurado con exito"