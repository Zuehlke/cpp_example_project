#include <gtest/gtest.h>

unsigned int Factorial(unsigned int number) { return number <= 1 ? number : Factorial(number - 1) * number; }

// NOLINTNEXTLINE(*)
TEST(factorial, Factorials_are_computed)
{
    ASSERT_EQ(Factorial(1), 1);
    ASSERT_EQ(Factorial(2), 2);
    ASSERT_EQ(Factorial(3), 6);
    ASSERT_EQ(Factorial(10), 3628800);
}
