## [StatsD](https://github.com/etsy/statsd) client in Common Lisp

If you are not familiar with statsd read [this](https://codeascraft.com/2011/02/15/measure-anything-measure-everything/).
To learn about statsd metric types read [this](https://github.com/etsy/statsd/blob/master/docs/metric_types.md).

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

- `counter (key value &key (rate) (client *client*))`
- `inc (key &key (rate) (client *client*))` - shortcut for `(counter key 1 ...)`
- `dec (key &key (rate) (client *client*))` - shortcut for `(counter key -1 ...)`
- `timing (key value &key (rate) (client *client*))`
- `with-timing ((key &optional (client '*client*)) &body body)` - executes body and collects execution time
- `guage (key value &key (rate) (client *client*))`
- `set (key value &key (rate) (client *client*))`

Sampling rate can be controlled using `*random-range*` parameter (default is 100). If set to 0 turns off sampling completely (equivalent of constant rate 1)

## Pipelining
Given `statsd:*client*` is bound you can write something like this:
```lisp
(statsd:pipeline ()
  (statsd:inc "qwe")
  (statsd:inc "ewq"))
```
Pipelining implemented using 'wrapper' client that gathers metrics, concatenates them and sends directly to the wrapped client transport. Currently CL-STATSD makes no effort to split pipelined data or otherwise respect/detect MTU.

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
#### `null`
Like /dev/null
#### `capture`
Queues metrics. Useful for debugging, testing
```lisp
(let ((statsd::*client* (statsd:make-capture-client)))
  (statsd:counter "example" (random 100))
  (statsd:capture-client.recv))
"example:62|c"
```
#### `sync`
Calls transport synchronously
#### `async` 
More like 'connection-as-a-service', runs in separate thread, all metrics queued first. To prevent queue from overgrowing async client understands throttling threshold (i.e. max queue length):
```lisp
(let ((statsd:*client* (statsd:make-async-client :error-handler :throw
                                                 :throttle-threshold 5)))
  (loop for i from 0 to 999999 do
        (statsd:counter "example" (random 100))))
; Evaluation aborted on #<CL-STATSD:THROTTLE-THRESHOLD-REACHED {100414CEF3}>.
```
Throttle threshold can be set globally using `*throttle-threshold*` value or per async client (`:throttle-threshold` parameter).

## Transports
CL-STATSD comes with the following transport:
- `usocket` - sends meterics to statsd

New transports can be created by specializing
- `make-transport`
- `transport.connect`
- `transport.send`
- `transport.close`


## TODO
- [x] Async client throttling
- [ ] Travis CI integration
- [ ] Pipelines

## License
MIT
