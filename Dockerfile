# use a multi-stage build to get a small runtime container
FROM golang:alpine as build

WORKDIR /go/src/github.com/cjdiaz1294/go-docker/
# copy source code and make sure to use a .dockerignore file
COPY . .
# build the go binary
RUN GOOS=linux go build -a -o go-docker .

# create a minimal runtime container
FROM alpine:3.7
# update and upgrade packages, install some packages
RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates && \
# create an app group in user so this does not run as root
    addgroup -S appgroup && \
    adduser -S -H -u 2000 -D -G appgroup appuser

WORKDIR app
# copy the binary from the build container
COPY --from=build /go/src/github.com/cjdiaz1294/go-docker/go-docker .
# use a non-root user
USER appuser
# start the app
CMD ["./go-docker"]