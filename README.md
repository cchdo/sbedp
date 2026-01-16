# sbedp
A dockerized version of the SeaBird Data Processing Tools with the following features:

* Lightweight Window Manager with a VNC server (inherited from the base image)
* Built in browser based VNC client (inherited from the base image)
* Windows SeaBird Software working under a wine layer
* Works on arm based macs M1 or later, will probably work on Arm based linux machines

## Getting the Image

Right now this image is built for aarch64 processors with the main deployment target being recent Apple computers (M1+).

Pull the image
```
docker pull ghcr.io/cchdo/sbedp
```

This will grab the "latest" image which will be the most recent tagged version, it is however considered best practice to use a specific tag and not latest. This image is using calver so the specific releases will be int he form of e.g. `v2025.07.0` for the first release done in July of 2025.

See the [github package page](https://github.com/cchdo/sbedp/pkgs/container/sbedp) for all the tagged versions and how to get them.

## Running

A basic run command is:

```
docker run --rm -it -p 3000:3000 ghcr.io/cchdo/sbedp bash
```

--rm deletes the container on exit
-it lets you interact with it in the terminal
-p 3000:3000 maps the internal server port to the host one, this is only needed if you want to interact with the VNC server
ghcr.io/cchdo/sbedp is the name of the container image, if this is does not specify a tag (:<something>) it will automatically use :latest
bash is the command to run inside, if one is not specified, you'll need to kill/stop the container from another terminal session

### Run with local data access
To actually process data it is more useful to map in a directory from the host system that contains data that needs to be processed.
To do this use the -v flag in the docker run invocation.
We will be mapping a directory into the the "C" drive directory of the container.
The following maps the current working directory `./` into the C drive of wine under a ctd_data dir.

```
docker run --rm -it -p 3000:3000 -v ./:/.wine/drive_c/ctd_data ghcr.io/cchdo/sbedp bash
```

## Interaction
Assuming you are running this on your local machine and have done the "docker run" command above...

Open a browser and go to localhost:3000

You should be seeing a terminal window in the browser.

run
```
wine SBEDataProc.exe
```

And the sea bird data processing program should pop up.

## Building:
The base image is ubuntu 24.04 with a very lightweight window manager, vnc server, and browser based control server.

It installs [hangover](https://github.com/AndreRH/hangover) 11.0 and the runtime requirements (visual basic 2010 and 2012) for SBEDataProcessing using winetricks.
The SeaBird processing software is then copied to the correct place in the image along with the system registry.

To build:

while in the same directory as the Dockerfile:

```
docker build -t some_tag .
```