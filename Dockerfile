#############################################
# DEV IMAGE
FROM node:18 AS dev  

# 1. Required for Prisma Client to work in container
# 2. Create app directory
# 3. Copy package package.json package-lock.json(application dependency manifests) in app directory 
# 4. Install app dependencies using the `npm ci` command instead of `npm install`
# 5. Copy source code
# 6. Generate Prisma database client code
# 7. Use the node user from the image (instead of the root user)


RUN apt-get update && apt-get install -y openssl
WORKDIR /usr/src/app
COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node . .
RUN npm run prisma:generate
USER node


#############################################
# BUILD FOR PRODUCTION

# 3. In order to run `npm run build` which creates the production bundle we need access to the Nest CLI.
# The Nest CLI is a dev dependency,
# In the previous development stage we ran `npm ci` which installed all dependencies.
# So we can copy over the node_modules directory from the development image into this build image.

FROM node:18-alpine As build
RUN apt-get update && apt-get install -y openssl
WORKDIR /usr/src/app
COPY --chown=node:node package.json package-lock.json /usr/src/app/
COPY --chown=node:node --from=dev /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .
RUN npm run build


#############################################
# Prod image

# 2. Installing dumb-init  -  Docker creates processes as PID 1, and they must inherently handle process signals to function properly. This can affect the ability to gracefully shut down our app. Instead, use a lightweight init system, such as dumb-init, to properly spawn the Node.js runtime process with signals support

# 3 copy over the dist directory from the prod build image into this build image.

# 3 ~ 6 copy over the bundle code, .env, p.json manifest from the prod build image into this build image.
# 7 Install main deps

# 8 copy prisma client


FROM node:18-slim
RUN apt update && apt install libssl-dev dumb-init -y --no-install-recommends
WORKDIR /usr/src/app
COPY --chown=node:node --from=build /usr/src/app/dist ./dist
COPY --chown=node:node --from=build /usr/src/app/.env .env
COPY --chown=node:node --from=build /usr/src/app/package.json .
COPY --chown=node:node --from=build /usr/src/app/package-lock.json .
RUN npm ci --only=production
COPY --chown=node:node --from=build /usr/src/app/node_modules/.prisma/client  ./node_modules/.prisma/client

ENV NODE_ENV production
EXPOSE 8000
CMD ["dumb-init", "node", "dist/src/main"]

