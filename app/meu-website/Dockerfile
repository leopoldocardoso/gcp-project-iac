# Use uma imagem oficial do NGINX como base
FROM nginx:alpine

# O autor do Dockerfile (opcional)
LABEL maintainer="seu-nome@exemplo.com"

# Copie os arquivos do seu site para o diretório de serviço do NGINX
# O "." significa que ele irá copiar tudo do diretório atual
# para o diretório de destino no contêiner.
COPY . /usr/share/nginx/html

# Exponha a porta 80 para o tráfego da web
EXPOSE 80

# O comando para iniciar o NGINX quando o contêiner for iniciado
CMD ["nginx", "-g", "daemon off;"]
