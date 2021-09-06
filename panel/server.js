
/*
 * @Author: Jerrykuku https://github.com/jerrykuku
 * @Date: 2021-1-8
 * @Version: v0.0.2
 * @thanks: FanchangWang https://github.com/FanchangWang
 */

var express = require('express');
var session = require('express-session');
var compression = require('compression');
var bodyParser = require('body-parser');
var got = require('got');
var path = require('path');
var fs = require('fs');
var { execSync, exec } = require('child_process');
const crypto = require('crypto');
const { createProxyMiddleware } = require('http-proxy-middleware');


var rootPath = path.resolve(__dirname, '..');
// cookie.sh 文件所在目录
var ckFile = path.join(rootPath, 'config/cookie.sh');
// config.sh 文件所在目录
var confFile = path.join(rootPath, 'config/config.sh');
// config.sh.sample 文件所在目录
var sampleFile = path.join(rootPath, 'sample/config.sh.sample');
// crontab.list 文件所在目录
var crontabFile = path.join(rootPath, 'config/crontab.list');
// config.sh 文件备份目录
var confBakDir = path.join(rootPath, 'config/bak/');
// auth.json 文件目录
var authConfigFile = path.join(rootPath, 'config/auth.json');
// 限制文件
var autoConfigFile = path.join(rootPath, '.AutoConfig/config.sh');
// Share Code 文件目录
var shareCodeDir = path.join(rootPath, 'log/jd_get_share_code/');
// diy.sh 文件目录
var diyFile = path.join(rootPath, 'config/diy.sh');
// 日志目录
var logPath = path.join(rootPath, 'log/');
// 脚本目录
var ScriptsPath = path.join(rootPath, 'scripts/');

var authError = "错误的用户名密码，请重试";
var loginFaild = "请先登录!";

var configString = "config usrconfig sample crontab shareCode diy";

var s_token, cookies, guid, lsid, lstoken, okl_token, token, userCookie = "";

var ErrorTimes = 0;

function praseSetCookies(response) {
    s_token = response.body.s_token
    guid = response.headers['set-cookie'][0]
    guid = guid.substring(guid.indexOf("=") + 1, guid.indexOf(";"))
    lsid = response.headers['set-cookie'][2]
    lsid = lsid.substring(lsid.indexOf("=") + 1, lsid.indexOf(";"))
    lstoken = response.headers['set-cookie'][3]
    lstoken = lstoken.substring(lstoken.indexOf("=") + 1, lstoken.indexOf(";"))
    cookies = "guid=" + guid + "; lang=chs; lsid=" + lsid + "; lstoken=" + lstoken + "; "
}

function getCookie(response) {
    var TrackerID = response.headers['set-cookie'][0]
    TrackerID = TrackerID.substring(TrackerID.indexOf("=") + 1, TrackerID.indexOf(";"))
    var pt_key = response.headers['set-cookie'][1]
    pt_key = pt_key.substring(pt_key.indexOf("=") + 1, pt_key.indexOf(";"))
    var pt_pin = response.headers['set-cookie'][2]
    pt_pin = pt_pin.substring(pt_pin.indexOf("=") + 1, pt_pin.indexOf(";"))
    var pt_token = response.headers['set-cookie'][3]
    pt_token = pt_token.substring(pt_token.indexOf("=") + 1, pt_token.indexOf(";"))
    var pwdt_id = response.headers['set-cookie'][4]
    pwdt_id = pwdt_id.substring(pwdt_id.indexOf("=") + 1, pwdt_id.indexOf(";"))
    var s_key = response.headers['set-cookie'][5]
    s_key = s_key.substring(s_key.indexOf("=") + 1, s_key.indexOf(";"))
    var s_pin = response.headers['set-cookie'][6]
    s_pin = s_pin.substring(s_pin.indexOf("=") + 1, s_pin.indexOf(";"))
    cookies = "TrackerID=" + TrackerID + "; pt_key=" + pt_key + "; pt_pin=" + pt_pin + "; pt_token=" + pt_token + "; pwdt_id=" + pwdt_id + "; s_key=" + s_key + "; s_pin=" + s_pin + "; wq_skey="
    var userCookie = "pt_key=" + pt_key + ";pt_pin=" + pt_pin + ";";
    return userCookie;
}

async function step1() {
    try {
        s_token, cookies, guid, lsid, lstoken, okl_token, token = ""
        let timeStamp = (new Date()).getTime()
        let url = 'https://plogin.m.jd.com/cgi-bin/mm/new_login_entrance?lang=chs&appid=300&returnurl=https://wq.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=https://home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action&source=wq_passport'
        const response = await got(url, {
            responseType: 'json',
            headers: {
                'Connection': 'Keep-Alive',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'zh-cn',
                'Referer': 'https://plogin.m.jd.com/login/login?appid=300&returnurl=https://wq.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=https://home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action&source=wq_passport',
                'User-Agent': 'jdapp;iPhone;10.1.2;14.7.1;${randomString(40)};network/wifi;model/iPhone10,2;addressid/4091160336;appBuild/167802;jdSupportDarkMode/0;Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1',
                'Host': 'plogin.m.jd.com'
            }
        });

        praseSetCookies(response)
    } catch (error) {
        cookies = "";
        console.log(error.response.body);
    }
};

async function step2() {
    try {
        if (cookies == "") {
            return 0
        }
        let timeStamp = (new Date()).getTime()
        let url = 'https://plogin.m.jd.com/cgi-bin/m/tmauthreflogurl?s_token=' + s_token + '&v=' + timeStamp + '&remember=true'
        const response = await got.post(url, {
            responseType: 'json',
            json: {
                'lang': 'chs',
                'appid': 300,
                'source': 'wq_passport',
                'returnurl': 'https://wqlogin2.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=//home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action'
            },
            headers: {
                'Connection': 'Keep-Alive',
                'Content-Type': 'application/x-www-form-urlencoded; Charset=UTF-8',
                'Accept': 'application/json, text/plain, */*',
                'Cookie': cookies,
                'Referer': 'https://plogin.m.jd.com/login/login?appid=300&returnurl=https://wqlogin2.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=//home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action&source=wq_passport',
                'User-Agent': 'jdapp;iPhone;10.1.2;14.7.1;${randomString(40)};network/wifi;model/iPhone10,2;addressid/4091160336;appBuild/167802;jdSupportDarkMode/0;Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1',
                'Host': 'plogin.m.jd.com',
            }
        });
        token = response.body.token
        okl_token = response.headers['set-cookie'][0]
        okl_token = okl_token.substring(okl_token.indexOf("=") + 1, okl_token.indexOf(";"))
        var qrUrl = 'https://plogin.m.jd.com/cgi-bin/m/tmauth?appid=300&client_type=m&token=' + token;
        return qrUrl;
    } catch (error) {
        console.log(error.response.body);
        return 0
    }
}

var i = 0;

async function checkLogin() {
    try {
        if (cookies == "") {
            return 0
        }
        let timeStamp = (new Date()).getTime()
        let url = 'https://plogin.m.jd.com/cgi-bin/m/tmauthchecktoken?&token=' + token + '&ou_state=0&okl_token=' + okl_token;
        const response = await got.post(url, {
            responseType: 'json',
            form: {
                lang: 'chs',
                appid: 300,
                source: 'wq_passport',
                returnurl: 'https://wqlogin2.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=//home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action'
            },
            headers: {
                'Referer': 'https://plogin.m.jd.com/login/login?appid=300&returnurl=https://wqlogin2.jd.com/passport/LoginRedirect?state=' + timeStamp + '&returnurl=//home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&/myJd/home.action&source=wq_passport',
                'Cookie': cookies,
                'Connection': 'Keep-Alive',
                'Content-Type': 'application/x-www-form-urlencoded; Charset=UTF-8',
                'Accept': 'application/json, text/plain, */*',
                'User-Agent': 'jdapp;iPhone;10.1.2;14.7.1;${randomString(40)};network/wifi;model/iPhone10,2;addressid/4091160336;appBuild/167802;jdSupportDarkMode/0;Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1',
            }
        });

        return response;
    } catch (error) {
        console.log(error.response.body);
        let res = {}
        res.body = { check_ip: 0, errcode: 222, message: '出错' }
        res.headers = {}
        return res;
    }
}

function TotalBean() {
    return new Promise(async resolve => {
      const options = {
        url: "https://me-api.jd.com/user_new/info/GetJDUserInfoUnion",
        headers: {
          Host: "me-api.jd.com",
          Accept: "*/*",
          Connection: "keep-alive",
          Cookie: cookies,
          'User-Agent': 'jdapp;iPhone;10.1.2;14.7.1;${randomString(40)};network/wifi;model/iPhone10,2;addressid/4091160336;appBuild/167802;jdSupportDarkMode/0;Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1',
          "Accept-Language": "zh-cn",
          "Referer": "https://home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&",
          "Accept-Encoding": "gzip, deflate, br"
        }
      }
      $.get(options, (err, resp, data) => {
        try {
          if (err) {
            $.logErr(err)
          } else {
            if (data) {
              data = JSON.parse(data);
              if (data['retcode'] === "1001") {
                $.isLogin = false; //cookie过期
                return;
              }
              if (data['retcode'] === "0" && data.data && data.data.hasOwnProperty("userInfo")) {
                $.nickName = data.data.userInfo.baseInfo.nickname;
              }
            } else {
              $.log('京东服务器返回空数据');
            }
          }
        } catch (e) {
          $.logErr(e)
        } finally {
          resolve();
        }
      })
    })
  }

function AutoAddCK(cookie, msg) {
    const content = getFileContentByName(ckFile);
    const lines = content.split('\n');
    const pt_pin = cookie.match(/pt_pin=.+?;/)[0];
    let updateFlag = false;
    let lastIndex = 0;
    let maxCookieCount = 0;
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.startsWith('Cookie')) {
            maxCookieCount = line.split('=')[0].split('Cookie')[1];
            lastIndex = i;
            if (
                line.match(/pt_pin=.+?;/) &&
                line.match(/pt_pin=.+?;/)[0] == pt_pin
            ) {
                const head = line.split('=')[0];
                const newLine = [head, '=', '"', cookie, '"', '  #', msg].join('');
                lines[i] = newLine;
                updateFlag = true;
            }
        }
    }
    if (!updateFlag) {
        const newLine = [
            'Cookie',
            Number(maxCookieCount) + 1,
            '=',
            '"',
            cookie,
            '"',
            '  #',
            msg,
        ].join('');
        lines.splice(lastIndex + 1, 0, newLine);
    }
    saveNewConf('cookie.sh', lines.join('\n'));
}

/**
 * hash方法
 *
 * @param {String} e.g.: 'md5', 'sha1'
 * @param {String|Buffer} s
 * @param {String} [format] 'hex'，'base64'. default is 'hex'.
 * @return {String} 编码值
 * @private
 */
const hash = (method, s, format) => {
    var sum = crypto.createHash(method);
    var isBuffer = Buffer.isBuffer(s);
    if (!isBuffer && typeof s === 'object') {
        s = JSON.stringify(sortObject(s));
    }
    sum.update(s, isBuffer ? 'binary' : 'utf8');
    return sum.digest(format || 'hex');
};

/**
 - md5 编码
 -  3. @param {String|Buffer} s
 - @param {String} [format] 'hex'，'base64'. default is 'hex'.
 - @return {String} md5 hash string
 - @public
 */
const md5 = (s, format) => {
    return hash('md5', s, format);
};

function CountUser() {
    const content = getFileContentByName(ckFile);
    const lines = content.split('\n');
    let maxCookieCount = 0;
    let UserCount;
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.startsWith('Cookie')) {
            maxCookieCount = line.split('=')[0].split('Cookie')[1];
            UserCount = Number(maxCookieCount);
        }
    }
    return UserCount;
}
/**
 * @getClientIP
 * @desc 获取用户 ip 地址
 * @param {Object} req - 请求
 */
function getClientIP(req) {
    return req.headers['x-forwarded-for'] || req.connection.remoteAddress || req.socket.remoteAddress || req.connection.socket.remoteAddress;
};

/**
 * 检查 config.sh 以及 config.sh.sample 文件是否存在
 */
function checkConfigFile() {
    if (!fs.existsSync(ckFile)) {
        console.error('脚本启动失败，cookie.sh 文件不存在！');
        process.exit(1);
    }
    if (!fs.existsSync(sampleFile)) {
        console.error('脚本启动失败，config.sh.sample 文件不存在！');
        process.exit(1);
    }
    if (!fs.existsSync(autoConfigFile)) {
        console.error('脚本启动失败，此面板只适用于JSTOOL！');
        process.exit(1);
    }
}

/**
 * 检查 config/bak/ 备份目录是否存在，不存在则创建
 */
function mkdirConfigBakDir() {
    if (!fs.existsSync(confBakDir)) {
        fs.mkdirSync(confBakDir);
    }
}

/**
 * 备份 config.sh 文件
 */
function bakConfFile(file) {
    mkdirConfigBakDir();
    let date = new Date();
    let bakConfFile = confBakDir + file + '_' + date.getFullYear() + '-' + date.getMonth() + '-' + date.getDay() + '-' + date.getHours() + '-' + date.getMinutes() + '-' + date.getMilliseconds();
    let oldConfContent = "";
    switch (file) {
        case "cookie.sh":
            oldConfContent = getFileContentByName(ckFile);
            fs.writeFileSync(bakConfFile, oldConfContent);
            break;
        case "config.sh":
            oldConfContent = getFileContentByName(confFile);
            fs.writeFileSync(bakConfFile, oldConfContent);
            break;
        case "crontab.list":
            oldConfContent = getFileContentByName(crontabFile);
            fs.writeFileSync(bakConfFile, oldConfContent);
            break;
        case "diy.sh":
            oldConfContent = getFileContentByName(diyFile);
            fs.writeFileSync(bakConfFile, oldConfContent);
            break;
        default:
            break;
    }

}

/**
 * 将 post 提交内容写入 config.sh 文件（同时备份旧的 config.sh 文件到 bak 目录）
 * @param content
 */
function saveNewConf(file, content) {
    bakConfFile(file);
    switch (file) {
        case "cookie.sh":
            fs.writeFileSync(ckFile, content);
            break;
        case "config.sh":
            fs.writeFileSync(confFile, content);
            break;
        case "crontab.list":
            fs.writeFileSync(crontabFile, content);
            execSync('crontab ' + crontabFile);
            break;
        case "diy.sh":
            fs.writeFileSync(diyFile, content);
            break;
        default:
            break;
    }
}

/**
 * 获取文件内容
 * @param fileName 文件路径
 * @returns {string}
 */
function getFileContentByName(fileName) {
    if (fs.existsSync(fileName)) {
        return fs.readFileSync(fileName, 'utf8');
    }
    return '';
}

/**
 * 获取目录中最后修改的文件的路径
 * @param dir 目录路径
 * @returns {string} 最新文件路径
 */
function getLastModifyFilePath(dir) {
    var filePath = '';

    if (fs.existsSync(dir)) {
        var lastmtime = 0;

        var arr = fs.readdirSync(dir);

        arr.forEach(function (item) {
            var fullpath = path.join(dir, item);
            var stats = fs.statSync(fullpath);
            if (stats.isFile()) {
                if (stats.mtimeMs >= lastmtime) {
                    filePath = fullpath;
                }
            }
        });
    }
    return filePath;
}


var app = express();
// gzip压缩
app.use(compression({ level: 6, filter: shouldCompress }));

function shouldCompress(req, res) {
    if (req.headers['x-no-compression']) {
        // don't compress responses with this request header
        return false;
    }

    // fallback to standard filter function
    return compression.filter(req, res);
}

app.use(session({
    secret: 'secret',
    name: `connect.${Math.random()}`,
    resave: true,
    saveUninitialized: true
}));
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
app.use(express.static(path.join(__dirname, 'public')));


/**
 * 首页
 */
app.get('/', function (request, response) {
    let OldIPContent = getFileContentByName(logPath + 'panel.txt');
    let date = new Date();
    let bakConfFile = '时间为：' + date.getFullYear() + '-' + date.getMonth() + '-' + date.getDay() + '-' + date.getHours() + '-' + date.getMinutes() + '-' + date.getMilliseconds();
    OldIPContent = OldIPContent + '\n' + '访问您【首页】的IP为' + getClientIP(request) + bakConfFile + '\n';
    fs.writeFileSync(logPath + 'panel.txt', OldIPContent);
    if (request.session.loggedin) {
        response.redirect('./usrconfig');
    } else {
        response.sendFile(path.join(__dirname + '/public/index1.html'));
    }
});

/**
 * 登录页面
 */
app.get('/login', function (request, response) {
    if (request.session.loggedin) {
        response.redirect('./usrconfig');
    } else {
        response.sendFile(path.join(__dirname + '/public/login.html'));
    }
});

/**
 * 用户名密码
 */
app.get('/changepwd', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/pwd.html'));
    } else {
        response.redirect('/login');
    }
});

/**
 * terminal
 */
app.get('/terminal', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/terminal.html'));
    } else {
        response.redirect('/');
    }
});


/**
 * 获取二维码链接
 */

app.get('/qrcode', function (request, response) {
    (async () => {
        try {
            await step1();
            const qrurl = await step2();
            if (qrurl != 0) {
                response.send({ err: 0, qrcode: qrurl });
            } else {
                response.send({ err: 1, msg: "错误" });
            }
        } catch (err) {
            response.send({ err: 1, msg: err });
        }
    })();
})

/**
 * 发送用户数
 */

app.get('/GetUserCount', function (request, response) {
    let SendNum = '当前有' + CountUser() + '名用户';
    response.send({ err: 0, msg: SendNum });
})

/**
 * 获取返回的cookie信息
 */

app.get('/cookie', function (request, response) {
    if (request.session.loggedin && cookies != "") {
        (async () => {
            try {
                const cookie = await checkLogin();
                if (cookie.body.errcode == 0) {
                    let ucookie = getCookie(cookie);
                    response.send({ err: 0, cookie: ucookie });
                } else {
                    response.send({ err: cookie.body.errcode, msg: cookie.body.message });
                }
            } catch (err) {
                response.send({ err: 1, msg: err });
            }
        })();
    } else {
        response.send({ err: 1, msg: loginFaild });
    }
})

/**
 * 获取返回的cookie信息
 */

app.post('/cookie', function (request, response) {
    (async () => {
        try {
            const cookie = await checkLogin();
            if (cookie.body.errcode == 0) {
                let ucookie = getCookie(cookie);
                let adddata = ucookie;
                AutoAddCK(adddata, request.body.msg);
                response.send({ err: 0, cookie: ucookie });
            } else {
                response.send({ err: cookie.body.errcode, msg: cookie.body.message });
            }
        } catch (err) {
            response.send({ err: 1, msg: err });
        }
    })();
})

/**
 * 获取各种配置文件api
 */

app.get('/api/config/:key', function (request, response) {
    if (request.session.loggedin) {
        if (configString.indexOf(request.params.key) > -1) {
            switch (request.params.key) {
                case 'config':
                    content = getFileContentByName(confFile);
                    break;
                case 'usrconfig':
                    content = getFileContentByName(ckFile);
                    break;
                case 'sample':
                    content = getFileContentByName(sampleFile);
                    break;
                case 'crontab':
                    content = getFileContentByName(crontabFile);
                    break;
                case 'shareCode':
                    let shareCodeFile = getLastModifyFilePath(shareCodeDir);
                    content = getFileContentByName(shareCodeFile);
                    break;
                case 'diy':
                    content = getFileContentByName(diyFile);
                    break;
                default:
                    break;
            }
            response.setHeader("Content-Type", "text/plain");
            response.send(content);
        } else {
            response.send("no config");
        }
    } else {
        response.send(loginFaild);
    }
})

/**
 * 首页
 */
app.get('/home', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/home.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * 配置页面
 */
app.get('/usrconfig', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/usrconfig.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * 对比 配置页面
 */
app.get('/diff', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/diff.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * Share Code 页面
 */
app.get('/shareCode', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/shareCode.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * crontab 配置页面
 */
app.get('/crontab', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/crontab.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * 自定义脚本 页面
 */
app.get('/diy', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/diy.html'));
    } else {
        response.redirect('/login');
    }

});

/**
 * 手动执行脚本 页面
 */
app.get('/run', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/run.html'));
    } else {
        response.redirect('/login');
    }
});

app.post('/runCmd', function (request, response) {
    if (request.session.loggedin) {
        const cmd = `cd ${rootPath};` + request.body.cmd;
        const delay = request.body.delay || 0;
        // console.log('before exec');
        // exec maxBuffer 20MB
        exec(cmd, { maxBuffer: 1024 * 1024 * 20 }, (error, stdout, stderr) => {
            // console.log(error, stdout, stderr);
            // 根据传入延时返回数据，有时太快会出问题
            setTimeout(() => {
                if (error) {
                    console.error(`执行的错误: ${error}`);
                    response.send({ err: 1, msg: stdout ? `${stdout}${error}` : `${error}` });
                    return;

                }

                if (stdout) {
                    // console.log(`stdout: ${stdout}`)
                    response.send({ err: 0, msg: `${stdout}` });
                    return;

                }

                if (stderr) {
                    console.error(`stderr: ${stderr}`);
                    response.send({ err: 1, msg: `${stderr}` });
                    return;
                }

                response.send({ err: 0, msg: '执行结束，无结果返回。' });
            }, delay);
        });
    } else {
        response.redirect('/login');
    }
});

/**
 * 使用jsName获取最新的日志
 */
app.get('/runLog/:jsName', function (request, response) {
    if (request.session.loggedin) {
        const jsName = request.params.jsName;
        let shareCodeFile = getLastModifyFilePath(path.join(rootPath, `log/${jsName}/`));
        if (jsName === 'rm_log') {
            shareCodeFile = path.join(rootPath, `log/${jsName}.log`)
        }

        if (shareCodeFile) {
            const content = getFileContentByName(shareCodeFile);
            response.setHeader("Content-Type", "text/plain");
            response.send(content);
        } else {
            response.send("no logs");
        }
    } else {
        response.send(loginFaild);
    }
})

/**
 * login
 */
app.post('/login', function (request, response) {
    let username = md5(request.body.username);
    let password = md5(request.body.password);
    let OldIPContent = getFileContentByName(logPath + 'panel.txt');
    let UserTicket;
    if (ErrorTimes > 30) {
        response.send({ err: 1, msg: "面板检测到有暴力破解的行为，已关闭登入系统" });
    }
    fs.readFile(authConfigFile, 'utf8', function (err, data) {
        if (err) console.log(err);
        var con = JSON.parse(data);
        if (con.entry !== '1') {
            let AuthData = {
                UserTicket: md5(con.user) + md5(con.password),
                entry: '1'
            }
            UserTicket = md5(con.user) + md5(con.password);
            fs.writeFileSync(authConfigFile, JSON.stringify(AuthData));
        }
        if (username && password) {
            let GetTicket = username + password;
            if (GetTicket == con.UserTicket) {
                ErrorTimes = 0;
                request.session.loggedin = true;
                request.session.UserTicket = GetTicket;
                response.send({ err: 0 });
            }
            else if (GetTicket == UserTicket) {
                ErrorTimes = 0;
                request.session.loggedin = true;
                request.session.UserTicket = GetTicket;
                response.send({ err: 0 });
            }
            else {
                response.send({ err: 1, msg: authError });
                //setTimeout(function() { callback(null); }, 8000);
                ErrorTimes = ErrorTimes + 1;
                let date = new Date();
                let bakConfFile = '时间为：' + date.getFullYear() + '-' + date.getMonth() + '-' + date.getDay() + '-' + date.getHours() + '-' + date.getMinutes() + '-' + date.getMilliseconds();
                OldIPContent = OldIPContent + '\n' + '【输入密码错误】，访问IP为' + getClientIP(request) + bakConfFile + '\n';
                if (ErrorTimes > 29) {
                    OldIPContent = OldIPContent + '面板检测到有暴力破解的行为，已关闭登入系统' + '\n';
                }
                fs.writeFileSync(logPath + 'panel.txt', OldIPContent);
            }
        } else {
            response.send({ err: 1, msg: "请输入用户名密码!" });
        }
    });

});

/**
 * change pwd
 */
app.post('/changepass', function (request, response) {
    if (request.session.loggedin) {
        let username = request.body.username;
        let password = request.body.password;
        let config = {
            user: username,
            password: password
        }
        if (username && password) {
            fs.writeFile(authConfigFile, JSON.stringify(config), function (err) {
                if (err) {
                    response.send({ err: 1, msg: "写入错误请重试!" });
                } else {
                    response.send({ err: 0, msg: "更新成功!" });
                }
            });
        } else {
            response.send({ err: 1, msg: "请输入用户名密码!" });
        }

    } else {
        response.send(loginFaild);

    }
});

/**
 * change pwd
 */
app.get('/logout', function (request, response) {
    request.session.destroy()
    response.redirect('/login');

});


/**
 * save config
 */

app.post('/api/save', function (request, response) {
    if (request.session.loggedin) {
        let postContent = request.body.content;
        let postfile = request.body.name;
        saveNewConf(postfile, postContent);
        response.send({ err: 0, title: "保存成功! ", msg: "将自动刷新页面查看修改后的 " + postfile + " 文件" });
    } else {
        response.send({ err: 1, title: "保存失败! ", msg: loginFaild });
    }

});

/**
 * 日志查询 页面
 */
app.get('/log', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/tasklog.html'));
    } else {
        response.redirect('/login');
    }
});

/**
 * 日志列表
 */
app.get('/api/logs', function (request, response) {
    if (request.session.loggedin) {
        var fileList = fs.readdirSync(logPath, 'utf-8');
        var dirs = [];
        var rootFiles = [];
        for (var i = 0; i < fileList.length; i++) {
            var stat = fs.lstatSync(logPath + fileList[i]);
            // 是目录，需要继续
            if (stat.isDirectory()) {
                var fileListTmp = fs.readdirSync(logPath + '/' + fileList[i], 'utf-8');
                fileListTmp.reverse();
                var dirMap = {
                    dirName: fileList[i],
                    files: fileListTmp
                }
                dirs.push(dirMap);
            } else {
                rootFiles.push(fileList[i]);
            }
        }

        dirs.push({
            dirName: '@',
            files: rootFiles
        });
        var result = { dirs };
        response.send(result);

    } else {
        response.redirect('/login');
    }

});

/**
 * 日志文件
 */
app.get('/api/logs/:dir/:file', function (request, response) {
    if (request.session.loggedin) {
        let filePath;
        if (request.params.dir === '@') {
            filePath = logPath + request.params.file;
        } else {
            filePath = logPath + request.params.dir + '/' + request.params.file;
        }
        var content = getFileContentByName(filePath);
        response.setHeader("Content-Type", "text/plain");
        response.send(content);
    } else {
        response.redirect('/login');
    }

});


/**
 * 查看脚本 页面
 */
app.get('/viewScripts', function (request, response) {
    if (request.session.loggedin) {
        response.sendFile(path.join(__dirname + '/public/viewScripts.html'));
    } else {
        response.redirect('/login');
    }
});

/**
 * 脚本列表
 */
app.get('/api/scripts', function (request, response) {
    if (request.session.loggedin) {
        var fileList = fs.readdirSync(ScriptsPath, 'utf-8');
        var dirs = [];
        var rootFiles = [];
        var excludeRegExp = /(git)|(node_modules)|(icon)/;
        for (var i = 0; i < fileList.length; i++) {
            var stat = fs.lstatSync(ScriptsPath + fileList[i]);
            // 是目录，需要继续
            if (stat.isDirectory()) {
                var fileListTmp = fs.readdirSync(ScriptsPath + '/' + fileList[i], 'utf-8');
                fileListTmp.reverse();

                if (excludeRegExp.test(fileList[i])) {
                    continue;
                }

                var dirMap = {
                    dirName: fileList[i],
                    files: fileListTmp
                }
                dirs.push(dirMap);
            } else {
                if (excludeRegExp.test(fileList[i])) {
                    continue;
                }

                rootFiles.push(fileList[i]);
            }
        }

        dirs.push({
            dirName: '@',
            files: rootFiles
        });
        var result = { dirs };
        response.send(result);

    } else {
        response.redirect('/login');
    }

});

/**
 * 脚本文件
 */
app.get('/api/scripts/:dir/:file', function (request, response) {
    if (request.session.loggedin) {
        let filePath;
        if (request.params.dir === '@') {
            filePath = ScriptsPath + request.params.file;
        } else {
            filePath = ScriptsPath + request.params.dir + '/' + request.params.file;
        }
        var content = getFileContentByName(filePath);
        response.setHeader("Content-Type", "text/plain");
        response.send(content);
    } else {
        response.redirect('/login');
    }

});

/**
 * 远程提交ck.
 */
app.post('/addck', function (request, response) {
       try {
           const cookie = request.query.ck;
           if ( cookie.match(/pt_pin=.+?;/) && cookie.match(/pt_key=.+?;/)){
             AutoAddCK(cookie, '上传ck添加成功'); 
             response.send({ err: 0, msg: '上传ck添加成功' });
          }else{
             response.send({ err: 1, msg: '上传的ck格式错误' });
          }
       }
       catch (err) {
           response.send({ err: 1, msg: err });
       }
});

checkConfigFile();

// ttyd proxy
app.use('/RandomShellEntry', createProxyMiddleware({
    target: 'http://localhost:9999',
    ws: true,
    changeOrigin: true,
    pathRewrite: {
        '^/RandomShellEntry': '/',
    },
}));

app.listen(5678, () => {
    console.log('应用正在监听 5678 端口!');
});
