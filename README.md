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

## Metrics API

If you are not familiar with statsd metric types read [this](https://github.com/etsy/statsd/blob/master/docs/metric_types.md) first

- `counter (key value &key (rate) (client *client*))`
- `inc (key &key (rate) (client *client*))` - shortcut for `(counter key 1 ...)`
- `dec (key &key (rate) (client *client*))` - shortcut for `(counter key -1 ...)`
- `timing (key value &key (rate) (client *client*))`
- `with-timing ((key &optional (client '*client*)) &body body)` - executes body and collects execution time
- `guage (key value &key (rate) (client *client*))`
- `set (key value &key (rate) (client *client*))`

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

## Clients
- `null` like /dev/null
- `fake` queues metrics. Useful for debugging, testing
```lisp
(let ((statsd::*client* (statsd:make-fake-client)))
  (statsd:counter "example" (random 100))
  (statsd:fake-client-recv))
"example:62|c"
```
- `sync` calls transport synchronously
- `async` more like 'connection-as-a-service', runs in separate thread, all metrics queued first

## Transports
CL-STATSD comes with the following transport:
- `usocket` - sends meterics to statsd

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
