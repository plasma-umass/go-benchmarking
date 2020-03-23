;; input.wat
(module
    (memory 1 1)
    (import "spectest" "print" (func $print (param i32)))
    (import "asyncify" "start_unwind" (func $asyncify_start_unwind (param i32)))
    (import "asyncify" "stop_unwind" (func $asyncify_stop_unwind))
    (import "asyncify" "start_rewind" (func $asyncify_start_rewind (param i32)))
    (import "asyncify" "stop_rewind" (func $asyncify_stop_rewind))
    (global $sleeping (mut i32) (i32.const 0))

    (global $x (mut i32) (i32.const 0))

    (export "runtime" (func $runtime))

    (start $runtime)


    (global $active_thread (mut i32) (i32.const 1)) ;; 1 or 2


    ;; (func $yield
    ;;     (i32.store (i32.const 16) (i32.const 24))
    ;;     (i32.store (i32.const 20) (i32.const 1024))
    ;;     (call $asyncify_start_unwind (i32.const 16))
    ;; )
  
    (func $main (local i32)
        (local.set 0 (i32.const 0))
        (loop

            ;; (call $print (i32.const 1))
            ;; (call $sleep)

            (if (i32.eq (local.get 0) (i32.const 0))
                (then
                    (call $print (i32.const 1))
                )
                (else
                    (if (i32.eq (local.get 0) (i32.const 1))
                        (then
                            (call $sleep)
                        )
                        (else
                            ;; local.0 is 2
                            (call $print (i32.const 3))
                        )
                    )
                )
            )

            (local.set 0 (i32.add (i32.const 1) (local.get 0)))
            (if (i32.eq (local.get 0) (i32.const 3))
                (then
                    (return)
                )
                (else
                    (br 1)
                )
            )
        )

    ;;     (call $print (i32.const 1))
    ;; ;; (global.set $x (i32.add (i32.const 1) (global.get $x)))
    ;;     (call $sleep)
    ;;     (call $print (i32.const 3))
    ;; (global.set $x (i32.add (i32.const 1) (global.get $x)))

        ;; (if (i32.eq (global.get $active_thread) (i32.const 1))
        ;;     (then
        ;;         (call $print1)
        ;;     )
        ;;     (else
        ;;         (call $print2)
        ;;     )
        ;; )
    )
    (func $sleep
        (if (i32.eqz (global.get $sleeping))
            (block
                ;; Start to sleep.
                (global.set $sleeping (i32.const 1))
                (i32.store (i32.const 16) (i32.const 24))
                (i32.store (i32.const 20) (i32.const 1024))
                (call $asyncify_start_unwind (i32.const 16))
            )
            (block
                ;; Resume after sleep.
                (call $asyncify_stop_rewind)
                (global.set $sleeping (i32.const 0))
            )
        )
    )

    ;; (func $print1 (local i32)
    ;;     (loop
    ;;         (call $print (i32.const 1))
    ;;         (call $yield)
    ;;         (return)
    ;;         (call $asyncify_stop_rewind)
    ;;         (call $print (i32.const 978))
    ;;         (br 0)
    ;;     )
    ;; )

    ;; (func $print2 (local i32)
    ;;     (loop
    ;;         (call $print (i32.const 2))
    ;;         (call $yield)
    ;;         (return)
    ;;         (call $asyncify_stop_rewind)
    ;;         (br 0)
    ;;     )
    ;; )

    (func $runtime
        ;; Call main the first time, let the stack unwind.
        (call $main)

        (call $asyncify_stop_unwind)
        ;; We could do anything we want around here while
        ;; the code is paused!
        (call $print (i32.const 20))
        ;; Set the rewind in motion.
        (call $asyncify_start_rewind (i32.const 16))
        (call $main)

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