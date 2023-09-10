UI for managing containers in Docker, Docker Swarm, Kubernetes and Azure ACI

I want to use it as frontend for containers infrastructure spread accross multiple servers
	each server (node) has it's own Docker Engine with Portainer Agent container linking it to Portainer Servers

# architecture
`Portainer Server`
	"central" container managing agents
	require data persistence

`Portainer Agent`
	stateless container shipping data to Portainer Server
	deployed for each node in a cluster

## installation
install Docker Engine (preferably in NixOS, or [arch/debian](./docker))

`docker volume create portainer_data` for portainers db
`docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest` download&install Portainer Server
	`-d` detatched (background), `-p` map local port to container port
	`-v` mount host dir:container dir
	Portainer generates and uses a self-signed SSL certificate to secure port `9443`
`docker ps` container is there ^^
`https://localhost:9443` - check out the UI

use ublock origin to get rid of annoying BE add. seriously guys, not cool

Command for Portainer Agents are generated in Server interface. By default Server connects to Agent, so the Adent need to have appropriate port opened.
**If you can't open port / can't provide port redirection on router - use Edge Agent - it will probe Server for pending work**

