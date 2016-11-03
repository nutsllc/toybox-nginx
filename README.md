# Nginx on Docker

A Dockerfile for deploying a [Nginx](https://nginx.org/) using Docker container.

This image has been extended [the official nginx image](https://hub.docker.com/_/nginx/) which is maintained in the [docker-library/nginx](https://github.com/docker-library/nginx) GitHub repository.

This image is registered to the [Docker Hub](https://hub.docker.com/r/nutsllc/toybox-nginx/) which is the official docker image registory.

## Main Feautuers

With this Docker image...

* By setting the GID and UID of the main process user in the container, it is possible to avoid the permission trouble.
* You can change the document root directory by environment variable.
* An easy to work with PHP-FPM. All you need to do is just to set environment variable.


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

### Persistent the Nginx config files
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

## Changing the Document root directory

You would like to change document root directory, apply ``DOCUMENT_ROOT`` environment variable: ``-e DOCUMENT_ROOT=/var/www/html``.

A default document root directory is ``/usr/share/nginx/html``. 

## Using with PHP-FPM

You would like to run the nginx instance with PHP-FPM, apply an environment variable ``PHP_FPM_HOST`` and add ``volumes_from`` to bind data container.

Data container shuld join a ``/usr/share/nginx/html`` directory to Nginx container and PHP-FPM container.

Example:

```bash
version: '2'
services:
	toybox-nginx:
   		image: nutsllc/toybox-nginx:latest
    	environment:
	        - PHP_FPM_HOST=php-fpm:9000
		volumes_from:
			- data
		ports:
			- 8080:80

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