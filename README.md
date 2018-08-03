# Getting started

Copy terraform.tfvars.in -> terraform.tfvars
Edit to match your Oracle Cloud details.
Create an SSH key and place in the appropriate place referenced in terraform.tfvars

## Bringing it up

    terraform plan
    terraform apply

Answer 'yes' when requested and wait for it to finish.

Output:

    Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

    Outputs:

    InstanceNames = [
        zimbraxdev_docker0,
        zimbraxdev_docker1,
        zimbraxdev_docker2
    ]
    PrivateIPs = [
        10.0.1.2,
        10.0.1.3,
        10.0.1.4
    ]
    PublicIPs = [
        129.146.130.218,
        129.146.8.177,
        129.146.40.205
    ]


## Docker swarm instructions


Pick 2 or more nodes and swarm them together:

Example below shows a swarm of 3 managers.
VM 1

    docker swarm init
    Swarm initialized: current node (zcdlxmwrdgo3hqn2j5exzg897) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-2ky88qfryck45dbows9mre720pxsrkgx5psxxkpg5hkfrimbb3-6nn6gs1geq0v8j0lp35ss3met 10.0.4.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

    docker swarm join-token manager

To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-2ky88qfryck45dbows9mre720pxsrkgx5psxxkpg5hkfrimbb3-0kc3vqbp5m11gpa7sxf5yz9wl 10.0.4.2:2377

VM 2

    docker swarm join --token SWMTKN-1-2ky88qfryck45dbows9mre720pxsrkgx5psxxkpg5hkfrimbb3-0kc3vqbp5m11gpa7sxf5yz9wl 10.0.4.2:2377

	This node joined a swarm as a manager.

VM 3

    docker swarm join --token SWMTKN-1-2ky88qfryck45dbows9mre720pxsrkgx5psxxkpg5hkfrimbb3-0kc3vqbp5m11gpa7sxf5yz9wl 10.0.4.2:2377

	This node joined a swarm as a manager.


Simple Swarm Definition

Create a file named ‘simple-swarm.yml’ on VM 1:

    version: '3.3'

    services:
      nginx-worker:
        image: nginx
        deploy:
          mode: replicated
          replicas: 3
          endpoint_mode: dnsrr

Start up the nginx test stack:


    docker stack deploy -c simple-swarm.yml nginx-worker

    Creating network nginx-worker_default
    Creating service nginx-worker_nginx


Check to make sure the services deployed:

	docker service ls


    ID                  NAME                 MODE                REPLICAS            IMAGE               PORTS
    iz504af8myuh        nginx-worker_nginx   replicated          3/3                 nginx:latest


Check to ensure they have been distributed amongst the managers:

    docker service ps --format "{{.Name}} node={{.Node}}" nginx-worker_nginx
    nginx-worker_nginx.1 node=zimbraxdev-docker1
    nginx-worker_nginx.2 node=zimbraxdev-docker2
    nginx-worker_nginx.3 node=zimbraxdev-docker0
