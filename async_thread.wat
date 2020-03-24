;; input.wat
(module
    (import "spectest" "print" (func $print (param i32)))
    (import "spectest" "print_f64" (func $print_f64 (param f64)))
    (import "asyncify" "start_unwind" (func $asyncify_start_unwind (param i32)))
    (import "asyncify" "stop_unwind" (func $asyncify_stop_unwind))
    (import "asyncify" "start_rewind" (func $asyncify_start_rewind (param i32)))
    (import "asyncify" "stop_rewind" (func $asyncify_stop_rewind))
    (memory 1 1)

    (global $sleeping (mut i32) (i32.const 0))

    (global $x (mut i32) (i32.const 0))

    (export "runtime" (func $runtime))

    (start $runtime)


    (global $active_thread (mut i64) (i64.const 0)) ;; 1 or 2

    (global $numTerms i64 (i64.const 10)) ;; 100000000
    (global $numThreads i64 (i64.const 2)) ;; 100000
    (global $termsPerThread (mut i64) (i64.const 0)) ;; will be computed later


    (global $queue_head_idx (mut i32) (i32.const 0)) ;; where the next item will be enqueued
    (global $queue_tail_idx (mut i32) (i32.const 0)) ;; where the next item will be dequeued
    (global $queue_len (mut i32) (i32.const 0))
    (global $queue_capacity_log2 (mut i32) (i32.const 2))
    (global $queue_base_addr (mut i32) (i32.const 0))
    (global $queue_after_addr (mut i32) (i32.const 0))


    (func $pow2 (param $x i32) (result i32)
        (i32.shl (i32.const 1) (local.get $x))
    )

    (func $containing_log_2_i32 (param $param i32) (result i32) (local $p i32)
        ;; (local.set $param (i32.const 1023))

        (if (result i32) (i32.gt_u (local.get $param) (i32.shl (i32.const 1) (i32.const 31)))
            (then
                (unreachable)
                (i32.const 0)
            )
            (else
                (local.set $p (i32.sub (i32.const 32) (i32.clz (local.get $param))))
                (if (result i32) (i32.eq (local.get $param) (i32.shl (i32.const 1) (i32.sub (local.get $p) (i32.const 1))))
                    (then
                        (i32.sub (local.get $p) (i32.const 1))
                    )
                    (else
                        (local.get $p)
                    )
                )
            )
        )
    )

    (func $queue_init (param $start_addr i32) (param $capacity_log2 i32)
        (global.set $queue_len (i32.const 0))
        (global.set $queue_head_idx (i32.const 0))
        (global.set $queue_tail_idx (i32.const 0))

        (global.set $queue_base_addr (local.get $start_addr))
        (global.set $queue_capacity_log2 (local.get $capacity_log2))
        (global.set $queue_after_addr 
            (i32.add 
                (local.get $start_addr)
                (i32.shl 
                    (call $pow2 (local.get $capacity_log2)) 
                    (i32.const 3)
                )
            )
        )
    )

    (func $queue_addr (param $idx i32) (result i32)
        ;; base + 8*idx
        (i32.add 
            (global.get $queue_base_addr) 
            (i32.shl 
                (local.get $idx) 
                (i32.const 3)))
    )

    (func $enqueue (param i64)
        ;; test if queue_len = 2^queue_capacity_log2
        (if (i32.eq (global.get $queue_len) (i32.shl (i32.const 1) (global.get $queue_capacity_log2)))
            (then
                unreachable ;; is so, abort
            )
            (else
                ;; store at address base + 8*head_idx
                (i64.store (call $queue_addr (global.get $queue_head_idx)) (local.get 0))

                ;; queue_head_idx = (queue_head_idx + 1) mod 2^queue_capacity_log2 
                (global.set $queue_head_idx 
                    (i32.and 
                        (i32.add 
                            (global.get $queue_head_idx) 
                            (i32.const 1)) 
                        (i32.sub (i32.shl (i32.const 1) (global.get $queue_capacity_log2)) (i32.const 1))))

                ;; increment queue length
                (global.set $queue_len (i32.add (global.get $queue_len) (i32.const 1)))
            )
        )
        
    )

    (func $dequeue (result i64) (local i64)
        (if (result i64) (global.get $queue_len) 
            (then
                ;; load from address base + 8*tail_idx
                (local.set 0 (i64.load (call $queue_addr (global.get $queue_tail_idx))))

                ;; queue_tail_idx = (queue_tail_idx + 1) mod 2^queue_capacity_log2 
                (global.set $queue_tail_idx 
                    (i32.and 
                        (i32.add 
                            (global.get $queue_tail_idx) 
                            (i32.const 1)) 
                        (i32.sub (i32.shl (i32.const 1) (global.get $queue_capacity_log2)) (i32.const 1))))
                
                ;; decrement queue length
                (global.set $queue_len (i32.sub (global.get $queue_len) (i32.const 1)))

                (local.get 0)
            )
            (else
                (unreachable) ;; actuall it is reachable: but don't do it
                (i64.const 0)
            )
        )
    )

    (func $thread_id_stack_addr_start (param $k i64) (result i32)
        (i32.add 
            (global.get $queue_after_addr) 
            (i32.shl 
                (i32.wrap_i64 (local.get $k)) 
                (i32.const 10)
            )
        )
    )

    (func $thread_id_stack_addr_end (param $k i64) (result i32)
        (i32.sub
            (i32.add 
                (global.get $queue_after_addr) 
                (i32.shl 
                    (i32.add 
                        (i32.wrap_i64 (local.get $k)) 
                        (i32.const 1)
                    )
                    (i32.const 10)
                )
            )
            (i32.const 8)
        )
    )

    (func $thread_id_result_addr (param $k i64) (result i32)
        (i32.shl (i32.wrap_i64 (local.get $k)) (i32.const 3))
    )

    (func $active_thread_addr (result i32)
        (if (i64.eq (global.get $active_thread) (i64.const 0))
            (then
                (return (i32.const 16))
            )
            (else
                (return (i32.const 24))
            )
        )
        (i32.const 0)
    )

  
    (func $main
        ;; (call $print (global.get $active_thread))
        ;; (call $print_evens)
        (call $terms)
    )
    (func $sleep
        (if (i32.eqz (global.get $sleeping))
            (block
                ;; Start to sleep.
                (global.set $sleeping (i32.const 1))
                (call $asyncify_start_unwind (call $active_thread_addr))
            )
            (block
                ;; Resume after sleep.
                (call $asyncify_stop_rewind)
                (global.set $sleeping (i32.const 0))
            )
        )
    )

    (func $print_stuff
        (call $print_evens)
        ;; (if (i32.eq (global.get $active_thread) (i32.const 1))
        ;;     (then
        ;;         (call $print_evens)
        ;;     )
        ;;     (else
        ;;         (call $print_evens)
        ;;     )
        ;; )
    )



    (func $term (param f64) (result f64) (local i64)
        (f64.div
            (f64.convert_i64_s
                (i64.shl
                    (local.tee 1
                        (i64.add
                            (i64.shl
                                (i64.sub
                                    (i64.const 0)
                                    (i64.and
                                        (i64.trunc_f64_s
                                            (local.get 0))
                                        (i64.const 1)))
                                (i64.const 1))
                            (i64.const 1)))
                    (i64.const 2)))
            (f64.add
                (f64.add
                    (local.get 0)
                    (local.get 0))
                (f64.const 1)))
    )


    (func $terms (local $from i64) (local $to i64) (local $f f64) (local $k i64) (local $tid i64)
        (local.set $tid (global.get $active_thread))

        (local.set $from (i64.mul (global.get $active_thread) (global.get $termsPerThread)))
        (local.set $to 
            (i64.sub 
                (i64.add 
                    (global.get $termsPerThread) 
                    (i64.mul 
                        (global.get $active_thread) 
                        (global.get $termsPerThread))) 
                (i64.const 1)))
        

        (local.set $f (f64.const 0))
        (local.set $k (local.get $from))

        (block
            (loop
                ;; (call $print_ascii (i32.wrap_i64 (local.get $char)))

                (local.set $f (f64.add (local.get $f) (call $term (f64.convert_i64_s (local.get $k)))))
                ;; (call $term (f64.convert_i64_s (local.get $k)))
                ;; (local.set $f (f64.add (local.get $f) (f64.const 4)))

                ;; (call $print_ascii (i32.wrap_i64 (local.get $thread_addr)))
    
                ;; (call $print_d32 (local.get $i))
                (call $print (i32.wrap_i64 (local.get $tid)))
                (call $print_f64 (local.get $f))
                (call $sleep)

                (local.set $k (i64.add (local.get $k) (i64.const 1)))
                (br_if 1 (i64.gt_s (local.get $k) (local.get $to)))
                (br 0)
            )
        )
        (call $print (i32.const -42))

        ;; (f64.store (i32.wrap_i64 (local.get $thread_addr)) (local.get $f))

        ;; call $kthread_exit
    )

    (func $print_evens (local i32)
        (local.set 0 (i32.wrap_i64 (global.get $active_thread)))



        (loop

            ;; (call $print (i32.add (local.get 0) (global.get $active_thread)))
            ;; (call $print (global.get $active_thread))
            (call $print (i32.wrap_i64 (global.get $active_thread)))
            (call $print (local.get 0))
            (call $sleep)

            (local.set 0 (i32.add (i32.const 2) (local.get 0)))
            (br 0)
        )
    )

    ;; (func $print_odds (local i32)  
    ;;     (local.set 0 (i32.const 1))
    ;;     (loop

    ;;         ;; (call $print (i32.add (local.get 0) (global.get $active_thread)))
    ;;         ;; (call $print (global.get $active_thread))
    ;;         (call $print (global.get $active_thread))
    ;;         (call $print (local.get 0))
    ;;         (call $sleep)

    ;;         (local.set 0 (i32.add (i32.const 2) (local.get 0)))
    ;;         (br 0)
    ;;     )
    ;; )



    (func $scheduler
        (if (i64.eq (global.get $active_thread) (i64.const 0))
            (then
                (global.set $active_thread (i64.const 1))
            )
            (else
                (global.set $active_thread (i64.const 0))
            )
        )
    )


    (func $runtime
        ;; Call main the first time, let the stack unwind.
        ;; (loop

        (global.set $termsPerThread (i64.div_s (global.get $numTerms) (global.get $numThreads)))

        (global.set $active_thread (i64.const 0))


        (i32.store (i32.const 16) (i32.const 32))
        (i32.store (i32.const 20) (i32.const 1024))

        (i32.store (i32.const 24) (i32.const 1032))
        (i32.store (i32.const 28) (i32.const 2032))

        ;; (global.set $active_thread (i32.const 1))

        (call $main) ;; this is first
        (call $asyncify_stop_unwind)
        ;; (call $print (i32.const 1337))
        ;; (call $print (i32.const 40))

        (call $scheduler)
        ;; (call $print (global.get $active_thread))
        (global.set $sleeping (i32.const 0))
        (call $main)
        (call $asyncify_stop_unwind)
        ;; (call $print (i32.const 41))
        (call $scheduler)

        (loop
            ;; (call $print (i32.const 1234))
            (call $asyncify_start_rewind (call $active_thread_addr))
            (call $main) ;; this is first
            (if (global.get $sleeping)
                (then
                    (call $asyncify_stop_unwind)
                )
                (else
                    (call $print (i32.const 23))
                    (global.set $sleeping (i32.const 1))
                )
            )
            (call $print (i32.const 20))
            (call $scheduler)
            (br 0)
        )



            ;; (call $main)
            ;; (br 0)
        ;; )

        ;; (call $asyncify_stop_unwind)
        ;; (call $print (i32.const 40))
        ;; (call $asyncify_start_rewind (i32.const 16))
        ;; (call $main)

        ;; ;; Call main the first time, let the stack unwind.
        ;; ;; (call $main)
        ;; (loop
        ;;     (call $main)
        ;;     (call $asyncify_stop_unwind)

        ;;     (call $print (i32.const 1234))

        ;;     (if (i32.eq (global.get $active_thread) (i32.const 1))
        ;;         (then
        ;;             (global.set $active_thread (i32.const 2))
        ;;         )
        ;;         (else
        ;;             (global.set $active_thread (i32.const 1))
        ;;         )
        ;;     )

        ;;     (call $asyncify_start_rewind (i32.const 16))

        ;;     (br 0)
        ;; )

        ;; (call $print (i32.const 1234))

        ;; (call $asyncify_start_rewind (i32.const 16))
        ;; (call $main)
        

        ;; ;; (global.get $x)
        ;; ;; (call $print (global.get $x))
    )
)