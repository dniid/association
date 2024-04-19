# Development Dockerfile for Rails project

# Use the official Ruby image
FROM ruby:3.2.1

ENV DEBIAN_FRONTEND noninteractive

# Set the working directory
WORKDIR /rails

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libvips node-gyp pkg-config python-is-python3 && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle

# Install node modules
RUN npm install -g yarn
COPY package.json yarn.lock ./
RUN yarn

# Copy application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["sh", "entrypoint.sh"]
