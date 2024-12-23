# Base image
FROM postman/newman:5.3.1-alpine

# Update and upgrade packages
RUN apk update && apk upgrade --no-cache

# Install extra packages
RUN apk add --no-cache curl zip iputils

# Install global node module
RUN npm install -g newman-reporter-csvallinone

# Remove installation cache
RUN rm -rf /var/cache/apk/*

# Set environment variable
ENV NODE_PATH=/usr/local/lib/node_modules

# Set working directory
WORKDIR /etc/newman

# Set entry point
ENTRYPOINT ["newman"]

