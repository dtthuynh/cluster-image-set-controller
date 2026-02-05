FROM registry.ci.openshift.org/stolostron/builder:go1.25-linux AS builder
WORKDIR /go/src/github.com/stolostron/cluster-imageset-controller
COPY . .
ENV GO_PACKAGE github.com/stolostron/cluster-imageset-controller

# Optional: set to the git branch (e.g. backplane-2.12) so the default sync branch matches the build.
ARG GIT_BRANCH=
ENV GIT_BRANCH=${GIT_BRANCH}

# Build
RUN make build --warn-undefined-variables

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

# Add the binaries
COPY --from=builder /go/src/github.com/stolostron/cluster-imageset-controller/bin/clusterimageset .
