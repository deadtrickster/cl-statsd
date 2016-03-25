## StatsD client in Common Lisp

```lisp
(let ((statsd:*client* (statsd:make-sync-client)))
  (loop for i from 0 to 99 do
    (statsd:counter "example" (random 100))
    (sleep 1)))
```

![Result](http://i.imgur.com/OnfuYng.png)

## Error handling
By default all error simply ignored. You can customize this behaviour 
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

- [ ] Tests
- [x] Auto-reconnects for async client
- [ ] Pipelines

## License
MIT
