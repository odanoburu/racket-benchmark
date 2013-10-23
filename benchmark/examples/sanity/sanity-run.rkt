#lang racket

(require benchmark "linux-time.rkt" "sanity-common.rkt")

(define (sleep-internal-bench n)
  (bench-one (format "sleep ~a" n)
             (sleep n) (mk-bench-opts #:itrs-per-trial 1)))

(define times (list .0001 .001 .01 .1 .5 1 1.3 1.67 2))

(define benches
  (list
   (bench-group "racket" (map (lambda (t) (sleep-internal-bench t)) times))
   (bench-group
    "linux"
    (map (lambda (t) (sleep-external-bench t)) times))))

(define results
  (run-benchmarks benches
                  (mk-bench-opts
                   #:num-trials 30
                   #:gc-between #f)))

(record-results results results-file)