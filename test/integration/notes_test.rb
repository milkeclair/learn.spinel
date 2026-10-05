require "test_helper"

class NotesTest < ActionDispatch::IntegrationTest
  test "index and form" do
    get root_url
    assert_response :success
    assert_select "h2", text: notes(:one).title
    get new_note_url
    assert_response :success
    assert_select "form input[name='note[title]']"
  end

  test "create and display escaped content" do
    assert_difference("Note.count", 1) do
      post notes_url, params: { note: { title: "日本語 <script>", body: "1行目
2行目 <b>本文</b>" } }
    end
    follow_redirect!
    assert_response :success
    assert_select "h1", text: "日本語 <script>"
    assert_select "script", count: 0
    assert_select "p.body b", count: 0
  end

  test "reject invalid creation and preserve body" do
    assert_no_difference("Note.count") do
      post notes_url, params: { note: { title: " ", body: "入力した本文" } }
    end
    assert_response :unprocessable_entity
    assert_select "[role=alert]"
    assert_select "textarea", text: "入力した本文"
  end

  test "edit and update" do
    note = notes(:one)
    get edit_note_url(note)
    assert_response :success
    patch note_url(note), params: { note: { title: "更新済み", body: "更新本文" } }
    assert_response :see_other
    follow_redirect!
    assert_select "h1", text: "更新済み"
    assert_equal "更新本文", note.reload.body
  end

  test "reject invalid update without modifying saved note" do
    note = notes(:one)
    patch note_url(note), params: { note: { title: "", body: "変更" } }
    assert_response :unprocessable_entity
    assert_equal "最初のメモ", note.reload.title
    assert_equal "メモの本文", note.body
  end

  test "destroy" do
    assert_difference("Note.count", -1) do
      delete note_url(notes(:one))
    end
    assert_response :see_other
    follow_redirect!
    assert_response :success
  end

  test "missing note returns not found" do
    get note_url(id: 999999)
    assert_response :not_found
  end

  test "only title and body may be assigned" do
    post notes_url, params: { note: { title: "安全なメモ", body: "", id: 123456 } }
    assert_not_equal 123456, Note.last.id
  end
end
