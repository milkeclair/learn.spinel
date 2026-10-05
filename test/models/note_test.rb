require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "title is required" do
    note = Note.new(title: "", body: "本文")
    assert_not note.valid?
  end

  test "blank title is invalid" do
    note = Note.new(title: "   ", body: "本文")
    assert_not note.valid?
  end

  test "body is optional" do
    note = Note.new(title: "本文なし")
    assert note.valid?
  end
end
