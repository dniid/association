# Development Dockerfile for Rails project

# Use the official Ruby image
FROM ruby:3.2.1

# Set the working directory
WORKDIR /rails

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libvips node-gyp pkg-config python-is-python3 && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN npm install -g yarn

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the server
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["tail", "-f", "dev/null"]
