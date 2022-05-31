# builder
FROM node:14-alpine AS builder
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json ./
# 使用国内镜像，防止安装依赖失败，
RUN npm install --registry=https://registry.npm.taobao.org 
RUN npm prune --production

# runner
FROM node:14-alpine
WORKDIR /yapi
COPY ./config-hw.json ./config.json
WORKDIR /yapi/vendors
COPY . .
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD [ "npm", "run", "start" ]