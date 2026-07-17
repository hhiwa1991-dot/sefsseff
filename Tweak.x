#include <substrate.h>
#include <mach-o/dyld.h>

// پێناسەکردنی ناونیشانی یارییەکە لە ناو ڕامدا
uintptr_t g_libGTASA = 0;

// دروستکردنی فەنکشنێک بۆ گۆڕینی لۆجیکی دەستپێکی یارییەکە
void (*old_CGame_InitialiseRenderWare)();
void new_CGame_InitialiseRenderWare() {
    // ڕێگە بدە یارییەکە بە شێوەی ئاسایی گرافیکەکەی بار بکات
    old_CGame_InitialiseRenderWare();
}

// کاتێک یارییەکە دەکرێتەوە، ئەم بەشە یەکەمجار کار دەکات
__attribute__((constructor)) static void initialize() {
    // پەیداکردنی ناونیشانی یارییەکە لە بیرگەی ئایفۆنەکەدا
    g_libGTASA = (uintptr_t)_dyld_get_image_header(0);
    
    // بەستنەوەی فەنکشنەکەمان بە یارییەکەوە (Hooking)
    if (g_libGTASA) {
        MSHookFunction((void*)(g_libGTASA + 0x1001B6190), 
                       (void*)&new_CGame_InitialiseRenderWare, 
                       (void**)&old_CGame_InitialiseRenderWare);
    }
}
