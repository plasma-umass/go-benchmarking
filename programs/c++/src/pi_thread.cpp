#include <emscripten/emscripten.h>
#include <stdio.h>
#include <iostream>

#include "../../../../emcc_control/include/continuations.h"

k_id _after_kapture = 0;

k_id _to_capture = 0;
k_id _to_capture_arg1 = 0;
k_id _to_capture_arg2 = 0;
k_id _to_capture_arg3 = 0;

void _save_k_restore(k_id k, uint64_t x) {
    restore(_after_kapture, k);
}

// (global $_after_kapture (mut i64) (i64.const 0)) ;; continuation_id
//     (global $_to_capture (mut i32) (i32.const 0)) ;; kthread_func_t
//     (global $_to_capture_arg1 (mut i64) (i64.const 0)) ;; arbitrary argument
//     (global $_to_capture_arg2 (mut i64) (i64.const 0)) ;; arbitrary argument
//     (global $_to_capture_arg3 (mut i64) (i64.const 0)) ;; arbitrary argument


//     (func $_save_k_restore (param i64 i64)
//         (restore (global.get $_after_kapture) (local.get 0))
//     )

//     (func $_kapture_handler (param i64 i64)
//         (global.set $_after_kapture (local.get 0))

//         global.get $_to_capture_arg1
//         global.get $_to_capture_arg2
//         global.get $_to_capture_arg3
//         global.get $_to_capture ;; we HAVE to put these onto the stack BEFORE doing control!!!

//         (control $_save_k_restore (i64.const 1337))
//         drop
//         call_indirect (type $proc)
//     )

//     (func $kapture (param i32 i64 i64 i64) (result i64)
//         (global.set $_to_capture (local.get 0))
//         (global.set $_to_capture_arg1 (local.get 1))
//         (global.set $_to_capture_arg2 (local.get 2))
//         (global.set $_to_capture_arg3 (local.get 3))
//         (control $_kapture_handler (i64.const 1337))
//     )



int main() {
    std::cout << "hi" << std::endl;
}

DONT_DELETE_MY_HANDLER(_save_k_restore);
