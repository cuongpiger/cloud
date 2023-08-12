# start from NodeJS 10 LTS image
FROM node:10

# specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# copy package.json, package-lock.json files and install dependencies
COPY package*.json ./
RUN npm install

# copy all files from the current directory to the image
COPY . .

# the default command to run when starting the container
CMD [ "npm", "start" ]
