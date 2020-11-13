require_relative 'preloader.rb'

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
CREDENTIALS_PATH = "client.json".freeze
APP_NAME = "default".freeze
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::DriveV3::AUTH_DRIVE
DATA_FOLDER_TYPE = "application/vnd.google-apps.folder"

# Clases
# Manejo de la nube
class GoogleDrive
  # Autorizacion
  def authorize 
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code.chomp, base_url: OOB_URI
      )
    end
    credentials
  end

  # Inicializacion de Google Drive
  def initialize
    @drive_service = Google::Apis::DriveV3::DriveService.new
    @drive_service.client_options.application_name = APP_NAME
    @drive_service.authorization = authorize

    @Drive = Google::Apis::DriveV3
  end

  # obtiene todos los archivos de la nube (con id, nombre y archivo padre por defecto)
  def get_all *params
    params = ["id", "name", "parents"] if params.empty?
    string = ""
    params.each do |param|
      string.concat("#{param}, ")
    end

    string.chomp!(", ")

    string = "files(#{string})"

    @drive_service.list_files fields: string
  end

  # Obtiene el id del archivo
  def get_id name
    results = get_all
    id = nil
    results.files.each do |file|
      if file.name == name
        id = file.id
      end
    end
    return id
  end

  # Obtiene el id del archivo usando nombre y parent
  def get_id_with_parent name, parent
    results = get_all
    id = "No encontrado"
    results.files.each do |file|
      if file.name == name && file.parents == [parent]
        id = file.id
      end
    end
    return id
  end

  # crea una carpeta
  def create_folder nombre, *parents
    metadata = @Drive::File.new name: nombre, mime_type: DATA_FOLDER_TYPE, parents: parents
    @drive_service.create_file metadata
  end

  # sube un archivo
  def upload_file nombre, source, *parents
    extension = source.rpartition(".")[-1]
    metadata = @Drive::File.new name: nombre, mime_type: "application/#{extension}", parents: parents
    @drive_service.create_file metadata, upload_source: source
  end

  # revisa si el archivo existe
  def exist? name, *parents
    results = get_all
    exist = false
    unless parents.empty?
      results.files.each do |file|
        exist = true if file.name == name && parents == file.parents
      end
    else
      results.files.each do |file|
        exist = true if file.name == name
      end
    end
    return exist
  end

end