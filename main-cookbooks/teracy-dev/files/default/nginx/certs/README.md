#Nginx Certs

This is self signed certificate for development purpose.

## How to create

```bash
$ openssl genrsa -des3 -passout pass:x -out default.pass.key 2048
$ openssl rsa -passin pass:x -in default.pass.key -out default.key
$ openssl req -new -key default.key -out default.csr
$ openssl x509 -req -sha256 -days 365 -in default.csr -signkey default.key -out default.crt
```

The default certificate is used along with https://github.com/jwilder/nginx-proxy to provide
reverse proxy system for Docker applications.

## References

- https://devcenter.heroku.com/articles/ssl-certificate-self
- https://github.com/jwilder/nginx-proxy
