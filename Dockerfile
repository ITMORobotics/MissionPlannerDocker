ARG BASE_IMG

FROM ${BASE_IMG}

SHELL ["/bin/bash", "-ci"]
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir utils
WORKDIR /utils

RUN sh -c "$(wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh -O -)"
RUN apt update && \
    apt install -y ca-certificates gnupg wget zip unzip && \
    gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt install -y mono-devel

RUN wget -P /utils/ https://firmware.ardupilot.org/Tools/MissionPlanner/MissionPlanner-latest.zip && \
    unzip MissionPlanner-latest.zip -d MissionPlanner

WORKDIR /utils/MissionPlanner

CMD mono MissionPlanner.exe

