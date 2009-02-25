// Keywurl version
#define KEYWURL_MAJORVERSION 1
#define KEYWURL_MINORVERSION 4
#define KEYWURL_MAINTVERSION 0
#define KEYWURL_BETA_BUILD 2

// Symbols needed for Info.plist; ugly workaround to avoid whitespace
#define MACRO_PASTE_5(a, b, c, d, e) a##b##c##d##e
#define MACRO_PASTE_5A(a, b, c, d, e) MACRO_PASTE_5(a, b, c, d, e)
#define KEYWURL_VERSION_STRING MACRO_PASTE_5A(KEYWURL_MAJORVERSION, ., KEYWURL_MINORVERSION, ., KEYWURL_MAINTVERSION)

// Bundle min and max versions
#ifdef KEYWURL_TARGET_TIGER
    #define KEYWURL_MIN_SAFARI_VERSION 523
    #define KEYWURL_MAX_SAFARI_VERSION 4525
#else
    #if KEYWURL_SAFARI_VERSION == 3
        #define KEYWURL_MIN_SAFARI_VERSION 5523
        #define KEYWURL_MAX_SAFARI_VERSION 5525
    #elif KEYWURL_SAFARI_VERSION == 4
        #define KEYWURL_MIN_SAFARI_VERSION 5528
        #define KEYWURL_MAX_SAFARI_VERSION 5528
    #else
        #error "You need to define KEYWURL_SAFARI_VERSION correctly"
    #endif
#endif
