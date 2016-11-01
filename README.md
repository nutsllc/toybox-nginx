# Nginx on Docker

A Dockerfile for deploying a [Nginx](https://nginx.org/) using Docker container.

This ``toybox-nginx`` image has been extended [the official nginx image](https://hub.docker.com/_/nginx/) which is maintained in the [docker-library/nginx](https://github.com/docker-library/nginx) GitHub repository.

This image is registered to the [Docker Hub](https://hub.docker.com/r/nutsllc/toybox-nginx/) which is the official docker image registory.

In addition, this image is compatible with [ToyBox](https://github.com/nutsllc/toybox) complytely to manage the applications on Docker.

## Usage

### The simplest way to run
``docker run -it -p 8080:80 -d nutsllc/toybox-nginx``

### To correspond the gid/uid between inside and outside container

* To find a specific user's UID and GID, at the shell prompt, enter: ``id <username>``

``docker run -it -p 8080:80 -e TOYBOX_GID=1000 -e TOYBOX_UID=1000 -d nutsllc/toybox-nginx``

### Persistent the Nginx document root contents
```bash
docker run -it -p 8080:80 -v $(pwd)/.data/docroot:/usr/share/nginx/html -d nutsllc/toybox-nginx
```

### Persistent the Apache2 config files
```bash
docker run -it -p 8080:80 -v $(pwd):/etc/nginx/conf.d -d nutsllc/toybox-nginx
```

## Docker Compose example

```bash
toybox-nginx:
	image: nutsllc/toybox-nginx:latest
	environment:
		- TOYBOX_UID=1000
		- TOYBOX_GID=1000
	volumes:
		- "./.data/docroot:/usr/share/nginx/html"
	ports:
		- "8080:80"
```

## Change Document root directory

You'd like to change document root directory, apply ``DOCUMENT_ROOT`` environment variable  which is not required like ``-e DOCUMENT_ROOT=/var/www/html``.

Default document root directory is ``/usr/share/nginx/html``. 

## Using with PHP-FPM

You'd like to run the nginx instance with PHP-FPM, apply an environment variable ``PHP_FPM_HOST``. 

Example:

```bash
toybox-nginx:
    image: nutsllc/toybox-nginx:latest
    links:
        - php-fpm
    ports:
        - 8080:80
    environment:
        - TOYBOX_UID=1000
        - TOYBOX_GID=1000
        - PHP_FPM_HOST=php-fpm:9000
    volumes_from:
        - data

php-fpm:
    image: php:5.6-fpm
    volumes_from:
        - data

data:
    image: busybox
    volumes:
        - ".data/docroot:/usr/share/nginx/html"
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/nutsllc/toybox-nginx/issues), or submit a [pull request](https://github.com/nutsllc/toybox-nginx/pulls) with your contribution.