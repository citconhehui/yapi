######## 构建 ########
FROM --platform=${BUILDPLATFORM:-amd64} node:12.16.3-alpine3.11 as builder

# 安装构建工具
RUN apk add --update --no-cache ca-certificates curl wget cmake build-base git bash python make gcc g++ zlib-dev autoconf automake file nasm \
  && update-ca-certificates

WORKDIR /yapi/vendors

COPY . /yapi/vendors

RUN npm install --production --registry https://registry.npm.taobao.org

RUN node server/app.js

######## 镜像 ########
FROM node:12.16.3-alpine3.11

WORKDIR /yapi

COPY --from=builder /yapi .

EXPOSE 3000

CMD ["node", "/yapi/vendors/server/app.js"]
