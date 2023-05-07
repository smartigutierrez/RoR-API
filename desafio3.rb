#API KEY VVOSFu2m0CaOXQ3czMH8PjiRDocLHab2Vus7OxxM
#Puede que la API KEY expire antes de la revisión
require "uri"
require "net/http"
require "json"

def request(url_requested)
  url = URI(url_requested)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true 
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'
  response = http.request(request)
  return JSON.parse(response.body)
end

#Método para hacer la página web
def build_web_page(data)
  html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
  data['photos'].each do |photo|
    html += "<li><img src='#{photo['img_src']}'></li>\n"
  end
  html += "</ul>\n</body>\n</html>"
  return html
end

#Método para contar
def photos_count(data)
  counts = Hash.new(0)
  data['photos'].each do |photo|
    counts[photo['camera']['name']] += 1
  end
  return counts
end


#Pedir la información a la API & crear el array
data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=15&api_key=VVOSFu2m0CaOXQ3czMH8PjiRDocLHab2Vus7OxxM')
photos = data['photos'].map { |photo| photo['img_src'] }

#Construir la página web
html = build_web_page(data)

#Imprimir la página en la terminal
puts html

#Contar las fotos e imprimir en la terminal
counts = photos_count(data)
puts counts

#Crear el archivo html con los resultados del método build_web_page
File.write('fotosnasa.html', html)







