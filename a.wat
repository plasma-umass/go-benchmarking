(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_i32 (func (result i32)))
 (type $f64_=>_none (func (param f64)))
 (type $f64_=>_f64 (func (param f64) (result f64)))
 (import "spectest" "print" (func $print (param i32)))
 (import "spectest" "print_f64" (func $print_f64 (param f64)))
 (memory $0 1 1)
 (global $sleeping (mut i32) (i32.const 0))
 (global $active_thread (mut i64) (i64.const 0))
 (global $termsPerThread (mut i64) (i64.const 0))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (export "runtime" (func $runtime))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (start $runtime)
 (func $active_thread_addr (; 2 ;) (result i32)
  (select
   (i32.const 16)
   (i32.const 24)
   (i64.eqz
    (global.get $active_thread)
   )
  )
 )
 (func $sleep (; 3 ;)
  (if
   (global.get $sleeping)
   (block
    (call $asyncify_stop_rewind)
    (global.set $sleeping
     (i32.const 0)
    )
   )
   (block
    (global.set $sleeping
     (i32.const 1)
    )
    (call $asyncify_start_unwind
     (call $active_thread_addr)
    )
   )
  )
 )
 (func $term (; 4 ;) (param $0 f64) (result f64)
  (f64.div
   (f64.convert_i64_s
    (i64.shl
     (i64.add
      (i64.shl
       (i64.sub
        (i64.const 0)
        (i64.and
         (i64.trunc_f64_s
          (local.get $0)
         )
         (i64.const 1)
        )
       )
       (i64.const 1)
      )
      (i64.const 1)
     )
     (i64.const 2)
    )
   )
   (f64.add
    (f64.add
     (local.get $0)
     (local.get $0)
    )
    (f64.const 1)
   )
  )
 )
 (func $terms (; 5 ;)
  (local $0 i32)
  (local $1 i64)
  (local $2 f64)
  (local $3 i32)
  (local $4 i32)
  (local $5 i64)
  (local $6 i64)
  (if
   (i32.eq
    (global.get $__asyncify_state)
    (i32.const 2)
   )
   (block
    (i32.store
     (global.get $__asyncify_data)
     (i32.add
      (i32.load
       (global.get $__asyncify_data)
      )
      (i32.const -36)
     )
    )
    (local.set $1
     (i64.load align=4
      (local.tee $0
       (i32.load
        (global.get $__asyncify_data)
       )
      )
     )
    )
    (local.set $4
     (i32.load offset=16
      (local.get $0)
     )
    )
    (local.set $5
     (i64.load offset=20 align=4
      (local.get $0)
     )
    )
    (local.set $6
     (i64.load offset=28 align=4
      (local.get $0)
     )
    )
    (local.set $2
     (f64.load offset=8 align=4
      (local.get $0)
     )
    )
   )
  )
  (local.set $0
   (block $__asyncify_unwind (result i32)
    (if
     (i32.eq
      (global.get $__asyncify_state)
      (i32.const 2)
     )
     (block
      (i32.store
       (global.get $__asyncify_data)
       (i32.add
        (i32.load
         (global.get $__asyncify_data)
        )
        (i32.const -4)
       )
      )
      (local.set $3
       (i32.load
        (i32.load
         (global.get $__asyncify_data)
        )
       )
      )
     )
    )
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (block
      (local.set $5
       (global.get $active_thread)
      )
      (local.set $6
       (i64.sub
        (i64.add
         (global.get $termsPerThread)
         (i64.mul
          (global.get $active_thread)
          (global.get $termsPerThread)
         )
        )
        (i64.const 1)
       )
      )
      (local.set $1
       (i64.mul
        (global.get $active_thread)
        (global.get $termsPerThread)
       )
      )
     )
    )
    (loop $loop-in
     (if
      (i32.eqz
       (global.get $__asyncify_state)
      )
      (block
       (local.set $4
        (i32.wrap_i64
         (local.get $5)
        )
       )
       (local.set $2
        (f64.add
         (local.get $2)
         (call $term
          (f64.convert_i64_s
           (local.get $1)
          )
         )
        )
       )
      )
     )
     (if
      (select
       (i32.eqz
        (local.get $3)
       )
       (i32.const 1)
       (global.get $__asyncify_state)
      )
      (block
       (call $print
        (local.get $4)
       )
       (drop
        (br_if $__asyncify_unwind
         (i32.const 0)
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 1)
         )
        )
       )
      )
     )
     (if
      (select
       (i32.eq
        (local.get $3)
        (i32.const 1)
       )
       (i32.const 1)
       (global.get $__asyncify_state)
      )
      (block
       (call $print_f64
        (local.get $2)
       )
       (drop
        (br_if $__asyncify_unwind
         (i32.const 1)
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 1)
         )
        )
       )
      )
     )
     (if
      (select
       (i32.eq
        (local.get $3)
        (i32.const 2)
       )
       (i32.const 1)
       (global.get $__asyncify_state)
      )
      (block
       (call $sleep)
       (drop
        (br_if $__asyncify_unwind
         (i32.const 2)
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 1)
         )
        )
       )
      )
     )
     (if
      (i32.eqz
       (global.get $__asyncify_state)
      )
      (br_if $loop-in
       (local.tee $4
        (i64.le_s
         (local.tee $1
          (i64.add
           (local.get $1)
           (i64.const 1)
          )
         )
         (local.get $6)
        )
       )
      )
     )
    )
    (if
     (select
      (i32.eq
       (local.get $3)
       (i32.const 3)
      )
      (i32.const 1)
      (global.get $__asyncify_state)
     )
     (block
      (call $print
       (i32.const -42)
      )
      (drop
       (br_if $__asyncify_unwind
        (i32.const 3)
        (i32.eq
         (global.get $__asyncify_state)
         (i32.const 1)
        )
       )
      )
     )
    )
    (return)
   )
  )
  (i32.store
   (i32.load
    (global.get $__asyncify_data)
   )
   (local.get $0)
  )
  (i32.store
   (global.get $__asyncify_data)
   (i32.add
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.const 4)
   )
  )
  (i64.store align=4
   (local.tee $0
    (i32.load
     (global.get $__asyncify_data)
    )
   )
   (local.get $1)
  )
  (f64.store offset=8 align=4
   (local.get $0)
   (local.get $2)
  )
  (i32.store offset=16
   (local.get $0)
   (local.get $4)
  )
  (i64.store offset=20 align=4
   (local.get $0)
   (local.get $5)
  )
  (i64.store offset=28 align=4
   (local.get $0)
   (local.get $6)
  )
  (i32.store
   (global.get $__asyncify_data)
   (i32.add
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.const 36)
   )
  )
 )
 (func $scheduler (; 6 ;)
  (if
   (i64.eqz
    (global.get $active_thread)
   )
   (global.set $active_thread
    (i64.const 1)
   )
   (global.set $active_thread
    (i64.const 0)
   )
  )
 )
 (func $runtime (; 7 ;)
  (global.set $termsPerThread
   (i64.const 5)
  )
  (global.set $active_thread
   (i64.const 0)
  )
  (i32.store
   (i32.const 16)
   (i32.const 32)
  )
  (i32.store
   (i32.const 20)
   (i32.const 1024)
  )
  (i32.store
   (i32.const 24)
   (i32.const 1032)
  )
  (i32.store
   (i32.const 28)
   (i32.const 2032)
  )
  (call $terms)
  (call $asyncify_stop_unwind)
  (call $scheduler)
  (global.set $sleeping
   (i32.const 0)
  )
  (call $terms)
  (call $asyncify_stop_unwind)
  (call $scheduler)
  (loop $loop-in
   (call $asyncify_start_rewind
    (call $active_thread_addr)
   )
   (call $terms)
   (if
    (global.get $sleeping)
    (call $asyncify_stop_unwind)
    (block
     (call $print
      (i32.const 23)
     )
     (global.set $sleeping
      (i32.const 1)
     )
    )
   )
   (call $print
    (i32.const 20)
   )
   (call $scheduler)
   (br $loop-in)
  )
 )
 (func $asyncify_start_unwind (; 8 ;) (param $0 i32)
  (global.set $__asyncify_state
   (i32.const 1)
  )
  (global.set $__asyncify_data
   (local.get $0)
  )
  (if
   (i32.gt_u
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.load offset=4
     (global.get $__asyncify_data)
    )
   )
   (unreachable)
  )
 )
 (func $asyncify_stop_unwind (; 9 ;)
  (global.set $__asyncify_state
   (i32.const 0)
  )
  (if
   (i32.gt_u
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.load offset=4
     (global.get $__asyncify_data)
    )
   )
   (unreachable)
  )
 )
 (func $asyncify_start_rewind (; 10 ;) (param $0 i32)
  (global.set $__asyncify_state
   (i32.const 2)
  )
  (global.set $__asyncify_data
   (local.get $0)
  )
  (if
   (i32.gt_u
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.load offset=4
     (global.get $__asyncify_data)
    )
   )
   (unreachable)
  )
 )
 (func $asyncify_stop_rewind (; 11 ;)
  (global.set $__asyncify_state
   (i32.const 0)
  )
  (if
   (i32.gt_u
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.load offset=4
     (global.get $__asyncify_data)
    )
   )
   (unreachable)
  )
 )
 (func $asyncify_get_state (; 12 ;) (result i32)
  (global.get $__asyncify_state)
 )
)
