FROM elixir

MAINTAINER Nikko Miu <nikkoamiu@gmail.com>

ENV MIX_ENV=prod

RUN apt-get update

# Setup NodeJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install nodejs -y

# Setup Phoenix
RUN mix local.hex --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Make App Directory
RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY Makefile /usr/app

# Get App Dependencies
COPY mix.exs /usr/app
COPY mix.lock /usr/app
RUN make deps

# NodeJS Dependencies
COPY package.json /usr/app
RUN make assets

# Copy App
COPY . /usr/app

# Build App
RUN make build
