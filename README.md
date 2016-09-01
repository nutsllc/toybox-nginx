# toybox-nginx

## Usage Example(using Docker)
```bash
docker run -it -p 8888:80 -d nutsllc/toybox-nginx
```

## An assimilating GID and UID of host user into container
```bash
docker run -it -p 8080:80 -e TOYBOX_GID=1000 -e TOYBOX_UID=1000 -d nutsllc/toybox-nginx
```

## Persistent Volumes

### Document Root
```bash
docker run -it -p 8080:80 -v $(pwd):/usr/share/nginx/html -d nutsllc/toybox-nginx
```

### Config files
```bash
docker run -it -p 8080:80 -v $(pwd):/etc/nginx/conf.d -d nutsllc/toybox-nginx
```

