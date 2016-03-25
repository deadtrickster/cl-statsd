## StatsD client in Common Lisp

```lisp
(let ((statsd:*client* (statsd:make-sync-client)))
  (loop for i from 0 to 99 do
    (statsd:counter "example" (random 100))
    (sleep 1)))
```

![Result](http://i.imgur.com/OnfuYng.png)

## TODO

- [ ] Tests
- [x] Auto-reconnects for async client
- [ ] Pipelines

## License
MIT
