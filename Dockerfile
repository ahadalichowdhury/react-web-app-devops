# Use a base image for building the app
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code and build the app
COPY . .
RUN npm run build

# Serve the built app using a lightweight server
FROM node:18-alpine AS production

WORKDIR /app

# Install serve globally and check the version
RUN npm install -g serve && serve --version

# Copy the build output to the production container
COPY --from=build /app/dist /app/dist

# Expose the port where the app will run
EXPOSE 3000

# Run the serve command to serve the app
CMD ["serve", "-s", "dist"]
