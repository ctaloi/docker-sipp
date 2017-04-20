# Docker container for SIPp

Docker container for running [SIPP](http://sipp.sourceforge.net/index.html).  Builds version 3.5 from [Github ](https://github.com/SIPp/).

## Getting Started

Pull the latest image using:

```
$ docker pull ctaloi/sipp
$ docker run -it ctaloi/sipp
```

or clone this repo and

```
$ docker build -t sipp
$ docker run -it sipp
```

## Usage

You can pass your SIPp arguments to the run command, example:

```
$ docker run -it ctaloi/sipp -sn uas
```

If you want to use custom scenarios you can use the Docker VOLUME argument to include your local files inside your Docker image.  The `-v /root/sipp-docker/scenarios` is your local hosts working directory and `/sipp` is the containers working directory.

```
$ docker run -it -v /root/sipp-docker/scenarios:/sipp -p 5060 ctaloi/sipp -sf opt1.xml DEST_IP -s DEST_NUMBER
```

RFC2833 PCAPs are included in the REPO and can be called in your scenarios using the same syntax as above.  This method can also be used to write logs from the container to the local directory.

If you want to expose port 5060 (so you can send SIP _to_ SIPp from a remote host) you can start the container using the `-p` flag and then inspect the container to determine the external port.  I started three containers running SIPp using `docker run -d -p 5060 ctaloi/sipp -sn uas` and now have ports `32785-32878` mapped to each SIPp instance.  SIPp now appears on port 5060 of the contianer but 32785 externally.

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                     NAMES
7569c4574ba1        ctaloi/sipp         "sipp -sn uas"   2 seconds ago        Up 1 seconds        0.0.0.0:32787->5060/tcp   angry_carson
dcd96ba4420a        ctaloi/sipp         "sipp -sn uas"   About a minute ago   Up About a minute   0.0.0.0:32786->5060/tcp   jovial_mcclintock
018781761d5a        ctaloi/sipp         "sipp -sn uas"   2 minutes ago        Up 2 minutes        0.0.0.0:32785->5060/tcp   angry_roentgen

$ docker inspect 7569c4574ba1
...
     "Ports": {
                "5060/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "32787"
                    }
                ]
            },
```

You can also map port 5060 externally to 5060 on your container using the same argument but declaring both ports:

```
$ docker run -d -p 5060:5060 ctaloi/sipp -sn uas

      "Ports": {
                "5060/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "5060"
                    }
                ]
            },

```

To run SIPp in background (detached from your terminal) you can start SIPp using the `-d` argument and then control with `docker start/stop ctaloi/sipp`/.  You can then view the logs (SIPp STDOUT) from the container using the `docker logs` commands.  Example running SIPp using the default UAS scenario in the background.

```
$ docker run --name sipp-uas -d -p 5060 ctaloi/sipp -sn uas
$ docker logs -f sipp-uas
...
```
