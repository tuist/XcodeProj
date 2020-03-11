//
//  CExts.cpp
//  XcodeGen
//
//  Created by Michael Eisel on 3/11/20.
//

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

const char *PATEscapedString(const char *string) {
    size_t length = strlen(string);
    char escapedHolder[length * 2 + 3];
    char *escaped = &(escapedHolder[1]);
    size_t curr = 0;
    bool needsQuoting = false;
    for (int i = 0; i < length; i++) {
        char c = string[i];
        if (c != '$' && c != '_' && !('.' <= c && c <= '9') && !isalnum(c)) {
            needsQuoting = true;
        }
        switch (c) {
            case '\\':
                escaped[curr++] = '\\';
                escaped[curr++] = '\\';
                
                break;
            case '"':
                escaped[curr++] = '\\';
                escaped[curr++] = '"';
                break;
            case '\t':
                escaped[curr++] = '\\';
                escaped[curr++] = 't';
                break;
            case '\n':
                escaped[curr++] = '\\';
                escaped[curr++] = 'n';
                break;
            default:
                escaped[curr++] = string[i];
        }
    }
    if (strstr(escaped, "//") || strstr(escaped, "___")) {
        needsQuoting = true;
    }
    if (needsQuoting && !(escaped[0] == '"' && escaped[curr - 1] == '"')) {
        escaped[curr++] = '"';
        escaped--;
        escaped[0] = '"';
        curr++;
    }
    escaped[curr] = '\0';
    return strdup(escaped);
}
