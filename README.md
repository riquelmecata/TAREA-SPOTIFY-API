# TAREA SPOTIFY API

Esta aplicación en Ruby consume la API de Spotify usando el flujo de Client Credentials. La app realiza las siguientes operaciones:

- Obtiene un token de acceso utilizando tus credenciales almacenadas en `credentials.json`.
- Consulta la información básica de una lista de artistas.
- Para cada artista, obtiene sus top tracks en el mercado de Chile y selecciona la canción más popular. En caso de empate en popularidad, se elige la canción que precede en orden alfabético.
- Muestra un resumen en consola con el nombre del artista, su popularidad, el nombre de la canción más popular en Chile y la `preview_url`.

## Requisitos

- Ruby (versión 2.5 o superior)
- Gema `rest-client`

## Instalación

1. Asegúrate de tener instalado Ruby en tu sistema:
   ```bash
   ruby -v
   ```
2. Navega al directorio de la app

3. Instala las dependencias utilizando Bundler:
   ```bash
   gem install ffi     
   gem install rest-client
   ```
4. Crea un archivo `credentials.json` en el directorio raíz con el siguiente contenido (reemplaza los valores de ejemplo por tus credenciales):
   ```json
   {
     "client_id": "TU_CLIENT_ID",
     "client_secret": "TU_CLIENT_SECRET"
   }
   ```

## Ejecución

Para iniciar la aplicación, ejecuta:
   ```bash
   ruby api_client.rb
   ```
La aplicación mostrará en pantalla el resumen de cada artista obtenido desde la API de Spotify.

## Estructura del Proyecto

El proyecto tiene la siguiente estructura:

```
TAREA SPOTIFY API/
├── api_client.rb       # Código principal de la aplicación
├── credentials.json    # Archivo con las credenciales de la API de Spotify
├── README.md           # Documentación del proyecto
```

## Notas

- Asegúrate de que las credenciales proporcionadas en `credentials.json` sean válidas y tengan los permisos necesarios para acceder a la API de Spotify.
- Si encuentras algún problema, verifica que las dependencias estén correctamente instaladas y que el token de acceso se genere correctamente.