#include "difference_of_squares.h"

unsigned int sum_of_squares(unsigned int number) {
  unsigned int total = 0, i = 0;
  for (i = 1; i <= number; i++) {
    total += i * i;
  }
  return total;
}

unsigned int square_of_sum(unsigned int number) {
  unsigned int total = 0, i = 0;
  for (i = 1; i <= number; i++) {
    total += i;
  }
  return total * total;
}

unsigned int difference_of_squares(unsigned int number) {
  unsigned int total = square_of_sum(number) - sum_of_squares(number);
  return total;
}
