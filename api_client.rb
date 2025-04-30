require 'rest-client'
require 'json'
require 'base64'

credentials = JSON.parse(File.read('credentials.json'))
client_id = credentials['client_id']
client_secret = credentials['client_secret']

# Codificar las credenciales en base64 para la autorización
encoded_credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

response = RestClient.post(
  'https://accounts.spotify.com/api/token',
  { grant_type: 'client_credentials' },
  { Authorization: "Basic #{encoded_credentials}" }
)

token_data = JSON.parse(response.body)
access_token = token_data['access_token']

puts "Token de acceso obtenido: #{access_token}"

# Lista de IDs de artistas
artist_ids = [
  '4gzpq5DPGxSnKTe4SA8HAU',
  '06HL4z0CvFAxyc27GXpf02',
  '53XhwfbYqKCa1cC15pYq2q',
  '4q3ewBCX7sLwd24euuV69X',
  '2ye2Wgw4gimLv2eAKyk1NB',
  '0C0XlULifJtAgn6ZNCW2eu',
  '6vWDO969PvNqNYHIOW5v0m',
  '6eUKZXaKkcviH0Ku9w2n3V',
  '0EmeFodog0BfCgMzAIvKQp',
  '1vCWHaC5f2uS3yhpwWbIA6'
]

# Obtener información básica de todos los artistas
ids_string = artist_ids.join(',')
artists_response = RestClient.get(
  "https://api.spotify.com/v1/artists?ids=#{ids_string}",
  { Authorization: "Bearer #{access_token}" }
)
artists_data = JSON.parse(artists_response.body)['artists']

resultados = []

artists_data.each do |artist|
  artist_name = artist['name']
  artist_popularity = artist['popularity']
  
  # Obtener los top tracks en Chile para cada artista
  top_tracks_response = RestClient.get(
    "https://api.spotify.com/v1/artists/#{artist['id']}/top-tracks?market=CL",
    { Authorization: "Bearer #{access_token}" }
  )
  top_tracks = JSON.parse(top_tracks_response.body)['tracks']

  # Seleccionar la canción más popular
  best_track = nil
  top_tracks.each do |track|
    # Si no tiene preview_url se usará cadena vacía en el resultado, pero aun se considera para la comparación
    track_preview = track['preview_url'] || ""
    if best_track.nil?
      best_track = track
    else
      if track['popularity'] > best_track['popularity']
        best_track = track
      elsif track['popularity'] == best_track['popularity']
        # En caso de empate, elegir por orden alfabético
        best_track = track if track['name'].downcase < best_track['name'].downcase
      end
    end
  end
  
  # Si no se encuentra ningún track, se dejan los campos en vacío
  best_track_name = best_track ? best_track['name'] : ""
  best_preview_url = best_track ? (best_track['preview_url'] || "") : ""

  resultados << {
    name: artist_name,
    artist_popularity: artist_popularity,
    track_name: best_track_name,
    preview_url: best_preview_url
  }
end

# Ordenar los artistas alfabéticamente por su nombre
resultados.sort_by! { |r| r[:name].downcase }

# Mostrar el resumen en pantalla para cada artista
resultados.each do |res|
  puts "Artista: #{res[:name]}"
  puts "Popularidad del artista: #{res[:artist_popularity]}"
  puts "Canción más popular en Chile: #{res[:track_name]}"
  puts "Preview URL: #{res[:preview_url]}"
  puts "------------------------------"
end