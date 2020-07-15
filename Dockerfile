FROM nginx:latest
WORKDIR /usr/share/nginx/html
ARG version
RUN echo "BUILD_NUMBER: ${version}" > index.html
# new comment
#dddd