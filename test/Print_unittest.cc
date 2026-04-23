#include "arduino-mock/Print.h"
#include "arduino-mock/Serial.h"
#include "gtest/gtest.h"

using ::testing::InSequence;
using ::testing::Matcher;
using ::testing::Return;
using ::testing::StrEq;

class PrintTest : public ::testing::Test {
protected:
  void TearDown() override {
    releasePrintMock();
    releaseSerialMock();
  }
};

static void emitLog(Print *output, const char *board, const char *component,
                    const char *level, const char *message) {
  output->print("[");
  output->print(board);
  if (component) {
    output->print(" - ");
    output->print(component);
  }
  output->print("] [");
  output->print(level);
  output->print("] ");
  output->println(message);
}

TEST_F(PrintTest, singletonReturnsSameInstanceUntilReleased) {
  PrintMock *first = printMockInstance();
  PrintMock *second = printMockInstance();

  EXPECT_EQ(first, second);

  releasePrintMock();
  releasePrintMock();

  EXPECT_NE(nullptr, printMockInstance());
}

TEST_F(PrintTest, forwardsPrintOverloads) {
  Print output;
  PrintMock *printMock = printMockInstance();

  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("hello"))))
      .WillOnce(Return(5));
  EXPECT_EQ(5, output.print("hello"));

  EXPECT_CALL(*printMock, print(Matcher<char>('x'))).WillOnce(Return(1));
  EXPECT_EQ(1, output.print('x'));

  EXPECT_CALL(*printMock, print(Matcher<int>(42), Matcher<int>(DEC)))
      .WillOnce(Return(2));
  EXPECT_EQ(2, output.print(42));

  EXPECT_CALL(*printMock, print(Matcher<int>(255), Matcher<int>(HEX)))
      .WillOnce(Return(2));
  EXPECT_EQ(2, output.print(255, HEX));

  EXPECT_CALL(*printMock, print(Matcher<double>(3.14), Matcher<int>(2)))
      .WillOnce(Return(4));
  EXPECT_EQ(4, output.print(3.14));
}

TEST_F(PrintTest, forwardsPrintlnOverloads) {
  Print output;
  PrintMock *printMock = printMockInstance();

  EXPECT_CALL(*printMock, println(Matcher<const char *>(StrEq("hello"))))
      .WillOnce(Return(6));
  EXPECT_EQ(6, output.println("hello"));

  EXPECT_CALL(*printMock, println(Matcher<char>('x'))).WillOnce(Return(2));
  EXPECT_EQ(2, output.println('x'));

  EXPECT_CALL(*printMock, println(Matcher<int>(42), Matcher<int>(DEC)))
      .WillOnce(Return(3));
  EXPECT_EQ(3, output.println(42));

  EXPECT_CALL(*printMock, println(Matcher<double>(3.14), Matcher<int>(2)))
      .WillOnce(Return(5));
  EXPECT_EQ(5, output.println(3.14));

  EXPECT_CALL(*printMock, println()).WillOnce(Return(1));
  EXPECT_EQ(1, output.println());
}

TEST_F(PrintTest, serialCanBeUsedAsPrintTarget) {
  SerialMock *serialMock = serialMockInstance();
  Print *output = &Serial;

  EXPECT_CALL(*serialMock, print(Matcher<const char *>(StrEq("serial"))))
      .WillOnce(Return(6));

  EXPECT_EQ(6, output->print("serial"));
}

TEST_F(PrintTest, realisticStructuredLogUsage) {
  Print output;
  PrintMock *printMock = printMockInstance();
  Print *target = &output;

  InSequence sequence;
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("["))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("board1"))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("] ["))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("INFO"))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("] "))));
  EXPECT_CALL(*printMock,
              println(Matcher<const char *>(StrEq("system ready"))));

  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("["))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("board1"))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq(" - "))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("WiFi"))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("] ["))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("DEBUG"))));
  EXPECT_CALL(*printMock, print(Matcher<const char *>(StrEq("] "))));
  EXPECT_CALL(*printMock, println(Matcher<const char *>(StrEq("connected"))));

  emitLog(target, "board1", NULL, "INFO", "system ready");
  emitLog(target, "board1", "WiFi", "DEBUG", "connected");
}
