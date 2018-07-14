# Cricket Scoreboard

This application provides live scoreboards for professional cricket matches.

## Running the project locally

```
$ bundle install
$ bin/scoreboard
```

## Running the project using docker

```
$ docker build -t cricket-scoreboard .
$ docker run -it --name scoreboard -p 4567:4567 cricket-scoreboard
```
