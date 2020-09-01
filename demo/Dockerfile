FROM circleci/python:3.8-buster-node as builder

RUN sudo pip install \
  girder \
  girder-google-analytics \
  git+https://github.com/girder/item_tags.git \
  girder-oauth \
  girder-readme \
  girder-sentry
RUN sudo girder build
# Remove Python bytecode files and node_modules, so the runtime doesn't copy them
RUN sudo find /usr/local/lib/python3.8/site-packages/ -type d \( -name __pycache__ -o -name node_modules \) -prune -exec rm -r {} +


FROM python:3.8-buster as runtime
LABEL maintainer="Kitware, Inc. <kitware@kitware.com>"
EXPOSE 8080

# Set environment to support Unicode: http://click.pocoo.org/5/python3/#python-3-surrogate-handling
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY --from=builder /usr/local/bin/girder /usr/local/bin/girder
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=builder /usr/local/share/girder/static/ /usr/local/share/girder/static/
# Add a config file, to bind the server to all network interfaces inside the container
RUN echo '[global]\nserver.socket_host = "0.0.0.0"\n' > /etc/girder.cfg

ENTRYPOINT ["girder", "serve"]
