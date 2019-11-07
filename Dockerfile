FROM php:7.2-cli
COPY . /usr/src/geocoder
WORKDIR /usr/src/geocoder
CMD [ "php", "./test/geocoder.php" ]
