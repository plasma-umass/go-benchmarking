(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_i32 (func (result i32)))
 (import "spectest" "print" (func $print (param i32)))
 (memory $0 1 1)
 (global $sleeping (mut i32) (i32.const 0))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (export "runtime" (func $runtime))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (start $runtime)
 (func $main (; 1 ;)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
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
      (i32.const -16)
     )
    )
    (local.set $2
     (i32.load
      (local.tee $1
       (i32.load
        (global.get $__asyncify_data)
       )
      )
     )
    )
    (local.set $3
     (i32.load offset=4
      (local.get $1)
     )
    )
    (local.set $4
     (i32.load offset=8
      (local.get $1)
     )
    )
    (local.set $1
     (i32.load offset=12
      (local.get $1)
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
      (local.set $0
       (i32.load
        (i32.load
         (global.get $__asyncify_data)
        )
       )
      )
     )
    )
    (loop $loop-in
     (if
      (i32.or
       (local.tee $4
        (select
         (local.get $4)
         (local.get $2)
         (global.get $__asyncify_state)
        )
       )
       (i32.eq
        (global.get $__asyncify_state)
        (i32.const 2)
       )
      )
      (block
       (if
        (i32.or
         (local.tee $1
          (select
           (local.get $1)
           (local.tee $3
            (select
             (local.get $3)
             (i32.eq
              (local.get $2)
              (i32.const 1)
             )
             (global.get $__asyncify_state)
            )
           )
           (global.get $__asyncify_state)
          )
         )
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 2)
         )
        )
        (if
         (select
          (i32.eqz
           (local.get $0)
          )
          (i32.const 1)
          (global.get $__asyncify_state)
         )
         (block
          (call $sleep)
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
       )
       (if
        (i32.or
         (i32.eqz
          (local.get $1)
         )
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 2)
         )
        )
        (if
         (select
          (i32.eq
           (local.get $0)
           (i32.const 1)
          )
          (i32.const 1)
          (global.get $__asyncify_state)
         )
         (block
          (call $print
           (i32.const 3)
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
       )
      )
     )
     (if
      (i32.or
       (i32.eqz
        (local.get $4)
       )
       (i32.eq
        (global.get $__asyncify_state)
        (i32.const 2)
       )
      )
      (if
       (select
        (i32.eq
         (local.get $0)
         (i32.const 2)
        )
        (i32.const 1)
        (global.get $__asyncify_state)
       )
       (block
        (call $print
         (i32.const 1)
        )
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
     )
     (if
      (i32.eqz
       (global.get $__asyncify_state)
      )
      (br_if $loop-in
       (local.tee $3
        (i32.ne
         (local.tee $2
          (i32.add
           (local.get $2)
           (i32.const 1)
          )
         )
         (i32.const 3)
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
  (i32.store
   (local.tee $0
    (i32.load
     (global.get $__asyncify_data)
    )
   )
   (local.get $2)
  )
  (i32.store offset=4
   (local.get $0)
   (local.get $3)
  )
  (i32.store offset=8
   (local.get $0)
   (local.get $4)
  )
  (i32.store offset=12
   (local.get $0)
   (local.get $1)
  )
  (i32.store
   (global.get $__asyncify_data)
   (i32.add
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.const 16)
   )
  )
 )
 (func $sleep (; 2 ;)
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
    (i32.store
     (i32.const 16)
     (i32.const 24)
    )
    (i32.store
     (i32.const 20)
     (i32.const 1024)
    )
    (call $asyncify_start_unwind
     (i32.const 16)
    )
   )
  )
 )
 (func $runtime (; 3 ;)
  (call $main)
  (call $asyncify_stop_unwind)
  (call $print
   (i32.const 20)
  )
  (call $asyncify_start_rewind
   (i32.const 16)
  )
  (call $main)
 )
 (func $asyncify_start_unwind (; 4 ;) (param $0 i32)
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
 (func $asyncify_stop_unwind (; 5 ;)
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
 (func $asyncify_start_rewind (; 6 ;) (param $0 i32)
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
 (func $asyncify_stop_rewind (; 7 ;)
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
 (func $asyncify_get_state (; 8 ;) (result i32)
  (global.get $__asyncify_state)
 )
)
