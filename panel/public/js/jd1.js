var qrcode, userCookie, timeId;

$(document).ready(function () {
  qrcode = new QRCode(document.getElementById('qrcode'), {
    text: 'sample',
    correctLevel: QRCode.CorrectLevel.L,
  });

  function checkLogin(user) {
    var timeId = setInterval(() => {
      let timeStamp = new Date().getTime();
      var msg = $('#ps').val();
      console.log(user);
      $.post(`./cookie?t=${timeStamp}`, { user, msg }, function (data) {
        if (data.err == 0) {
          clearInterval(timeId);
          $('#qrcontainer').addClass('hidden');
          $('#refresh_qrcode').addClass('hidden');
          userCookie = data.cookie;
          msg = data.msg;
          Swal.fire({
            title: '🎈添加成功🎈',
            html:
              '<div class="cookieCon" style="font-size:12px;">' +
              `您的账号已经成功添加，时长为一个月` +
              '</div>',
            icon: 'success',
            confirmButtonText: '返回',
          }).then((result) => {
            do_landing();
          });
        } else if (data.err == 21) {
          clearInterval(timeId);
          $('#refresh_qrcode').removeClass('hidden');
        }
      });
    }, 3000);
  }

  function GetQrCode() {
    let timeStamp = new Date().getTime();
    $.get('./qrcode?t=' + timeStamp, function (data) {
      if (data.err == 0) {
        $('#qrcontainer').removeClass('hidden');
        $('#refresh_qrcode').addClass('hidden');
        $('.landing').addClass('is-loading');
        qrcode.clear();
        qrcode.makeCode(data.qrcode);
        checkLogin(data.user);
      } else {
        Swal.fire({
          text: data.msg,
          icon: 'error',
        });
      }
    });
  }

  function JumpToApp() {
    let timeStamp = new Date().getTime();
    $.get('./qrcode?t=' + timeStamp, function (data) {
      if (data.err == 0) {
        $('#refresh_qrcode').addClass('hidden');
        $('.landing').addClass('is-loading');
        window.location.href = `openapp.jdmobile://virtual/ad?params=${encodeURI(
          JSON.stringify({
            category: 'jump',
            des: 'ThirdPartyLogin',
            action: 'to',
            onekeylogin: 'return',
            url: data.qrcode,
            authlogin_returnurl: 'weixin://',
            browserlogin_fromurl: window.location.host,
          })
        )}`;
        checkLogin(data.user);
      } else {
        Swal.fire({
          text: data.msg,
          icon: 'error',
        });
      }
    });
  }

  $('.refresh').click(GetQrCode);
  $('#GetQrCode').click(GetQrCode);
  $('#JumpToApp').click(JumpToApp);

  $('.qframe-close').click(function () {
    qframe_close();
  });

  function do_landing() {
    window.setTimeout(function () {
      $('.landing').removeClass('is-loading');
    }, 100);
  }

  function qframe_close() {
    $("#qrcontainer").addClass("hidden");
    $("#refresh_qrcode").addClass("hidden");
    //window.location.reload();
    clearInterval(timeId);
    do_landing();
  }
});