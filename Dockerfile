# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM openjdk:8

MAINTAINER FUJI Goro <g.psy.va+github@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV ANDROID_DEPS="libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386"
ENV NODE_VERSION=7.7.2

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq ${ANDROID_DEPS} --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components

# License Id: android-sdk-license-ed0d0a5b
ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.1, android-23
# License Id: android-sdk-license-5be876d5
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" ; \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"

# Install nodejs and yarn
RUN curl -L http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz | tar --no-same-owner -xJ -C /usr/local
ENV PATH /usr/local/node-v${NODE_VERSION}-linux-x64/bin:$PATH
RUN npm install -g yarn

# Support Gradle
ENV TERM dumb

WORKDIR /usr/src/app
