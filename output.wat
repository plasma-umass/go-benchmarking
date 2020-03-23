(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_i32 (func (result i32)))
 (memory $0 1 1)
 (global $sleeping (mut i32) (i32.const 0))
 (global $x (mut i32) (i32.const 0))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (export "runtime" (func $runtime))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (func $main (; 0 ;)
  (local $0 i32)
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
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (global.set $x
      (i32.add
       (global.get $x)
       (i32.const 1)
      )
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
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (global.set $x
      (i32.add
       (global.get $x)
       (i32.const 1)
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
 )
 (func $sleep (; 1 ;)
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
 (func $runtime (; 2 ;) (result i32)
  (call $main)
  (call $asyncify_stop_unwind)
  (global.set $x
   (i32.add
    (global.get $x)
    (i32.const 1)
   )
  )
  (call $asyncify_start_rewind
   (i32.const 16)
  )
  (call $main)
  (global.get $x)
 )
 (func $asyncify_start_unwind (; 3 ;) (param $0 i32)
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
 (func $asyncify_stop_unwind (; 4 ;)
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
 (func $asyncify_start_rewind (; 5 ;) (param $0 i32)
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
 (func $asyncify_stop_rewind (; 6 ;)
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
 (func $asyncify_get_state (; 7 ;) (result i32)
  (global.get $__asyncify_state)
 )
)
