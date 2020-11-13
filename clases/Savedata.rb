require_relative 'preloader.rb'

class SavedataManager
  def self.crear_multiples_zip saving_dir, dirs
    archivos = []
    dirs.each do |dir|
      puts "Creando #{dir["nombre"]}.zip"
      file = File.open("#{saving_dir}/#{dir["nombre"]}.zip", "wb")
      Zipping.files_to_zip file, dir["dirs"]
      puts "#{dir["nombre"]}.zip creado correctamente"
      archivos << {name: dir["nombre"]+".zip", dir:"#{saving_dir}/#{dir["nombre"]}.zip"}
    end
    return archivos
  end

  def self.make_zip saving_dir, dirdata
    dirdata.each do |dir|
      puts "Creando #{dir[:name]}.zip"
      file = File.open("#{saving_dir}/#{dir[:name]}.zip", "wb")
      Zipping.files_to_zip file, [dir[:paths]]
      puts "#{dir[:name]}.zip creado correctamente"
    end
  end
end