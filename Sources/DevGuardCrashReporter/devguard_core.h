#ifndef DEVGUARD_CORE_H
#define DEVGUARD_CORE_H

#include <stdint.h>
#include <stddef.h>

#if _WIN32
#define DEVGUARD_EXPORT __declspec(dllexport)
#else
#define DEVGUARD_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

DEVGUARD_EXPORT void dg_x9(const char* project_id, long long timestamp, char* output);
DEVGUARD_EXPORT int dg_v2(const char* response_body, const char* signature);
DEVGUARD_EXPORT void dg_u1(char* output);
DEVGUARD_EXPORT int dg_u2(const char* url);

#endif
