## [StatsD](https://github.com/etsy/statsd) client in Common Lisp

## Speed
CL-STATSD is relatively fast:

```lisp
(let ((statsd::*client* (statsd:make-sync-client)))
  (loop for i from 0 to 999999 do
    (statsd:counter "self-test" 1)))
```

Using [this](https://github.com/hopsoft/docker-graphite-statsd) Docker image with defaults
on busy VM.

![Result](http://i.imgur.com/mrBf35w.png)

## Error handling
By default all errors simply ignored. You can customize this behaviour 
by providing :error-handler strategy:
```lisp
(let ((statsd:*client* (statsd:make-sync-client :error-handler :throw)))
  (loop for i from 0 to 3 do
    (statsd:counter "example" (random 100))
    (statsd::transport.close (statsd::client-transport statsd:*client*))))
; Evaluation aborted on #<CL-STATSD:TRANSPORT-ERROR {1005445653}>.
```
New error handling strategies can be created by specializing `handler-handle-error/2`

## Transports
CL-STATSD comes with the following transports:
- `null` like /dev/null
- `fake` queues metrics. Useful for debugging, testing
```lisp
(let ((statsd::*client* (statsd:make-fake-client)))
  (statsd:counter "example" (random 100))
  (statsd:fake-client-recv))
"example:62|c"
```
- `usocket` actually sends meterics to statsd

New transports can be created by specializing
- `make-transport`
- `transport.connect`
- `transport.send`
- `transport.close`


## TODO
- [ ] Async client throttling
- [ ] Travis CI integration
- [ ] Pipelines

## License
MIT
