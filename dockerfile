FROM elixir:1.17.0

WORKDIR /Nomad
COPY . .
RUN mix deps.get
CMD [ "mix", "run" ]

EXPOSE 3000