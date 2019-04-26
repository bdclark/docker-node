# steadyserv/node Docker Images

[![Build Status](https://travis-ci.org/bdclark/docker-node.svg?branch=master)](https://travis-ci.org/bdclark/docker-node)

These images are based off the [official][1] Node.js docker images with some additional functionality:

- Commands beginning with `node` or `npm` run as `node` user by default.
- Runs [tini][2] as PID 1 9for environments where `--init` flag cannot be used on container creation)
- Images derived from these base images are expected to use `/app` as the application directory. Everything in this directory will be recursively chowned to the node user at runtime.
- On any derived images the `.npm` directory is excluded from the image during build to prevent the npm cache from landing in the image.

## Distributions and versions
Images are built using the `alpine` and `slim` variants of the official node images. The following image tags are available:

- `x.y.z-alpine` - specific version (e.g. `10.15.3`) on alpine
- `x.y.z-slim` - specific version (e.g. `10.15.3`) on debian
- `x.y-alpine` - most recent of major.minor (e.g. `10.15`, `12.0`) on debian
- `x.y-slim` - most recent of major.minor (e.g. `10.15`) on debian
- `x-alpine` - most recent of major version (e.g. `8`, `9`, `10`, `12`) on alpine
- `x-slim` - most recent of major version (e.g. `8`, `9`, `10`, `12`) on debian
- `lts-alpine` - current LTS on alpine
- `lts-slim` - current LTS on debian slim
- `latest` - most recent version on alpine

## Example Usage
Below is an example of how to use in a derived image:
```
FROM steadyserv/node:10-alpine

# set environment, can be overridden with --build-arg
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV:-production}

# allow Docker build to access your private npm registry
COPY .docker_npmrc /root/.npmrc

# Install app dependencies
COPY package*.json ./
RUN npm install

# Bundle app source
COPY . ./

EXPOSE  8080

CMD ["npm", "start"]
```
In the example above, using `--build-arg NODE_ENV=development` would include dev dependencies during the install phase... otherwise it will default to production.

[1]: https://hub.docker.com/_/node/
[2]: https://github.com/krallin/tini
