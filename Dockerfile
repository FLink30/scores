FROM ruby:latest

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xz-utils \
    curl

# Create directory for Xcode Command Line Tools
RUN mkdir -p /XcodeCommandLineTools

# Set working directory
WORKDIR /XcodeCommandLineTools

# Download and install Xcode Command Line Tools
RUN curl -fsSL -o Xcode_CLI_Tools.dmg https://developer.apple.com/download/more/?=command%20line%20tools && \
    tar -xvf Xcode_CLI_Tools.dmg && \
    hdiutil attach Xcode_CLI_Tools.dmg && \
    installer -pkg /Volumes/*/Install*.pkg -target / && \
    hdiutil detach /Volumes/*/ && \
    rm -rf Xcode_CLI_Tools.dmg

# Additional configuration steps if needed
