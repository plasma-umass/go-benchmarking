(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $i64_=>_i32 (func (param i64) (result i32)))
 (type $i64_=>_none (func (param i64)))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $none_=>_i64 (func (result i64)))
 (type $none_=>_f64 (func (result f64)))
 (type $f64_=>_f64 (func (param f64) (result f64)))
 (memory $0 10000)
 (global $sleeping (mut i32) (i32.const 0))
 (global $active_thread (mut i64) (i64.const 0))
 (global $termsPerThread (mut i64) (i64.const 0))
 (global $queue_head_idx (mut i32) (i32.const 0))
 (global $queue_tail_idx (mut i32) (i32.const 0))
 (global $queue_len (mut i32) (i32.const 0))
 (global $queue_capacity_log2 (mut i32) (i32.const 2))
 (global $queue_base_addr (mut i32) (i32.const 0))
 (global $queue_after_addr (mut i32) (i32.const 0))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (export "runtime" (func $runtime))
 (export "runtime_print" (func $runtime_print))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (func $queue_init (; 0 ;) (param $0 i32)
  (global.set $queue_len
   (i32.const 0)
  )
  (global.set $queue_head_idx
   (i32.const 0)
  )
  (global.set $queue_tail_idx
   (i32.const 0)
  )
  (global.set $queue_base_addr
   (i32.const 128)
  )
  (global.set $queue_capacity_log2
   (local.get $0)
  )
  (global.set $queue_after_addr
   (i32.add
    (i32.shl
     (i32.shl
      (i32.const 1)
      (local.get $0)
     )
     (i32.const 3)
    )
    (i32.const 128)
   )
  )
 )
 (func $queue_addr (; 1 ;) (param $0 i32) (result i32)
  (i32.add
   (global.get $queue_base_addr)
   (i32.shl
    (local.get $0)
    (i32.const 3)
   )
  )
 )
 (func $enqueue (; 2 ;) (param $0 i64)
  (if
   (i32.ne
    (global.get $queue_len)
    (i32.shl
     (i32.const 1)
     (global.get $queue_capacity_log2)
    )
   )
   (block
    (i64.store
     (call $queue_addr
      (global.get $queue_head_idx)
     )
     (local.get $0)
    )
    (global.set $queue_head_idx
     (i32.and
      (i32.add
       (global.get $queue_head_idx)
       (i32.const 1)
      )
      (i32.sub
       (i32.shl
        (i32.const 1)
        (global.get $queue_capacity_log2)
       )
       (i32.const 1)
      )
     )
    )
    (global.set $queue_len
     (i32.add
      (global.get $queue_len)
      (i32.const 1)
     )
    )
   )
  )
 )
 (func $dequeue (; 3 ;) (result i64)
  (local $0 i64)
  (if
   (global.get $queue_len)
   (block
    (local.set $0
     (i64.load
      (call $queue_addr
       (global.get $queue_tail_idx)
      )
     )
    )
    (global.set $queue_tail_idx
     (i32.and
      (i32.add
       (global.get $queue_tail_idx)
       (i32.const 1)
      )
      (i32.sub
       (i32.shl
        (i32.const 1)
        (global.get $queue_capacity_log2)
       )
       (i32.const 1)
      )
     )
    )
    (global.set $queue_len
     (i32.sub
      (global.get $queue_len)
      (i32.const 1)
     )
    )
   )
   (unreachable)
  )
  (local.get $0)
 )
 (func $thread_id_stack_info_addr (; 4 ;) (param $0 i64) (result i32)
  (i32.add
   (global.get $queue_after_addr)
   (i32.shl
    (i32.wrap_i64
     (local.get $0)
    )
    (i32.const 10)
   )
  )
 )
 (func $thread_id_result_addr (; 5 ;) (param $0 i64) (result i32)
  (i32.shl
   (i32.wrap_i64
    (local.get $0)
   )
   (i32.const 3)
  )
 )
 (func $sleep (; 6 ;)
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
     (call $thread_id_stack_info_addr
      (global.get $active_thread)
     )
    )
   )
  )
 )
 (func $term (; 7 ;) (param $0 f64) (result f64)
  (local $1 i32)
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
      (i32.const -8)
     )
    )
    (local.set $0
     (f64.load align=4
      (i32.load
       (global.get $__asyncify_data)
      )
     )
    )
   )
  )
  (local.set $1
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
      (local.set $1
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
     (local.set $0
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
    )
    (if
     (select
      (i32.eqz
       (local.get $1)
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
     (return
      (local.get $0)
     )
    )
    (unreachable)
   )
  )
  (i32.store
   (i32.load
    (global.get $__asyncify_data)
   )
   (local.get $1)
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
  (f64.store align=4
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
    (i32.const 8)
   )
  )
  (f64.const 0)
 )
 (func $terms (; 8 ;)
  (local $0 i32)
  (local $1 f64)
  (local $2 i64)
  (local $3 i32)
  (local $4 f64)
  (local $5 i64)
  (local $6 i64)
  (local $7 f64)
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
      (i32.const -40)
     )
    )
    (local.set $2
     (i64.load align=4
      (local.tee $3
       (i32.load
        (global.get $__asyncify_data)
       )
      )
     )
    )
    (local.set $4
     (f64.load offset=16 align=4
      (local.get $3)
     )
    )
    (local.set $6
     (i64.load offset=24 align=4
      (local.get $3)
     )
    )
    (local.set $5
     (i64.load offset=32 align=4
      (local.get $3)
     )
    )
    (local.set $1
     (f64.load offset=8 align=4
      (local.get $3)
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
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (block
      (local.set $6
       (global.get $active_thread)
      )
      (local.set $2
       (i64.mul
        (global.get $active_thread)
        (global.get $termsPerThread)
       )
      )
      (local.set $5
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
     )
    )
    (loop $loop-in
     (local.set $1
      (select
       (local.get $1)
       (f64.convert_i64_s
        (local.get $2)
       )
       (global.get $__asyncify_state)
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
       (local.set $7
        (call $term
         (local.get $1)
        )
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
       (local.set $1
        (local.get $7)
       )
      )
     )
     (if
      (i32.eqz
       (global.get $__asyncify_state)
      )
      (block
       (local.set $4
        (f64.add
         (local.get $4)
         (local.get $1)
        )
       )
       (br_if $loop-in
        (i64.le_s
         (local.tee $2
          (i64.add
           (local.get $2)
           (i64.const 1)
          )
         )
         (local.get $5)
        )
       )
      )
     )
    )
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (f64.store
      (call $thread_id_result_addr
       (local.get $6)
      )
      (local.get $4)
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
   (local.get $2)
  )
  (f64.store offset=8 align=4
   (local.get $0)
   (local.get $1)
  )
  (f64.store offset=16 align=4
   (local.get $0)
   (local.get $4)
  )
  (i64.store offset=24 align=4
   (local.get $0)
   (local.get $6)
  )
  (i64.store offset=32 align=4
   (local.get $0)
   (local.get $5)
  )
  (i32.store
   (global.get $__asyncify_data)
   (i32.add
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.const 40)
   )
  )
 )
 (func $runtime (; 9 ;) (result f64)
  (local $0 i64)
  (local $1 f64)
  (local $2 i32)
  (global.set $termsPerThread
   (i64.const 64)
  )
  (call $queue_init
   (i32.const 4)
  )
  (loop $loop-in
   (i32.store
    (local.tee $2
     (call $thread_id_stack_info_addr
      (local.get $0)
     )
    )
    (i32.add
     (i32.add
      (global.get $queue_after_addr)
      (i32.shl
       (i32.wrap_i64
        (local.get $0)
       )
       (i32.const 10)
      )
     )
     (i32.const 8)
    )
   )
   (i32.store offset=4
    (local.get $2)
    (i32.add
     (i32.add
      (global.get $queue_after_addr)
      (i32.shl
       (i32.wrap_i64
        (local.get $0)
       )
       (i32.const 10)
      )
     )
     (i32.const 1016)
    )
   )
   (br_if $loop-in
    (i64.lt_s
     (local.tee $0
      (i64.add
       (local.get $0)
       (i64.const 1)
      )
     )
     (i64.const 16)
    )
   )
  )
  (local.set $0
   (i64.const 0)
  )
  (loop $loop-in3
   (global.set $active_thread
    (local.get $0)
   )
   (global.set $sleeping
    (i32.const 0)
   )
   (call $terms)
   (call $asyncify_stop_unwind)
   (call $enqueue
    (local.get $0)
   )
   (br_if $loop-in3
    (i64.lt_s
     (local.tee $0
      (i64.add
       (local.get $0)
       (i64.const 1)
      )
     )
     (i64.const 16)
    )
   )
  )
  (loop $loop-in5
   (call $asyncify_start_rewind
    (call $thread_id_stack_info_addr
     (global.get $active_thread)
    )
   )
   (call $terms)
   (if
    (global.get $sleeping)
    (call $asyncify_stop_unwind)
   )
   (if
    (global.get $queue_len)
    (block
     (if
      (global.get $sleeping)
      (call $enqueue
       (global.get $active_thread)
      )
     )
     (global.set $active_thread
      (call $dequeue)
     )
     (global.set $sleeping
      (i32.const 1)
     )
     (br $loop-in5)
    )
   )
  )
  (local.set $0
   (i64.const 0)
  )
  (loop $loop-in7
   (local.set $1
    (f64.add
     (local.get $1)
     (f64.load
      (call $thread_id_result_addr
       (local.get $0)
      )
     )
    )
   )
   (br_if $loop-in7
    (i64.lt_s
     (local.tee $0
      (i64.add
       (local.get $0)
       (i64.const 1)
      )
     )
     (i64.const 16)
    )
   )
  )
  (local.get $1)
 )
 (func $runtime_print (; 10 ;)
  (nop)
 )
 (func $asyncify_start_unwind (; 11 ;) (param $0 i32)
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
 (func $asyncify_stop_unwind (; 12 ;)
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
 (func $asyncify_start_rewind (; 13 ;) (param $0 i32)
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
 (func $asyncify_stop_rewind (; 14 ;)
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
 (func $asyncify_get_state (; 15 ;) (result i32)
  (global.get $__asyncify_state)
 )
)
