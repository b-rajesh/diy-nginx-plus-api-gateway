###  Configure your preferred IDP - OKTA, Auth0, AzureAD or Ping Identity -  to obtain token
```
Login to your preferred IDP to create App credentials that would be used to obtain the token. 

Create client-credential grant reource credentials and copy your client-id and secret-key securely somewhere.

Set up your IDP to accept a scope as "admin" and the token to have claims as "scp" : "admin" or whatever key/value you wanted in claims that would be present in the JWT.

Obtain the value of issuer & jwks_uri from the openid-configuration endpoint. Check the jwks_uri is returning one or more public key.

```
### Set up NGINX Plus with IDP to assert the token for all the API's
```
   Place the value of issuer in etc/nginx/policies/global/authz/issuer.conf.

   Place the value of jwks_uri in etc/nginx/policies/global/authz/oidc_authz.conf in location = /_jwks_uri .

   This above setup will validity & integrity of JWT token in the server block using IDP's public key and verifying the genral claims like exp, iat, iss and nbf claims.

   The public key from the IDP is also cached for configured time.
```
