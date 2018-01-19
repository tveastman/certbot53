# certbot53, Route53 Authenticated LE Certificates.

A Docker image that will use Amazon Route 53 authentication to generate
SSL certificates, and a utility to upload the certificates to Hashicorp Vault
where they can be retrieved by the components that need it.

## Usage

The first time you run it, you'll need to pass in the `--email` option. The
`run-container.sh` script also calls `docker build`, so it'll take a while if
you've never run it before.

```
$ ./run-container.sh certbot53 --email tom.eastman@koordinates.com certonly -d my-domain.com

Saving debug log to /certbot53/logs/letsencrypt.log
Found credentials in environment variables.
Plugins selected: Authenticator dns-route53, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for my-domain.com

(... etc ...)

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /certbot53/config/live/my-domain.com/fullchain.pem
   Your key file has been saved at:

(... etc ...)
```

You can renew certificates:

```
./run-container.sh certbot53 renew

Saving debug log to /certbot53/logs/letsencrypt.log

-------------------------------------------------------------------------------
Processing /certbot53/config/renewal/mydomain.com.conf
-------------------------------------------------------------------------------
Cert not yet due for renewal

(... etc ...)
```

And you can upload all certificates to vault:

```
./run-container.sh to-vault
Uploading my-domain.com to https://my-vault.com:8200/secret/letsencrypt/my-domain.com
Uploading my-domain2.com to https://my-vault.com:8200/secret/letsencrypt/my-domain2.com
```

Or you can dig them out of whatever persistent volume you've used for
the docker container image (defaults to `certbot53`).

## Configuration

You'll need to provide a handful of environment variables, or you can just use
the `run-container.sh` script, which will grab the variables from where they
most likely live if you're running from your home directory.

`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` are required for a user who has enough
permissions to manipulate Route 53 record sets of the zones you intend to generate
certificates for.

`VAULT_ADDR` and `VAULT_TOKEN` are required if you want to upload your certs
to a vault instance. `VAULT_CERT_PATH` if you want to upload them to a path other
than `/secret/letsencrypt/`.

If you use `run-container.sh`, all of certbot's state will be stored in a Docker
named-volume `certbot53`.
