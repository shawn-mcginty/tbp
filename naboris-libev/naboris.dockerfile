FROM node:14-stretch
EXPOSE 9000
WORKDIR /naboris
COPY ./src ./src
COPY ./esy.json .
COPY ./dune-project .
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y libev-dev
RUN npm -g config set user root
RUN npm install -g esy
RUN esy install -q
RUN esy b dune build src/App.exe
CMD esy b dune exec src/App.exe
