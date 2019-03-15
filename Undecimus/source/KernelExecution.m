#include "KernelExecution.h"
#include "KernelMemory.h"
#include "KernelStructureOffsets.h"
#include "KernelUtilities.h"
#include "find_port.h"
#include "kernel_call.h"
#include <common.h>
#include <iokit.h>
#include <pthread.h>
#import <patchfinder64.h>
#include "parameters.h"
#include "kc_parameters.h"
#include "kernel_memory.h"

static pthread_mutex_t kexecute_lock;

void init_kexecute()
{
    parameters_init();
    kernel_task_port = tfp0;
    current_task = ReadKernel64(task_self_addr() + koffset(KSTRUCT_OFFSET_IPC_PORT_IP_KOBJECT));
    kernel_task = ReadKernel64(GETOFFSET(kernel_task));
    kernel_call_init();
    pthread_mutex_init(&kexecute_lock, NULL);
}

void term_kexecute()
{
    kernel_call_deinit();
}

uint64_t kexecute(uint64_t addr, uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint64_t x4, uint64_t x5, uint64_t x6)
{
    uint64_t returnval = 0;
    pthread_mutex_lock(&kexecute_lock);
    returnval = kernel_call_7(addr, 7, x0, x1, x2, x3, x4, x5, x6);
    pthread_mutex_unlock(&kexecute_lock);
    return returnval;
}
