#include <com_geekband_alpha_ndk_perf_FibLib.h>



jint fibN(jint n) {
  if(n<=0) return 0;
  if(n==1) return 1;
  return fibN(n-1) + fibN(n-2);
}

jint fibNI(jint n) {
  jint previous = -1;
  jint result = 1;
  jint i=0;
  jint sum=0;
  for (i = 0; i <= n; i++) {
    sum = result + previous;
    previous = result;
    result = sum;
  }
  return result;
}

JNIEXPORT jint JNICALL Java_com_geekband_alpha_ndk_perf_FibLib_fibN
  (JNIEnv *env, jclass obj, jint  n) {
  return fibN(n);
}

JNIEXPORT jint JNICALL Java_com_geekband_alpha_ndk_perf_FibLib_fibNI
  (JNIEnv *env, jclass obj, jint  n) {
  return fibNI(n);
}
