# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

################################################################################
# Pick a base image to serve as the foundation for the other build stages in
# this file.
#
# For illustrative purposes, the following FROM command
# is using the alpine image (see https://hub.docker.com/_/alpine).
# By specifying the "latest" tag, it will also use whatever happens to be the
# most recent version of that image when you build your Dockerfile.
# If reproducability is important, consider using a versioned tag
# (e.g., alpine:3.17.2) or SHA (e.g., alpine@sha256:c41ab5c992deb4fe7e5da09f67a8804a46bd0592bfdf0b1847dde0e0889d2bff).
FROM alpine:3.20 AS base

################################################################################
# Create a stage for building/compiling the application.
#
# The following commands will leverage the "base" stage above to generate
# a "hello world" script and make it executable, but for a real application, you
# would issue a RUN command for your application's build process to generate the
# executable. For language-specific examples, take a look at the Dockerfiles in
# the Awesome Compose repository: https://github.com/docker/awesome-compose
FROM base AS build

# create a working directory called NomadEngine
WORKDIR /NomadEngine

# copy all the files to the container
COPY . /NomadEngine/

# install elixir
RUN apk add --no-cache erlang elixir

# install necessary components
RUN apk --update add --no-cache sudo git make erlang erlang-crypto erlang-syntax-tools \
    erlang-inets erlang-ssl erlang-public-key erlang-asn1 erlang-sasl \
    erlang-erl-interface erlang-dev erlang-parsetools erlang-eunit erlang-tools

# set the elixir version
ENV ELIXIR_VERSION = v1.17.0

# get the elixir version and install locally on base
#RUN wget https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/precompiled.zip && \
#    unzip precompiled.zip && \
#    rm precompiled

RUN mix local.hex --force && \
    mix local.rebar --force

# Set the path variable to include elixir's bin path
#ENV PATH=$PATH:/NomadEngine/elixir/bin
#ENV PATH=$PATH:/usr/local/bin

# Verify elixir is installed correctly
#RUN elixir --version

# install the project dependencies
#RUN mix deps.get

# Install project dependencies locally, compile them
#RUN mix deps.compile

################################################################################
# Create a final stage for running your application.
#
# The following commands copy the output from the "build" stage above and tell
# the container runtime to execute it when the image is run. Ideally this stage
# contains the minimal runtime dependencies for the application as to produce
# the smallest image possible. This often means using a different and smaller
# image than the one used for building the application, but for illustrative
# purposes the "base" image is used here.
FROM base AS final

# Create a non-privileged user that the app will run under.
# all subsequent RUN commands are run as appuser
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

# What the container should run when it is started.
# ENTRYPOINT [ "/bin/hello.sh" ]

# run the elixir application
#CMD ["mix", "run"]
#CMD ["mix", "run"]
