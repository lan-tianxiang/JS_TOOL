$.ajaxSetup({
  cache: false
});

$("#login").click(function () {
  $user = $(".username").val();
  $password = $(".password").val();
  if (!$user || !$password) return;

  $.post('./login', {
    username: $user,
    password: $password
  }, function (data) {
    if (data.err == 0) {
      window.location.href = "./usrconfig";
    } else {
      Swal.fire({
        text: data.msg,
        icon: 'error'
      })
    }
  });
  return false;
});
