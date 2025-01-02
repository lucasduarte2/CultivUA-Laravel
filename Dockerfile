FROM php:8.1-apache

# Instalar dependências do PHP necessárias para o Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Defina o diretório de trabalho para o diretório onde o Laravel está
WORKDIR /var/www/html

# Copiar os arquivos do projeto para o contêiner
COPY . .

# Instalar as dependências do Laravel com o Composer
RUN composer install --no-dev --optimize-autoloader

# Definir as permissões corretas para o diretório storage
RUN chown -R www-data:www-data /var/www/html/storage

# Expor a porta 80
EXPOSE 80

# Iniciar o Apache no contêiner
CMD ["apache2-foreground"]
