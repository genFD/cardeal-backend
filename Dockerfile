#############################################
# VARIABLES
ARG NODE_VERSION=18.15.0
ARG ALPINE_VERSION=3.17
ARG NODE_ENV_PROD=production
ARG NODE_ENV_DEV=development
ARG PORT=8000
ARG SHA=sha256:19eaf41f3b8c2ac2f609ac8103f9246a6a6d46716cdbe49103fdb116e55ff0cc

#############################################
# BASE IMAGE
FROM node:18-alpine@${SHA} AS base
# FROM node:18-alpine AS base
# FROM node:NODE_VERSION-alpineALPINE_VERSION AS base
RUN apk update \
  # 1. Required for Prisma Client to work in container
  && apk add openssl1.1-compat \ 
  && apk add dumb-init 
WORKDIR /usr/src/app

#############################################
# DEV IMAGE
FROM base AS development

# 1. Required for Prisma Client to work in container
# 2. Create app directory
# 3. Copy package package.json package-lock.json(application dependency manifests) in app directory 
# 4. Install app dependencies using the `npm ci` command instead of `npm install`
# 5. Copy source code
# 6. Generate Prisma database client code
# 7. Use the node user from the image (instead of the root user)

# RUN apk update \
#   && apk add openssl1.1-compat
# WORKDIR /usr/src/app
COPY  package*.json ./
COPY prisma ./prisma/
RUN npm ci
COPY  . .
RUN npm run prisma:generate
USER node


#############################################
# BUILD FOR PRODUCTION

# 3. In order to run `npm run build` which creates the production bundle we need access to the Nest CLI.
# The Nest CLI is a dev dependency,
# In the previous development stage we ran `npm ci` which installed all dependencies.
# So rather than running npm install again, we can just copy over the node_modules directory from the development image into this build image.

FROM base As build
COPY --chown=node:node package.json package-lock.json ./
COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules 
COPY --chown=node:node . .
RUN npm run build




#############################################
# Prod image

# 2. Installing dumb-init  -  Docker creates processes as PID 1, and they must inherently handle process signals to function properly. This can affect the ability to gracefully shut down our app. Instead, use a lightweight init system, such as dumb-init, to properly spawn the Node.js runtime process with signals support
# 3 copy over the dist directory from the prod build image into this build image.
# 3 ~ 6 copy over the bundle code, .env, p.json manifest from the prod build image into this build image.
# 7 Install main deps
# 8 copy prisma client


FROM base As production
# RUN apk update \
#   && apk add openssl1.1-compat
# RUN apt update && apt install libssl-dev dumb-init -y --no-install-recommends

ENV NODE_ENV=${NODE_ENV_PROD}

# WORKDIR /usr/src/app
COPY --chown=node:node --from=build /usr/src/app/dist ./dist
COPY --chown=node:node --from=build /usr/src/app/prisma ./prisma
COPY --chown=node:node --from=build /usr/src/app/.env .env
COPY --chown=node:node --from=build /usr/src/app/package.json .
COPY --chown=node:node --from=build /usr/src/app/package-lock.json .
# RUN npm ci --only=production
RUN npm ci --omit=dev
COPY --chown=node:node --from=build /usr/src/app/node_modules/.prisma/client  ./node_modules/.prisma/client
EXPOSE 8000
# CMD ["dumb-init", "node", "dist/src/main"]
CMD [  "npm", "run", "start:migrate:prod" ]


		
