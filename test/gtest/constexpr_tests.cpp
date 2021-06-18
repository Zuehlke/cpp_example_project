#include <gtest/gtest.h>

constexpr unsigned int Factorial(unsigned int number)
{
  return number <= 1 ? number : Factorial(number - 1) * number;
}

// NOLINTNEXTLINE(*)
TEST(factorial, Factorials_are_computed_with_constexpr)
{
  static_assert(Factorial(1) == 1);
  static_assert(Factorial(2) == 2);
  static_assert(Factorial(3) == 6);//NOLINT(cppcoreguidelines-avoid-magic-numbers, readability-magic-numbers)
  static_assert(Factorial(10) == 3628800);//NOLINT(cppcoreguidelines-avoid-magic-numbers, readability-magic-numbers)
}
