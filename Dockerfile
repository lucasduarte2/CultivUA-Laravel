# Usar a imagem oficial do PHP com o Composer
FROM php:8.1-fpm

# Instalar as dependências necessárias
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git unzip libicu-dev && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd intl pdo pdo_mysql

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar o diretório de trabalho
WORKDIR /var/www

# Copiar os arquivos do projeto
COPY . .

# Instalar as dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Expor a porta 9000 (usada pelo PHP-FPM)
EXPOSE 9000

# Executar o servidor PHP
CMD ["php-fpm"]
