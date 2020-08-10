### Configuring API Gateway to assert OIDC JWT on different claims

####  Step 1: Filter the claims you want to assert by placing the .conf file in the etc/nginx/policies/jwt_claims_filter/ This configuration will be automatically loaded as part of http context
      For eg: To filter the "aud" claim from the JWT, define the claim name with the directive to get the value of it.  

         auth_jwt_claim_set $f1_api_aud aud; 

      Apply map directive so that nginx plus will evaluate the claims whether your desired value is present, with this example the desire aud claim the api expect as ui.blah.com/consumers/v1

         map $f1_api_aud $isClientAllowedAudience { 
               "ui.blah.com/consumers/v1" 1;
               default                    0;
         }
#### Step 2: To assert the above filtered "aud" claim , place this if condition in the etc/nginx/policies/jwt_claims_assertion/ with api name
      
      if ( $isClientAllowedAudience = 0 ) {
         return 403; # Forbidden
      }
#### Step 3: include the above .conf file in the appropriate api, that was placed in the etc/nginx/routes/ as include directive inside the location block
      eg: include /etc/nginx/policies/jwt_claims_assertion/f1-api.conf;

#### For easy onboarding and maintenance, it would name the .conf files created in above steps as same as routes and upstreams file names

      etc/nginx/policies/jwt_claims_filter/f1-api.conf # [No need of explicit need to include this configuration, will be loaded as part the http context.].

      etc/nginx/policies/jwt_claims_assertion/f1-api.conf # [This need explicit include in the etc/nginx/routes/f1-api.conf to apply api specific assertion].

      etc/nginx/routes/f1-api.conf # [Routes for the API which will be consumed by your customers, will be loaded as part of server context, no need to refer explicitly].

      etc/nginx/upstreams/f1-api.conf  # [Upstream endpoint to route the incoming request, will be loaded as part of server context, no need to refer explicitly].
