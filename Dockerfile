# Use a node base image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Bundle app source
COPY . .

# Build the application
RUN npm run build

# Install serve to serve the build folder
RUN npm install -g serve

EXPOSE 3000

# Command to run the app
CMD ["serve", "-s", "build"]
