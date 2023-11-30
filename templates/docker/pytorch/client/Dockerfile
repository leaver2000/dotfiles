FROM node:19.8.1-buster as builder
WORKDIR /app
# copy package.json and package-lock.json
COPY package*.json ./
# install dependencies
RUN npm install --silent
# copy everything else
COPY . .
# build app
RUN npm run build
# serve the client application with nginx
FROM nginx:alpine
WORKDIR /app
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
