ARG NODE_VERSION="16.18-slim"

# change with the Linux Alpine version of your choice
# ARG ALPINE_VERSION="3.16"

# FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS development
FROM node:${NODE_VERSION} AS development


# RUN apt-get update \
#   && apt-get instal openssl1.1-compat

WORKDIR /app

COPY package*.json ./

COPY prisma ./prisma

RUN npm install

# RUN npx prisma db pull && prisma generate
RUN npx prisma generate

COPY . .

RUN npm run build 

# FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} as production
FROM node:${NODE_VERSION} as production

# ARG NODE_ENV=production
# ENV NODE_ENV = ${NODE_ENV}}

# WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm install --only=prod

# COPY . .

COPY --from=development /app/node_modules ./node_modules
COPY --from=development /app/package*.json ./
COPY --from=development /app/dist ./dist


EXPOSE 8000
CMD [ "npm", "run", "start:prod" ]