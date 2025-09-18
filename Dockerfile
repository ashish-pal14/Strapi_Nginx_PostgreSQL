#Multi-Stage Dockerfile 

#Build Stage-----------------

#Large-image but need to import all the required packages -
FROM node:18-alpine AS build         

#Working Directories where application install-
WORKDIR /src/strapi

#Copy Package files and install dependencies -
COPY package*json ./
RUN npm install

#Copy source code
COPY . .

#Build Strapi admin panel -
<<<<<<< HEAD
RUN npm run build
=======
RUN npm run develop
>>>>>>> 4a420c1ac40ba137fb5fded19c55f09dd4316134



#Runtime Stage -------------------
FROM node:18-alpine

WORKDIR /src/strapi

#Copy only what is needed for production:
COPY --from=build /src/strapi/package*.json ./
# COPY --from=build /usr/src/strapi/node_modules ./node_modules
COPY --from=build /src/strapi/build ./build
COPY --from=build /src/strapi/config ./config
COPY --from=build /src/strapi/src ./src
COPY --from=build /src/strapi/public ./public

#Set enviroment variables:
ENV NODE_ENV=production
ENV PORT=1337

EXPOSE ${PORT}


<<<<<<< HEAD
CMD [ "npm", "run", "start" ]
=======
CMD [ "npm", "start" ]
>>>>>>> 4a420c1ac40ba137fb5fded19c55f09dd4316134
