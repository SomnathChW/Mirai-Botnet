#define _GNU_SOURCE

#ifdef DEBUG
#include <stdio.h>
#endif
#include <unistd.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <linux/ip.h>
#include <linux/udp.h>

#include "includes.h"
#include "random_ip_generator.h"
#include "rand.h"
#include "random_ip_generator.h"
#include <stdint.h>

// Add your random number generator or include "rand.h"
extern uint32_t rand_next(void);

#if defined(IP_MODE_INTERNAL)

ipv4_t get_random_ip(void) {
    uint8_t which, o1, o2, o3, o4;
    uint32_t ip;

    while (1) {
        which = rand_next() % 3;
        o2 = rand_next() & 0xff;
        o3 = rand_next() & 0xff;
        o4 = rand_next() & 0xff;
        if (which == 0) {
            o1 = 10;   // 10.0.0.0/8
            return INET_ADDR(o1, o2, o3, o4);
        } else if (which == 1) {
            o1 = 172;  // 172.16.0.0/12
            o2 = 16 + (rand_next() % 16);
            return INET_ADDR(o1, o2, o3, o4);
        } else {
            o1 = 192;  // 192.168.0.0/16
            o2 = 168;
            return INET_ADDR(o1, o2, o3, o4);
        }
    }
}

#elif defined(IP_MODE_CUSTOM)

// ---- Custom IP Range Mode ----
// Include generated custom IP ranges from file
typedef struct {
    uint32_t start;
    uint32_t end;
} ip_range_t;

// Include the generated custom IP ranges
#include "custom_ip_ranges.h"

ipv4_t get_random_ip(void) {
    // Pick a random range
    size_t idx = rand_next() % CUSTOM_RANGE_COUNT;
    uint32_t start = custom_ip_ranges[idx].start;
    uint32_t end = custom_ip_ranges[idx].end;
    uint32_t ip = start + (rand_next() % (end - start + 1));
    return ip;
}

#else

// ---- Default (public IP only, original code) ----
ipv4_t get_random_ip(void)
{
    uint32_t tmp;
    uint8_t o1, o2, o3, o4;

    do {
        tmp = rand_next();
        o1 = tmp & 0xff;
        o2 = (tmp >> 8) & 0xff;
        o3 = (tmp >> 16) & 0xff;
        o4 = (tmp >> 24) & 0xff;
    } while (
        o1 == 127 ||                             // Loopback
        (o1 == 0) ||                             // Invalid address space
        (o1 == 3) ||                             // General Electric
        (o1 == 15 || o1 == 16) ||                // HP
        (o1 == 56) ||                            // US Postal
        (o1 == 10) ||                            // Internal network
        (o1 == 192 && o2 == 168) ||              // Internal network
        (o1 == 172 && o2 >= 16 && o2 < 32) ||    // Internal network
        (o1 == 100 && o2 >= 64 && o2 < 127) ||   // IANA NAT reserved
        (o1 == 169 && o2 == 254) ||              // IANA NAT reserved
        (o1 == 198 && o2 >= 18 && o2 < 20) ||    // IANA Special use
        (o1 >= 224) ||                           // Multicast
        (o1 == 6 || o1 == 7 || o1 == 11 || o1 == 21 || o1 == 22 || o1 == 26 || o1 == 28 || o1 == 29 || o1 == 30 || o1 == 33 || o1 == 55 || o1 == 214 || o1 == 215) // DoD
    );
    return INET_ADDR(o1, o2, o3, o4);
}

#endif