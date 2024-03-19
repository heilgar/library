# Wordpress and docker set up with nginx proxy manager

Base (fast) docker-compose configuration files for wordpress utilizing nginx and nginx proxy manager.
Purpose is to deploy multiple wordpress sites on a single host|vm using docker.

It's a raw configuration that require adjustsments.

Adjustsments notes: 
1. Consider pros and cons of using single nginx instance as `fast_cgi`.
2. Network setup is not secure. Must be imporved. Allow only 80 and 443 ports. Everythin else should be accecibla only using VPN.   
3. CI/CD pipeline.
4. Build wp as image and push to repository.
5. Fine tune nginx and php configurations

Current configuration showed on drawing 1. 
![Drawing 1](.docs/drawing-1.svg?sanitize=true)

