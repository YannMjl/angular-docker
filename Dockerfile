# --------------------------------------------------------------*
# 1. build angualr app
# --------------------------------------------------------------*
FROM node as build_ng

# update depedencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# create app directory
WORKDIR /app

# copy depedencies
COPY package*.json /app

# install
RUN npm install -g npm-check-updates \
    ncu -u \
    npm install

# copy everything 
COPY . .

RUN npm install -g @angular/cli \
    npm run build --prod

# --------------------------------------------------------------*
# 2. Run the anglar app
# --------------------------------------------------------------*
FROM nginx
COPY --from=build_ng /app/public /usr/share/nginx/html