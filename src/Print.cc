#include "arduino-mock/Print.h"

#include <assert.h>

static PrintMock *gPrintMock = NULL;

PrintMock *printMockInstance() {
  if (!gPrintMock) {
    gPrintMock = new PrintMock();
  }
  return gPrintMock;
}

void releasePrintMock() {
  if (gPrintMock) {
    delete gPrintMock;
    gPrintMock = NULL;
  }
}

size_t Print::write(const uint8_t *buffer, size_t size) {
  assert(gPrintMock != NULL);
  return gPrintMock->write(buffer, size);
}

size_t Print::print(const char *s) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(s);
}

size_t Print::print(char c) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(c);
}

size_t Print::print(unsigned char c, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(c, base);
}

size_t Print::print(int num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(num, base);
}

size_t Print::print(unsigned int num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(num, base);
}

size_t Print::print(long num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(num, base);
}

size_t Print::print(unsigned long num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(num, base);
}

size_t Print::print(double num, int digits) {
  assert(gPrintMock != NULL);
  return gPrintMock->print(num, digits);
}

size_t Print::println(const char *s) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(s);
}

size_t Print::println(char c) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(c);
}

size_t Print::println(unsigned char c, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(c, base);
}

size_t Print::println(int num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(num, base);
}

size_t Print::println(unsigned int num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(num, base);
}

size_t Print::println(long num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(num, base);
}

size_t Print::println(unsigned long num, int base) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(num, base);
}

size_t Print::println(double num, int digits) {
  assert(gPrintMock != NULL);
  return gPrintMock->println(num, digits);
}

size_t Print::println(void) {
  assert(gPrintMock != NULL);
  return gPrintMock->println();
}
