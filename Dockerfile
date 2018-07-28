FROM golang:alpine as build

WORKDIR /go/src/github.com/cjdiaz1294/go-docker/
COPY . .
RUN GOOS=linux go build -a -o go-docker .

FROM alpine:3.7
RUN apk --no-cache add ca-certificates
WORKDIR app
COPY --from=build /go/src/github.com/cjdiaz1294/go-docker/go-docker .
CMD ["./go-docker"]