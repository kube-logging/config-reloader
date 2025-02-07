FROM golang:1.23.6-alpine3.20@sha256:22caeb4deced0138cb4ae154db260b22d1b2ef893dde7f84415b619beae90901 AS builder

WORKDIR /workspace

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
COPY pkg pkg

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download
RUN go mod tidy

# Copy the go source
COPY /cmd/configreloader/main.go main.go

# Build
RUN CGO_ENABLED=0 go build -a -o config-reloader main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:latest

WORKDIR /

COPY --from=builder /workspace/config-reloader .

ENTRYPOINT ["/config-reloader"]
