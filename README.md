# Computational Chemistry Docker Images

[ ![Codeship Status for molecular-toolkit/chemistry-docker-images](https://app.codeship.com/projects/cabf3b40-8d0a-0135-07c8-724a96aff59c/status?branch=master)](https://app.codeship.com/projects/249637)

This repository stores definitions for building docker images for various open source computational chemistry packages.  These images are built from definitions contained in the DockerMakefiles in this directory (everythign with a `.yml` extension), and should be built with the [`DockerMake` program](https://github.com/avirshup/DockerMake).


# Using these images
These images are automatically built and pushed to [DockerHub](http://hub.docker.com). The images are pushed to dockerhub - https://hub.docker.com/u/chemdocker/ and can be run at the command line with `docker run -it chemdocker[image-name]:[version] bash`.

### Creating new images
Note: to use these images, we highly recommend simply pulling them from DockerHub (see above); it's only necessary to build them yourself if you want to make modifications.

##### Install DockerMake:
We use the `docker-make` command line utility to build and manage MDT's docker images. To install it:
```bash
pip install DockerMake
```

Run the following commands at the root of this repository:

##### List docker images:
```bash
docker-make --list
```

##### Build a specific image from that list:
```bash
docker-make nwchem
```

##### Build all docker images:
```bash
docker-make --tag dev --all
```

##### Build a new version of all docker images then push to an image registry:
```bash
docker-make --repo [registry url]/[registry organization] --push --tag [version tag]
```

# Legal
### Please note:
All licenses and copyright notices apply ONLY to the YML-format files in this directory. The docker images built using the instructions in these files are licensed separately; their licenses can be found in [the LICENSES directory](image-licenses/).


### License
Copyright 2015-2017 Autodesk Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
