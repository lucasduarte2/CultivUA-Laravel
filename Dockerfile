# Use a imagem oficial do Laravel com PHP
FROM php:8.2-fpm

# Instalar extensões necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git curl && \
    docker-php-ext-install zip pdo pdo_mysql

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /var/www/html

# Copiar todos os arquivos do projeto
COPY . .

# Instalar dependências PHP do Laravel
RUN composer install --no-dev --optimize-autoloader

# Permissões para storage e bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Definir a porta de exposição
EXPOSE 8000

# Comando de entrada padrão
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
