# UDP

A small project that I used to build an understanding of how to send UDP packets between two Docker containers.

This project contains an Elixir program than runs in two modes, sender and receiver. The sender sends a message ever 3 seconds to the destination address, and the receiver listens and prints the message.

To run, simply do:

## Run example of two containers talking over UDP

``` shell
$ docker compose up
```

## Run example of container sending data to host service over UDP

1. Start the receiver `TYPE=receiver mix run`
2. Start the sender `docker compose -f docker-compose.host.yml up` 

## Related reading

- https://github.com/erlang/otp/issues/5092
