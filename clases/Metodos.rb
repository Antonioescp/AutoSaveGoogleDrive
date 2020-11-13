# Todos los metodos usados

# Sustituye "\" por "/"
def clean string
  string.gsub("#{92.chr}", '/' )
end

# Regresa el tiempo actual en este formato dia/mes/año 12horas:min:seg am/pm en tipo string
def tiempo_actual
  ca = Time.now
  ca_time = "am" if ca.hour < 12
  ca_time = "pm" if ca.hour >= 12
  if ca.hour > 12
    hour = ca.hour - 12
  elsif ca.hour == 0
    hour = ca.hour + 12
  else
    hour = ca.hour
  end
  current_time = "#{ca.day}/#{ca.month}/#{ca.year} #{hour}:#{ca.min}:#{ca.sec} #{ca_time}"
  return current_time
end

# Guarda la informacion de las carpetas a crear, nombre y directorio
def guardar_info_de_carpetas cantidad
	carpetas = []

	cantidad.times do

	  nuevo_folder = Hash.new
	  nuevo_folder[:dirs] = []

	  puts "Escriba el nombre del folder(el archivo comprimido tendra este nombre)"
	  nuevo_folder[:nombre] = gets.chomp
	  puts "Cuantos directorios desea guardar para #{nuevo_folder[:nombre]}?"
	  cantidad_de_directorios = gets.chomp.to_i

	  cantidad_de_directorios.times do
	  	puts "Copia y pega el directorio del folder a comprimir"
	  	string = gets.chomp
	  	nuevo_folder[:dirs] << clean(string)
	  end

	  carpetas << nuevo_folder
	end

	return carpetas
end

# Abrir archivo Json
def abrir_json nombre
  file = File.read nombre
  JSON.parse(file)
end

# Guarda un archivo JSON
def guardar_json my_hash, nombre
  file = File.new nombre, "w"
  file.write my_hash.to_json
  file.close
end

# abre un archivo de texto
def leer_txt nombre
  # agrega txt al final
  nombre += ".txt" unless nombre.include? ".txt"
  # lo abre
  file = File.open(nombre)
  # guarda el contenido
  content = file.read
  # cierra el archivo
  file.close
  # retorna el contenido
  return content
end

# abre un archivo de texto y lo divide segun criterio, retorna un arreglo
def leer_txt_split nombre, criterio
  content = leer_txt nombre
  return content.split(criterio)
end

# guarda un archivo txt
def guardar_txt_split nombre, datos
  # agrega txt al final
  nombre += ".txt" unless nombre.include? ".txt"
  # crea o lee el contenido
  file = File.open(nombre, "a+")
  # guarda el contenido
  # escribe cada elemento junto con un salto de linea
  datos.each do |data|
    file.write(data+"\n")
  end
  file.close
end

# Crea credenciales para que el usuario pueda usar
def crear_credenciales
  cliente = { installed: { client_id: nil, 
  						   project_id: nil, 
  						   auth_uri: "https://accounts.google.com/o/oauth2/auth", 
  						   token_uri: "https://oauth2.googleapis.com/token", 
  						   auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs", 
  						   client_secret: nil,
  						   
  						   redirect_uris: [ "urn:ietf:wg:oauth:2.0:oob", 
  						   					 "http://localhost" ]
  						  }
  			}

  puts "Copia y pega tu Client ID"
  cliente[:installed][:client_id] = gets.chomp
  puts "Copia y pega Client Secret"
  cliente[:installed][:client_secret] = gets.chomp
  puts "Copia y pega tu Project ID"
  cliente[:installed][:project_id] = gets.chomp

  guardar_json cliente, "client.json"

  puts "Credenciales creados (client.json)"
end

