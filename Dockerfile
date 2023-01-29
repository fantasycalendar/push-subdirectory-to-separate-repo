FROM node:12-slim

LABEL repository="https://github.com/fantasycalendar/push-subdirectory-to-separate-repo"
LABEL homepage="https://github.com/fantasycalendar/push-subdirectory-to-separate-repo"
LABEL maintainer="Axel <axel@fantasy-calendar.com>"

LABEL com.github.actions.name="GitHub Action to Push a Subdirectory to Another Repo"
LABEL com.github.actions.description="Automatically push a single subdirectory to a separate repo"
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="purple"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y jq

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
