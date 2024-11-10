#ifndef LCARD_WRAPPER_H
#define LCARD_WRAPPER_H

#include "ltrapi.h"
#include "ltr114api.h"

PTLTR114 init_photodiod();
float get_ltr_data(TLTR114* ltr);

#endif // LCARD_WRAPPER_H
