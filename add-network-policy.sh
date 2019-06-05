 cf add-network-policy gateway --destination-app time --port 8080 --protocol tcp
 cf add-network-policy gateway --destination-app echo --port 8080 --protocol tcp
 cf add-network-policy gateway --destination-app whoami --port 8080 --protocol tcp
 cf add-network-policy gateway --destination-app greeting --port 8080 --protocol tcp
