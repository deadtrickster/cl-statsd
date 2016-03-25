## StatsD client in Common Lisp

Only udp transport. No pipelining

```lisp
(let ((statsd:*client* (statsd:make-sync-client)))
  (loop for i from 0 to 99 do
    (statsd:counter "example" (random 100))
    (sleep 1)))
```

![Result](http://i.imgur.com/OnfuYng.png)

## License
MIT
