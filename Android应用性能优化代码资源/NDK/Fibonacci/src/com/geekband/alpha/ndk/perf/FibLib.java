package com.geekband.alpha.ndk.perf;

public class FibLib {

  // Java implementation - recursive
  public static int fibJ(int n) {
    if (n <= 0)
      return 0;
    if (n == 1)
      return 1;
    return fibJ(n - 1) + fibJ(n - 2);
  }

  // Java implementation - iterative
  public static int fibJI(int n) {
    int previous = -1;
    int result = 1;
    for (int i = 0; i <= n; i++) {
      int sum = result + previous;
      previous = result;
      result = sum;
    }
    return result;
  }

  // Native implementation
  static {
    System.loadLibrary("fib");
  }

  // Native implementation - recursive
  public static native int fibN(int n);

  // Native implementation - iterative
  public static native int fibNI(int n);
}
