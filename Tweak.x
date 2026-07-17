#include <substrate.h>
#include <mach-o/dyld.h>
#include <iostream>

// پێناسەکردنی ناونیشانی یارییەکە لە ناو ڕامدا
uintptr_t g_libGTASA = 0;

// دروستکردنی فەنکشنێک بۆ گۆڕینی لۆجیکی دەستپێکی یارییەکە
void (*old_CGame_InitialiseRenderWare)();
void new_CGame_InitialiseRenderWare() {
    // ڕێگە بدە یارییەکە بە شێوەی ئاسایی گرافیکەکەی بار بکات
    old_CGame_InitialiseRenderWare();
    
    // لێرەدا دەتوانین یەکەم پەیام بنووسین بۆ دڵنیابوونەوە لە کارکردنی مۆدەکە
    std::cout << "SAMP iOS: Mod loaded successfully!" << std::endl;
}

// کاتێک یارییەکە دەکرێتەوە، ئەم بەشە یەکەمجار کار دەکات
__attribute__((constructor)) static void initialize() {
    // پەیداکردنی ناونیشانی یارییەکە لە بیرگەی ئایفۆنەکەدا
    g_libGTASA = (uintptr_t)_dyld_get_image_header(0);
    
    // بەستنەوەی فەنکشنەکەمان بە یارییەکەوە (Hooking)
    // تێبینی: ناونیشانی لۆکاڵی فەنکشنی ڕێندەر لەم وەشانی یارییەدا دەبەستینەوە
    MSHookFunction((void*)(g_libGTASA + 0x1001B6190), 
                   (void*)&new_CGame_InitialiseRenderWare, 
                   (void**)&old_CGame_InitialiseRenderWare);
}