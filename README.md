# docker-certbot-ningx-triad

## Introduction

With this repository you can make your website available on the Internet without having to buy a certificate. The certificate is automatically provided by certbot. The certificate will be renewed automatically when the expiration date is reached.

## Architecture

The architecture is structured as shown in the picture below. The proxy service receives all incoming requests from the Internet (port 80, 443) and forwards them accordingly to the web services. As soon as the certbot service tries to renew the certificate, the necessary files (ACME-Challenge) are provided by the certbot web service and made accessible via port 80 on /.well-known/acme-challenge/. As soon as the certificate is renewed the web services (proxy, web) will be informed that the certificate has been renewed. They then reload the settings, including the certificate. Usual traffic is routed through port 443 to the web service, which is the service that hosts your website.

![Architecture](https://raw.githubusercontent.com/steffsas/docker-nginx-certbot/master/docs/docker-nginx-certbot-architecture.png)

## Installation without having a certificate

If you do not have any certificate from Let`s Encrypt, then you need to do the following steps:

1. Comment out the marked sections in

   - /conf/proxy/nginx.conf
   - /conf/web/nginx.conf

   If you do not do this, nginx will not start because of the missing certificates.

2. Comment in the section

   ```
   # GET CERTIFICATE FOR FIRST TIME
   ...
   ```

   in docker-compose.yml.
   Make sure you commented out

   ```
   ...
   # TEST RENEWAL
   ...
   # PERIODICALLY RENEWAL
   ...
   ```

3. Start the docker services with

   ```
   docker-compose up
   ```

   Certbot will now automatically try to provide a certificate. The certificate is provided under data/certbot/certs.

4. Edit docker-compose.yml so that the web service meets your requirements.

## Installation with having a certificate

1. You don't have to do anything. Just go on to the next chapter.

## Configure your web app

1. The docker container web-service is responsible for the deployment of your app. The service accesses the files in the /dist/ folder. If you only have static files (html), it is sufficient to place them here. Otherwise, you must configure the nginx service to match your requirements. Adjust the settings in the /conf/web/nginx.conf folder.

2. Start the services with

   ```
   docker-compose up
   ```

## Security

- Make sure that you never make the private key of the certificate publicly available!

- The SSL/TLS settings are defined to give you an A+ grade

* Only TLS v1.2 and TLS v1.3 are supported for security reasons

- Older browsers cannot establish an encrypted connection to your server because they do not support newer encryption methods. Supported cipher suites are:

  ```
  EECDH+AESGCM:EDH+AESGCM;
  ```

  For more information have a look at [SSL Labs](https://www.ssllabs.com/ssltest/).

* Make sure that your cipher suites are always up to date. More information can be found at [Cipherlist](https://syslink.pl/cipherlist/)

## Planned Changes

Currently, the docker services are informed about the reloading of certificates via files. For this purpose the proxy, the web service and the certbot share one volume. As soon as a file with the container name exists in the shared volume, the settings of the nginx are reloaded. The certbot is configured via the environment variable RELOAD_NGINX_FILES in the docker-compose.yml. Since the procedure works according to the principle of polling and consumes resources unnecessarily, an adaptation to sockets is planned.

## Test Renewal of Certificate

If you want to test your certificate renewal, then comment out the TEST RENEWAL section and restart your docker containers.
