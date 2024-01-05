# Set the base image to node:16-alpine
FROM node:16-alpine as builder

# Specify where our app will live in the container
WORKDIR '/app'

# Copy the React App to the container
COPY package.json .
# Prepare the container for building React
RUN npm install
COPY . .
# We want the production version
RUN npm run build

# Prepare nginx
FROM nginx:1.24.0-alpine
COPY --from=builder /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

# Fire up nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]