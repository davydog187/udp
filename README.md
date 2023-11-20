# UDP

A small project that I used to build an understanding of how to send UDP packets between two Docker containers.

This project contains an Elixir program than runs in two modes, sender and receiver. The sender sends a message ever 3 seconds to the destination address, and the receiver listens and prints the message.

To run, simply do:

``` shell
$ docker compose up
```

## Related reading

- https://github.com/erlang/otp/issues/5092
