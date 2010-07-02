require 'test_helper'

class LessonMailerTest < ActionMailer::TestCase
  test "leonid_confirm" do
    @expected.subject = 'LessonMailer#leonid_confirm'
    @expected.body    = read_fixture('leonid_confirm')
    @expected.date    = Time.now

    assert_equal @expected.encoded, LessonMailer.create_leonid_confirm(@expected.date).encoded
  end

  test "leonid_cancel" do
    @expected.subject = 'LessonMailer#leonid_cancel'
    @expected.body    = read_fixture('leonid_cancel')
    @expected.date    = Time.now

    assert_equal @expected.encoded, LessonMailer.create_leonid_cancel(@expected.date).encoded
  end

  test "student_confirm" do
    @expected.subject = 'LessonMailer#student_confirm'
    @expected.body    = read_fixture('student_confirm')
    @expected.date    = Time.now

    assert_equal @expected.encoded, LessonMailer.create_student_confirm(@expected.date).encoded
  end

  test "student_cancel" do
    @expected.subject = 'LessonMailer#student_cancel'
    @expected.body    = read_fixture('student_cancel')
    @expected.date    = Time.now

    assert_equal @expected.encoded, LessonMailer.create_student_cancel(@expected.date).encoded
  end

end
