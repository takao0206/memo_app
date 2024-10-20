function confirmDelete() {
  const confirm = window.confirm("削除を実行しますか？");
  return confirm
}

document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("memo-form");
  if (!form) {
    return;
  }
  const errorMessage = document.getElementById("error-message");

  form.addEventListener("submit", function (event) {
    let memoTitle = document.getElementById("title").value.trim();
    let memoContent = document.getElementById("content").value.trim();

    errorMessage.style.display = "none";
    errorMessage.innerText = "";

    if (!memoTitle || !memoContent) {
      event.preventDefault();
      errorMessage.style.display = "block";
      errorMessage.innerText = "タイトルと内容の両方を入力してください。";
    }
  });
});
