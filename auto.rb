require_relative "clases/postloader.rb"

current_time = tiempo_actual

# Carga los credenciales guardados
puts "Archivo encontrado de credenciales, cargando..."
cliente = abrir_json "client.json"

# Archivo de configuracion
# config_file = Hash.new(nil)
puts "Cargando archivo de configuracion..."
# config_file = abrir_json "config.json"

# archivo de configuracion
config_file = {}
# directorios
config_file["directorios"] = []

# abre los directorios dentro del archivo
file = File.read 'dirs.txt'


file.split("\n").each do |line|
  # bu_dir es el directorio donde
  # se guardaran los archivos
  # despues de ser comprimidos
  # busca el directorio para guardarlos.
  if line.include? "bu_dir"
    config_file["bu_dir"] = line.gsub("bu_dir ", '')
  end
  # revisa si es un nombre para archivo rar o un 
  # directorio para comprimir, los nombres que 
  # deseas poner a tus rar empiezan con '.'
  # esto para que pueda identificarlos
  if line[0] == '.' && !(line.include? "bu_dir")
    # directorios que pertenecen a ese nombre
    dir = {}
    # guarda el nuevo hash en directorios
    config_file["directorios"] << dir
    # guarda el nombre del archivo comprimido borrando el punto
    config_file["directorios"][-1]["nombre"] = line.delete('.')
    # crea un espacio para guardar directorios que pertenecen a
    # el archivo comprimido actual
    config_file["directorios"][-1]["dirs"] = []
  else
    # guarda los directorios a comprimir
    unless config_file["directorios"].empty?
      config_file["directorios"][-1]["dirs"] << clean(line)
    end
  end
end

# Conecta a google drive
puts "Creando conexion..."
cloud = GoogleDrive.new
puts "Conexion establecida"

# Comprimiendo savedata
puts "Comprimiendo datos en #{config_file["bu_dir"]}..."
# comprime los dirs dentro de config_file en bu_dir
backup_zips_dir = SavedataManager.crear_multiples_zip config_file["bu_dir"], config_file["directorios"]
puts "Los datos han sido comprimidos!"


# Carpeta en la nube
savedata_folder = Hash.new(nil)
# aqui va el nombre de la carpeta
# ponganle un nombre unico en toda la unidad en la nube para evitar
# errores
savedata_folder[:name] = "savedata"

# Verifica si existe un folder en la nube con el nombre elegido
unless cloud.exist? savedata_folder[:name]
  # si no, lo crea
  puts "La carpeta #{savedata_folder[:name]} no existe en la nube, creando folder..."
  cloud.create_folder savedata_folder[:name]
  puts "La carpeta #{savedata_folder[:name]} ha sido creada con exito"
  puts "Guardando ID de la carpeta #{savedata_folder[:name]}..."
  results = cloud.get_all
  # revisa todos los archivos y carpetas
  results.files.each do |file|
    # al coincidir con el nombre guarda el id
    savedata_folder[:id] = file.id if file.name == savedata_folder[:name]
  end
  puts "ID guardado!"
else
  # si ya existe solo busca
  puts "La carpeta #{savedata_folder[:name]} ya existe en la nube"
  puts "Guardando ID de la carpeta #{savedata_folder[:name]}..."
  results = cloud.get_all
  results.files.each do |file|
    # y guarda el id
    savedata_folder[:id] = file.id if file.name == savedata_folder[:name]
  end
  puts "ID guardado!"

end


# Crea carpeta con fecha dentro de la carpeta de respaldo
puts "Creando carpeta cronologica..."
date_folder = Hash.new(nil)
# para mantener un registro de cuando se hizo el respaldo
date_folder[:name] = current_time
cloud.create_folder date_folder[:name], savedata_folder[:id]
puts "Carpeta cronologica creada!(#{date_folder[:name]})"

# Guarda el ID de la carpeta con fecha
puts "Guardando ID..."
date_folder[:id] = cloud.get_id_with_parent date_folder[:name], savedata_folder[:id]
puts "ID guardado!(#{date_folder[:id]})"

# Sube los archivos a la nube
backup_zips_dir.each do |zip|
  # a la carpeta con fecha
  puts "Subiendo #{zip[:name]} a #{savedata_folder[:name]} dentro de #{date_folder[:name]} en la nube"
  # subiendo, pasa el nombre, el directorio y el id de la carpeta
  cloud.upload_file zip[:name], zip[:dir], date_folder[:id]
  puts "#{zip[:name]} subido!"
end

puts "Todos los archivos han sido subidos!"
