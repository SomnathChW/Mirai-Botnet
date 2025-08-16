#ifndef IP_RANGES_H
#define IP_RANGES_H

#include "includes.h"

#ifdef IP_MODE_CUSTOM

struct ip_range custom_ip_ranges[] = {
    {0xc0a8010a, 0xc0a80114},
    {0x0a000004, 0x0a00000f},
    {0xac100001, 0xac100064},
    {0x08080808, 0x08080808},
    {0x01010101, 0x0101010a},
};

int custom_ip_ranges_len = sizeof(custom_ip_ranges) / sizeof(struct ip_range);

#endif

#endif
