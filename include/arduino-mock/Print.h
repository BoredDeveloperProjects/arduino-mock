/**
 * Arduino Print mock
 */
#ifndef ARDUINO_MOCK_PRINT_H
#define ARDUINO_MOCK_PRINT_H

#include <gmock/gmock.h>
#include <stddef.h>
#include <stdint.h>

#ifndef DEC
#define DEC 10
#endif
#ifndef HEX
#define HEX 16
#endif
#ifndef OCT
#define OCT 8
#endif
#ifndef BIN
#define BIN 2
#endif

class PrintMock {
 public:
  MOCK_METHOD2(write, size_t(const uint8_t *buffer, size_t size));

  MOCK_METHOD1(print, size_t(const char[]));
  MOCK_METHOD1(print, size_t(char));
  MOCK_METHOD2(print, size_t(unsigned char, int));
  MOCK_METHOD2(print, size_t(int, int));
  MOCK_METHOD2(print, size_t(unsigned int, int));
  MOCK_METHOD2(print, size_t(long, int));
  MOCK_METHOD2(print, size_t(unsigned long, int));
  MOCK_METHOD2(print, size_t(double, int));

  MOCK_METHOD1(println, size_t(const char[]));
  MOCK_METHOD1(println, size_t(char));
  MOCK_METHOD2(println, size_t(unsigned char, int));
  MOCK_METHOD2(println, size_t(int, int));
  MOCK_METHOD2(println, size_t(unsigned int, int));
  MOCK_METHOD2(println, size_t(long, int));
  MOCK_METHOD2(println, size_t(unsigned long, int));
  MOCK_METHOD2(println, size_t(double, int));
  MOCK_METHOD0(println, size_t(void));
};

class Print {
 public:
  virtual size_t write(const uint8_t *buffer, size_t size);

  virtual size_t print(const char[]);
  virtual size_t print(char);
  virtual size_t print(unsigned char, int = DEC);
  virtual size_t print(int, int = DEC);
  virtual size_t print(unsigned int, int = DEC);
  virtual size_t print(long, int = DEC);
  virtual size_t print(unsigned long, int = DEC);
  virtual size_t print(double, int = 2);

  virtual size_t println(const char[]);
  virtual size_t println(char);
  virtual size_t println(unsigned char, int = DEC);
  virtual size_t println(int, int = DEC);
  virtual size_t println(unsigned int, int = DEC);
  virtual size_t println(long, int = DEC);
  virtual size_t println(unsigned long, int = DEC);
  virtual size_t println(double, int = 2);
  virtual size_t println(void);
};

PrintMock *printMockInstance();
void releasePrintMock();

#endif  // ARDUINO_MOCK_PRINT_H
