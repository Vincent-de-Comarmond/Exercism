#include "leap.h"
#include <stdbool.h>

bool leap_year(int year) {
  bool is_leap = false;
  if (year % 4 == 0) {
    is_leap = true;
    if (year % 100 == 0) {
      is_leap = false;
      if (year % 400 == 0) {
        is_leap = true;
      }
    }
  }
  return is_leap;
}
