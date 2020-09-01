# compile runner
FROM golang:1.6 as builder

RUN go get github.com/tools/godep
COPY runner /go/src/github.com/square/shift/runner
RUN cd /go/src/github.com/square/shift/runner \
    && godep get ./... \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o runner .

# ui / runner runtime
FROM ruby:2.3

# install deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgmp3-dev \
    lsb-core \
    ruby-dev \
    supervisor

# install gh-ost
RUN wget https://github.com/github/gh-ost/releases/download/v1.0.49/gh-ost_1.0.49_amd64.deb \
    && dpkg -i gh-ost_1.0.49_amd64.deb

# copy / install ui
COPY ui/Gemfile ui/Gemfile.lock /opt/code/ui/
RUN cd /opt/code/ui \
    && gem install bundler -v'1.13.7' \
    && bundle install
COPY ui /opt/code/ui

# copy runner executable
COPY --from=builder /go/src/github.com/square/shift/runner/runner /opt/code/runner/

# create shift log dir
RUN mkdir -p /tmp/shift

# copy entrypoint script
COPY docker-entrypoint.sh /opt/code/

# runtime
WORKDIR /opt/code
# EXPOSE 9195 
ENTRYPOINT ["/opt/code/docker-entrypoint.sh"]
# CMD ["supervisord", "-n"]
