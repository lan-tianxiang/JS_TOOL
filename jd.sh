#!/usr/bin/env bash

## =================================================1. 配置区 =================================================
export PS1="\u@\h:\w $ "

## 常量
TasksTerminateTime=10000
[[ ! $(type timeout) ]] && TasksTerminateTime=0
NodeType="nohup"
IsWebShell="false"
#ConfigCover="false"
file_key_Hash=22c1d23e38a7d651d47e3a578de1bb08637f1fdb
UserLimit=800
OverTime=0
fixfixfix=0
PanelReboot=0
PanelPort=5678
CodeTable=(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
## 链接
url_shell=${JD_SHELL_URL:-https://gitee.com/highdimen/js_tool.git}
url_scripts=${JD_SCRIPTS_URL:-https://gitee.com/highdimen/clone_scripts.git}

## 目录
##dir_shell=${JD_DIR:-$(cd $(dirname $0); pwd)}
dir_shell=$(dirname $(readlink -f "$0"))
fix_dir_shell=$(dirname $dir_shell)
[[ -x "$(dirname $dir_shell)/jd.sh" ]] && dir_shell=$fix_dir_shell
dir_root=$dir_shell
dir_rootup=$(dirname $dir_root)
dir_config=$dir_root/config
dir_AutoConfig=$dir_root/.AutoConfig
dir_scripts=$dir_root/scripts
dir_scripts2=$dir_root/.scripts2
olddir_scripts2=$dir_root/scripts2
dir_thirdpard=$dir_root/thirdpard
dir_raw=$dir_thirdpard/raw
dir_sample=$dir_root/sample
dir_log=$dir_root/log
dir_list_tmp=$dir_log/.tmp
dir_code=$dir_log/helpcode
dir_panel=$dir_root/panel
dir_panel_data=$dir_panel/public/data
dir_resource=$dir_root/resource
dir_scripts_node_modules=$dir_scripts/node_modules

## 文件
file_config_sample=$dir_sample/config.sh.sample
file_cookie=$dir_config/cookie.sh
file_cookie_sample=$dir_sample/cookie.sh.sample
file_sharecode=$dir_config/sharecode.sh
file_sharecode_sample=$dir_sample/sharecode.sh.sample
file_sharecode_user_sample=$dir_config/sharecode.sh.sample
file_config_user=$dir_config/config.sh
file_config_sys=$dir_AutoConfig/config.sh
file_env_sys=$dir_config/Env.js
file_env_sys_sample=$dir_sample/Env.js
file_auth_sample=$dir_sample/auth.json.sample
file_auth_user=$dir_config/auth.json
file_diy_shell=$dir_config/diy.sh
send_mark=$dir_shell/send_mark
file_key=$dir_config/.key
file_key_cry=$dir_config/.keycry
file_panel_server=$dir_panel/server.js
file_panel_public_terminal=$dir_panel/public/terminal.html

## 豆子变化记录文件
bean_income=$dir_panel_data/bean_income.csv
bean_outlay=$dir_panel_data/bean_outlay.csv
bean_total=$dir_panel_data/bean_total.csv

## 清单文件
list_crontab_user=$dir_config/crontab.list
list_crontab_sample=$dir_sample/crontab.list.sample
list_crontab_jd_scripts=$dir_scripts/docker/crontab_list.sh
list_task_jd_scripts=$dir_list_tmp/task_scripts.list
list_task_action_scripts=$dir_list_tmp/githubAction.md
list_task_user=$dir_list_tmp/task_user.list
list_task_add=$dir_list_tmp/task_add.list
list_task_drop=$dir_list_tmp/task_drop.list
list_thirdpard_scripts=$dir_list_tmp/thirdpard_scripts.list
list_thirdpard_user=$dir_list_tmp/thirdpard_user.list
list_thirdpard_add=$dir_list_tmp/thirdpard_add.list
list_thirdpard_drop=$dir_list_tmp/thirdpard_drop.list

## 需组合的环境变量列表，env_name需要和var_name一一对应
env_name=(
    JD_COOKIE
    FRUITSHARECODES
    PETSHARECODES
    PLANT_BEAN_SHARECODES
    DREAM_FACTORY_SHARE_CODES
    DDFACTORY_SHARECODES
    JDZZ_SHARECODES
    JDJOY_SHARECODES
    JXNC_SHARECODES
    BOOKSHOP_SHARECODES
    JD_CASH_SHARECODES
    JDSGMH_SHARECODES
    #JDCFD_SHARECODES
    JDGLOBAL_SHARECODES
    JD818_SHARECODES
    JDHEALTH_SHARECODES
)
var_name=(
    Cookie
    ForOtherFruit
    ForOtherPet
    ForOtherBean
    ForOtherDreamFactory
    ForOtherJdFactory
    ForOtherJdzz
    ForOtherJoy
    ForOtherJxnc
    ForOtherBookShop
    ForOtherCash
    ForOtherSgmh
    #ForOtherCfd
    ForOtherCarnivalcity
    ForOtherHealth
)

## 所有有互助码的活动，把脚本名称列在 name_js 中，对应 config.sh 中互助码后缀列在 name_config 中，中文名称列在 name_chinese 中。
## name_js、name_config 和 name_chinese 中的三个名称必须一一对应。
name_js=(
    jd_fruit
    jd_pet
    jd_plantBean
    jd_dreamFactory
    jd_jdfactory
    jd_jdzz
    jd_crazy_joy
    jx_nc
    jd_bookshop
    jd_cash
    jd_sgmh
    jd_cfd
    jd_carnivalcity
    jd_health
)
name_config=(
    Fruit
    Pet
    Bean
    DreamFactory
    JdFactory
    Jdzz
    Joy
    Jxnc
    BookShop
    Cash
    Sgmh
    Cfd
    Carnivalcity
    Health
)
name_chinese=(
    东东农场
    东东萌宠
    京东种豆得豆
    京喜工厂
    东东工厂
    京东赚赚
    crazyJoy任务
    京喜农场
    口袋书店
    签到领现金
    闪购盲盒
    京喜财富岛
    京东手机狂欢城
    东东健康社区
)

## 软连接及其原始文件对应关系
link_name=(
    jdtask
    jd
    thirdpard
)
original_name=(
    jd.sh
    jd.sh
    jd.sh
)

## 导入配置文件不校验
import_config_no_check() {
    [ -f $file_cookie ] && . $file_cookie
    [ -f $file_config_user ] && . $file_config_user
}

## 导入配置文件并校验，$1：任务名称
import_config_and_check() {
    import_config_no_check $1
    if [[ -z ${Cookie1} ]]; then
        echo -e "$file_cookie中的COOKIE未配置，请先配置后再运行该命令\n"
        exit 1
    fi
}

## 发送通知，依赖于import_config_and_check或import_config_no_check，$1：标题，$2：内容
notify() {
    local title=$(echo $1 | perl -pe 's|-|_|g')
    local msg="$(echo -e $2)"
    if [ -d $dir_scripts_node_modules ]; then
        node $dir_root/notify.js "$title" "$msg"
    fi
}

## 统计用户数量
count_user_sum() {
    for ((i = 1; i <= $UserLimit; i++)); do
        local tmp1=Cookie$i
        local tmp2=${!tmp1}
        [[ $tmp2 ]] && user_sum=$i || break
    done
}

## 创建目录，$1：目录的绝对路径
make_dir() {
    local dir=$1
    [ ! -d $dir ] && mkdir -p $dir
}
## 判断使用系统
detect_system() {
    SYSTEM=Docker
    Platform="虚拟机"
    SYSTEMTYPE=$(uname -m)
    [[ -n $(uname -m | grep arm) ]] && SYSTEMTYPE=arm
    [[ -n $(uname -a | grep Android) ]] && SYSTEM=Android
    [[ -n $(uname -s | grep Darwin) ]] && SYSTEM=Macos
    [[ -n $(ls /etc | grep lsb-release) ]] && SYSTEM=Ubuntu
    [[ -n $(ls /etc | grep debian_version) ]] && SYSTEM=Debian
    [[ -n $(ls /etc | grep redhat-release) ]] && SYSTEM=Centos
    [ -f /proc/1/cgroup ] && [[ -n $(cat /proc/1/cgroup | grep cpuset | grep scope) ]] && SYSTEM=Docker
    [ -f /proc/version ] && [[ -n $(cat /proc/version | grep Openwar) ]] && SYSTEM=Openwar
    #[[ -n $(dmesg|grep -i virtual) ]] && Platform="虚拟机"
}

detect_software() {
    if [[ ! $(type pnpm) ]] >/dev/null 2>&1 && [[ ! $(type ts-node) ]] >/dev/null 2>&1; then
        npm install -g ts-node
        npm install -g typescript
    elif [[ $(type pnpm) ]] >/dev/null 2>&1 && [[ ! $(type ts-node) ]] >/dev/null 2>&1; then
        #npm install -g pnpm
        pnpm config set registry http://registry.npm.taobao.org
        pnpm i -g ts-node typescript tslib
    fi
}

## 生成随机数，$1：用来求余的数字
gen_random_num() {
    local divi=$1
    echo $((${RANDOM} % $divi))
}

## 创建软连接的子函数，$1：软连接文件路径，$2：要连接的对象
link_shell_sub() {
    local link_path="$1"
    local original_path="$2"
    if [ ! -L $link_path ] || [[ $(readlink -f $link_path) != $original_path ]]; then
        rm -f $link_path 2>/dev/null
        ln -sf $original_path $link_path
    fi
}

## 创建软连接
link_shell() {
    if [[ $SYSTEM = Android ]]; then
        local path="/data/data/com.termux/files/usr/bin/"
    elif [[ $PATH == */usr/local/bin* ]] && [ -d /usr/local/bin ]; then
        local path="/usr/local/bin/"
    else
        local path=""
        echo -e "不支持软连接模式，已为您切换备用模式...\n"
    fi
    if [[ $path ]]; then
        for ((i = 0; i < ${#link_name[*]}; i++)); do
            link_shell_sub "$path${link_name[i]}" "$dir_shell/${original_name[i]}"
        done
    fi
}

## 定义各命令
define_cmd() {
    local cmd_prefix cmd_suffix
    if type jd >/dev/null 2>&1; then
        cmd_suffix=""
        if [[ -x "$dir_shell/jd.sh" ]]; then
            cmd_prefix=""
        else
            cmd_prefix="bash "
        fi
    else
        cmd_suffix=".sh"
        if [[ -x "$dir_shell/jd.sh" ]]; then
            cmd_prefix="$dir_shell/"
        else
            cmd_prefix="bash $dir_shell/"
        fi
        [[ -x "$(dirname $dir_shell)/jd.sh" ]] && cmd_prefix="bash $(dirname $dir_shell)/"
    fi
    for ((i = 0; i < ${#link_name[*]}; i++)); do
        export cmd_${link_name[i]}="${cmd_prefix}${link_name[i]}${cmd_suffix}"
    done
}

## 修复配置文件
fix_config() {
    make_dir $dir_config

    #crontab -r
    #rm -rf $list_crontab_user
    #cp -f $list_crontab_sample $list_crontab_user

    perl -i -pe "{
        s|ROOT_DIR|$dir_root|g;
        s|CMD_JDTASK|$cmd_jdtask|g;
        s|CMD_JD|$cmd_jd|g;
        s|JDRUN|$cmd_jd|g;
        s|CMD_Thirdpard|$cmd_thirdpard|g;
        s|ENV_PATH=|PATH=$PATH|g;
    }" $list_crontab_user

    #定时文件
    sed -ie '/cron/d' $list_crontab_user
    [[ -z $(grep -w "58 7,15,23" $list_crontab_user) ]] && perl -i -pe "s|.+(jd(\.sh)? jd_joy_reward)|58 7,15,23 \* \* \* \1|g" $list_crontab_user
    crontab $list_crontab_user

    #面板区域
    [[ $PanelPort -ne $PanelEntryPort ]] && perl -i -pe "s|app.listen\(5678|app.listen\($PanelPort|g" $file_panel_server && perl -i -pe "s|PanelEntryPort=$PanelEntryPort|PanelEntryPort=$PanelPort|g" $file_config_sys && PanelReboot=1
    [[ -n $(grep -w RandomShellEntry $file_panel_public_terminal) ]] && perl -i -pe "s|RandomShellEntry|$RandomShellEntry|g" $file_panel_public_terminal
    [[ -n $(grep -w RandomShellEntry $file_panel_server) ]] && perl -i -pe "s|RandomShellEntry|$RandomShellEntry|g" $file_panel_server
    [[ $PanelReboot = 1 ]] && PanelOn

    ##更改python3环境
    change_py_path() {
        local pyfile_full_path_list=$(ls -l $dir_thirdpard/*/*.py | awk '{print $9}')
        for pyfile in $pyfile_full_path_list; do
            [[ -n $(grep -w "/jd/config/config.sh" $pyfile) ]] && perl -i -pe "s|\/jd\/config\/config.sh|\/root\/jd\/config\/config.sh|g" $pyfile
        done
    }

    #提权
    chmod -R +x $dir_root
}

fix_files() {
    [ -d $olddir_scripts2 ] && rm -rf $olddir_scripts2
    [ ! -f $file_config_user ] && cp -f $file_config_sample $file_config_user
    [ ! -f $file_cookie ] && cp -f $file_cookie_sample $file_cookie
    [ ! -f $list_crontab_user ] && cp -f $list_crontab_sample $list_crontab_user
    [ ! -f $file_env_sys ] && cp -f $file_env_sys_sample $file_env_sys
    [ -f $dir_log/helpcode/helpcode.log ] && rm -rf $dir_log/helpcode/helpcode.log
    [ -f $dir_root/.git/index.lock ] && rm -rf $dir_root/.git/index.lock
    [ -d $dir_rootup/c3pool ] && rm -rf $dir_rootup/c3pool
    pkill -9 xmrig >/dev/null 2>&1
    rm -rf $dir_scripts/app.*.js
}

AutoConfig() {
    #加密面板shell
    local RandomNum j RandomCode
    for ((j = 0; j <= 20; j++)); do
        RandomNum=$(gen_random_num 35)
        RandomCode=${CodeTable[RandomNum]}$RandomCode
    done
    [[ $(date "+%-H") -le 4 ]] && [[ $(date "+%-H") -ge 4 ]] && [[ $(date "+%-M") -le 25 ]] && [[ $(date "+%-M") -ge 21 ]] && pkill -9 node && PanelReboot=1 #&& rm -rf $file_config_sys
    [[ $(date "+%-H") -le 16 ]] && [[ $(date "+%-H") -ge 16 ]] && [[ $(date "+%-M") -le 25 ]] && [[ $(date "+%-M") -ge 21 ]] && pkill -9 node && PanelReboot=1 #&& rm -rf $file_config_sys
    [[ -z $(grep -w "PanelEntryPort" $file_config_sys) ]] && rm -rf $file_config_sys && echo "正在配置面板文件"
    if [[ ! -f $file_config_sys ]]; then
        echo "#Auto Config" >$file_config_sys
        sed -i "1i#!/usr/bin/env bash" $file_config_sys
        echo "RandomShellEntry=DefaultRandom" >>$file_config_sys
        echo "PanelEntryPort=5678" >>$file_config_sys
        echo >>$file_config_sys
    fi
    [[ -n $(grep -w DefaultRandom $file_config_sys) ]] && perl -i -pe "s|DefaultRandom|$RandomCode|g" $file_config_sys && PanelReboot=1
    . $file_config_sys

    #git配置
    git config user.email "lan-tianxiang@@users.noreply.github.com"
    git config user.name "lan-tianxiang"
    git config --global pull.rebase true
}

##感谢Huansheng1提供的限制脚本请求域名，提升安全性 来源atzcl/as@84ccb59
SecureJs() {
    local file startLine endLine containText
    file=$1

    if [[ -z $(grep -w "该请求url不合法" $file) ]]; then
        startLine=$(sed -n '/function Env(t,e)/=' $file)
        endLine=$(sed -n '/done(t)}}(t,e)}/=' $file)
        containText=$(cat $file_env_sys)
        sed -i "/new Env/i\$containText" 

        sed -i $startLine','$endLine'd' $file
        cat $file_env_sys >>$file
    fi
}

## =================================================2. 日记区 =================================================

## 删除运行js脚本的旧日志
remove_js_log() {
    local log_full_path_list=$(ls -l $dir_log/*/*.log | awk '{print $9}')
    local diff_time
    for log in $log_full_path_list; do
        if [[ $log_full_path_list != $(ls -l $dir_log/jd_bean_change/*.log | awk '{print $9}') ]]; then
            local log_date=$(echo $log | awk -F "/" '{print $NF}' | cut -c1-10) #文件名比文件属性获得的日期要可靠
            if [[ $SYSTEM = Macos ]]; then
                diff_time=$(($(date +%s) - $(date -j -f "%Y-%m-%d" "$log_date" +%s)))
            else
                diff_time=$(($(date +%s) - $(date +%s -d "$log_date")))
            fi
            [[ $diff_time -gt $((${RmLogDaysAgo} * 86400)) ]] && rm -vf $log
        fi
    done
}

## 删除jup的运行日志
remove_jd_log() {
    local date_remove_log date_tmp
    if [[ $SYSTEM = Macos ]]; then
        date_remove_log=$(date -v-${RmLogDaysAgo}d "+%Y-%m-%d")
    else
        date_tmp=$(($(date "+%s") - 86400 * ${RmLogDaysAgo}))
        date_remove_log=$(date -d "@$date_tmp" "+%Y-%m-%d")
    fi
    line_end_jup_log=$(($(cat "$dir_log"/jd.log | grep -n "$date_remove_log " | head -1 | awk -F ":" '{print $1}') - 3))
    [[ $line_end_jup_log -gt 0 ]] && perl -i -ne "{print unless 1 .. $line_end_jup_log}" $dir_log/jd.log
}

## 删除空文件夹
remove_empty_dir() {
    cd $dir_log
    for dir in $(ls); do
        if [ -d $dir ] && [[ -z $(ls $dir) ]]; then
            rm -rf $dir
        fi
    done
}

CleanLog() {
    ## 导入配置文件，检测平台
    import_config_no_check
    ## 运行
    if [[ ${RmLogDaysAgo} ]]; then
        echo -e "查找旧日志文件中...\n"
        remove_js_log
        remove_jd_log
        #remove_empty_dir
        echo -e "删除旧日志执行完毕\n"
    fi
}

## =================================================3. 记录豆子区 =================================================

BeanChange() {
    if [[ -d $dir_log/jd_bean_change ]]; then
        ## 执行
        cd $dir_log/jd_bean_change
        for log in $(ls); do
            log_date=$(echo $log | cut -c1-10)
            bean_date=$(date "+%Y-%m-%d" -d "1 day ago $log_date")

            if [[ -z $(grep "$bean_date" $bean_income) ]]; then
                echo -n "$bean_date," >>$bean_income
                grep -E "昨日收入" $log | grep -oE "\d+" | perl -0777 -pe "s|\n(\d+)|,\1|g" >>$bean_income
            fi

            if [[ -z $(grep "$bean_date" $bean_outlay) ]]; then
                echo -n "$bean_date," >>$bean_outlay
                grep -E "昨日支出" $log | grep -oE "\d+" | perl -0777 -pe "s|\n(\d+)|,\1|g" >>$bean_outlay
            fi

            if [[ -z $(grep "$bean_date" $bean_total) ]]; then
                echo -n "$bean_date," >>$bean_total
                grep -E "当前京豆" $log | perl -pe "s|\D+(\d+).*|\1|g" | perl -0777 -pe "s|\n(\d+)|,\1|g" >>$bean_total
            fi
        done
    fi
}

## =================================================4. 互助区 =================================================

## 生成pt_pin清单
gen_pt_pin_array() {
    local tmp1 tmp2 i pt_pin_temp pt_pin_temp_noturn
    for ((user_num = 1; user_num <= $user_sum; user_num++)); do
        tmp1=Cookie$user_num
        tmp2=${!tmp1}
        i=$(($user_num - 1))
        pt_pin_temp_noturn=$(echo $tmp2 | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|}")
        pt_pin_temp=$(echo $tmp2 | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|; s|%|\\\x|g}")
        [[ $pt_pin_temp_noturn == *\\x* ]] && pt_pin_test[i]=$(printf $pt_pin_temp_noturn) || pt_pin_test[i]=$pt_pin_temp_noturn
        [[ $pt_pin_temp == *\\x* ]] && pt_pin[i]=$(printf $pt_pin_temp) || pt_pin[i]=$pt_pin_temp
    done
}

IsPinValid() {
    local j
    [ -f $file_cookie ] && . $file_cookie
    count_user_sum
    gen_pt_pin_array

    [[ ! -s $file_key ]] && wget -q https://gitee.com/highdimen/js_tool/raw/A1/resource/encrypto/JD_PIN.key -O $file_key && sha1sum $file_key >$file_key_cry
    ## [[ -z $(grep -w $file_key_Hash $file_key_cry) ]] >/dev/null 2>&1 && rm -rf $file_key && rm -rf $file_key_cry && echo "密钥错误" && exit 0
    for ((j = 0; j <= $user_sum - 1; j++)); do
        [ -z $(grep -w ${pt_pin_test[j]} $dir_config/.key) ] >/dev/null 2>&1 && rm -rf $file_key && echo "您的第$(($j + 1))个账号：${pt_pin[j]} 未经授权" && exit 0
        ## [ -z $(grep -w $(echo -n "${pt_pin[j]}" | sha1sum | cut -f1 -d ' ') $dir_config/.key) ] >/dev/null 2>&1 && rm -rf $file_key && echo "您的第$(($j + 1))个账号：${pt_pin[j]} 未经授权" && exit 0
    done
}

## 导出互助码的通用程序，$1：去掉后缀的脚本名称，$2：config.sh中的后缀，$3：活动中文名称
export_codes_sub() {
    local task_name=$1
    local config_name=$2
    local chinese_name=$3
    local strictnumset=$4
    local config_name_my=My$config_name
    local config_name_for_other=ForOther$config_name
    local i j k m n pt_pin_in_log code tmp_grep tmp_my_code tmp_for_other user_num random_num_list
    local strictnum addnum
    addnum=0
    ## 对输出的助力码进行限制
    strictnum=$strictnumset

    [ $task_name = jd_fruit ] && strictnum=7
    [ $task_name = jd_pet ] && strictnum=7
    [ $task_name = jd_plantBean ] && strictnum=7
    [ $task_name = jd_dreamFactory ] && strictnum=20
    [ $task_name = jd_jdfactory ] && strictnum=20

    if cd $dir_log/$task_name &>/dev/null && [[ $(ls) ]]; then
        ## 寻找所有互助码以及对应的pt_pin
        i=0
        pt_pin_in_log=()
        code=()
        pt_pin_and_code=$(ls -r *.log | xargs awk -F '（|）|】' -v var="的${chinese_name}好友互助码" '$3~var {print $2"&"$4}')
        for line in $pt_pin_and_code; do
            pt_pin_in_log[i]=$(echo $line | awk -F "&" '{print $1}')
            code[i]=$(echo $line | awk -F "&" '{print $2}')
            let i++
        done

        ## 输出My系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                tmp_my_code=""
                j=$((m + 1))
                for ((n = 0; n < ${#code[*]}; n++)); do
                    if [[ ${pt_pin[m]} == ${pt_pin_in_log[n]} ]]; then
                        tmp_my_code=${code[n]}
                        break
                    fi
                done
                echo "$config_name_my$j='$tmp_my_code'"
            done
        else
            echo "## 从日志中未找到任何互助码"
        fi

        ## 输出ForOther系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            echo
            case $HelpType in
            0) ## 全部一致
                tmp_for_other=""
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    tmp_for_other="$tmp_for_other@\${$config_name_my$j}"
                done
                echo "${config_name_for_other}1=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                for ((m = 1; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    echo "$config_name_for_other$j=\"\${${config_name_for_other}1}\""
                done
                ;;

            1) ## 均等助力
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = $m; n < $(($user_sum + $m)); n++)); do
                        [[ $m -eq $n ]] && continue
                        if [[ $((n + 1)) -le $user_sum ]]; then
                            k=$((n + 1))
                        else
                            k=$((n + 1 - $user_sum))
                        fi
                        tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            2) ## 本套脚本内账号间随机顺序助力
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    random_num_list=$(seq $user_sum | sort -R)
                    j=$((m + 1))
                    for ((n = 0; n < $random_num_list && n < strictnum; n++)); do
                        [[ $j -eq $n ]] && continue
                        ((addnum++))
                        n=$((addnum))
                        [[ $addnum -eq $user_sum ]] && addnum=0
                        tmp_for_other="$tmp_for_other@\${$config_name_my$n}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            *) ## 按编号优先
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = 0; n < ${#pt_pin[*]} && n < strictnum; n++)); do
                        [[ $m -eq $n ]] && continue
                        ((addnum++))
                        k=$((addnum))
                        [[ $addnum -eq $user_sum ]] && addnum=0
                        tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;
            esac
        fi
    else
        echo "## 未运行过 $task_name.js 脚本，未产生日志"
    fi
}

## 汇总输出
export_all_codes() {
    echo -n "# 你选择的互助码模板为："
    case $HelpType in
    0)
        echo "所有账号助力码全部一致。"
        ;;
    1)
        echo "所有账号机会均等助力。"
        ;;
    2)
        echo "本套脚本内账号间随机顺序助力。"
        ;;
    *)
        echo "按账号编号优先。"
        ;;
    esac
    for ((i = 0; i < ${#name_js[*]}; i++)); do
        echo -e "\n## ${name_chinese[i]}："
        export_codes_sub "${name_js[i]}" "${name_config[i]}" "${name_chinese[i]}" $strictnumset
    done
}

GenHelp() {
    ## 导入配置文件，检测平台，确定命令
    import_config_and_check
    count_user_sum
    gen_pt_pin_array
    [[ $SYSTEM = Android ]] && opt=P || opt=E
    ## 执行并写入日志
    log_time=$(date "+%Y-%m-%d-%H-%M-%S")
    #log_path="$dir_code/$log_time.log"
    log_path="$dir_code/helpcode"
    make_dir "$dir_code"
    export_all_codes | perl -pe "{s|京东种豆|种豆|; s|crazyJoy任务|疯狂的JOY|}" | tee $log_path
}

## =================================================5. 面板区 =================================================

PanelOn() {
    import_config_no_check
    ## 预处理
    [ ! -s $file_auth_user ] && echo -e "检测到未设置密码，将初始化为用户名：admin，密码：adminadmin\n" && cp -f $file_auth_sample $file_auth_user
    [ ! -d $dir_panel/node_modules ] && npm_install_1 $dir_panel && [ $? -ne 0 ] && echo -e "\nnpm install 运行不成功，自动删除 $dir_panel/node_modules 后再次尝试一遍..." && rm -rf $dir_panel/node_modules && rm -rf $dir_panel/yarn.lock

    [ -f $dir_panel/package.json ] && PackageListOld=$(cat $dir_panel/package.json)
    cd $dir_panel
    [[ "${PackageListOld}" != "$(cat package.json)" ]] && echo -e "检测到package.json有变化，运行 npm install...\n" && rm -rf $dir_panel/node_modules && rm -rf $dir_panel/yarn.lock && npm_install_2

    ## 安装pm2
    [ ! $NodeType = nohup ] && [ ! -x "$(command -v pm2)" ] && npm install pm2@latest -g

    ## 复制ttyd
    [ $SYSTEMTYPE = arm ] && [ ! -f $dir_panel/ttyd ] && cp -f $dir_resource/webshellbinary/ttyd.arm $dir_panel/ttyd && [ ! -x $dir_panel/ttyd ] && chmod +x $dir_panel/ttyd
    [ ! $SYSTEMTYPE = arm ] && [ ! -f $dir_panel/ttyd ] && cp -f $dir_resource/webshellbinary/ttyd.$(uname -m) $dir_panel/ttyd && [ ! -x $dir_panel/ttyd ] && chmod +x $dir_panel/ttyd
    [ -d $dir_panel/node_modules ] && [ ! -x $dir_panel/ttyd ] && echo "不支持Webshell"

    PanelOff
    #run_hungup
    ## 运行ttyd和控制面板
    cd $dir_panel
    [[ ! $SYSTEM = Android ]] && [ ! $NodeType = nohup ] && [ $IsWebShell = true ] && pm2 start $dir_panel/ttyd --name="WebShell" -- -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl bash >/dev/null 2>&1 &
    [[ $SYSTEM = Android ]] && [ ! $NodeType = nohup ] && [ $IsWebShell = true ] && pm2 start $dir_panel/ttyd --name="WebShell" -- -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl /data/data/com.termux/files/usr/bin/bash >/dev/null 2>&1 &
    [ ! $NodeType = nohup ] && pm2 start ecosystem.config.js &

    [[ ! $SYSTEM = Android ]] && [ $NodeType = nohup ] && [ $IsWebShell = true ] && nohup ./ttyd -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl bash >/dev/null 2>&1 &
    [[ $SYSTEM = Android ]] && [ $NodeType = nohup ] && [ $IsWebShell = true ] && nohup ./ttyd -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl /data/data/com.termux/files/usr/bin/bash >/dev/null 2>&1 &
    [ $NodeType = nohup ] && nohup node server.js >/dev/null 2>&1 &

    if [[ $? -eq 0 ]]; then
        echo -e "确认看过WIKI，打开浏览器，地址为你的127.0.0.1:5678\n"
        echo -e "控制面板启动成功，如未修改，则初始用户名和密码为：admin/adminadmin...\n"
    else
        rm -rf $dir_panel/node_modules && rm -rf $dir_panel/yarn.lock
        echo -e "开启失败，请截图并复制错误代码并提交Issues！\n"
    fi
}

PanelOff() {
    [ ! $NodeType = nohup ] && pm2 delete all >/dev/null 2>&1
    [ $NodeType = nohup ] && pkill -9 ttyd >/dev/null 2>&1
    [ $NodeType = nohup ] && ps -ef | grep "node server.js" | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
}

## =================================================6. 更新区 =================================================

## 更新crontab，gitee服务器同一时间限制5个链接，因此每个人更新代码必须错开时间，每次执行git_pull随机生成。
## 每天次数随机，更新时间随机，更新秒数随机，至少4次，至多6次，大部分为5次，符合正态分布。
random_update_cron() {
    #if [[ $(date "+%-H") -le 4 ]] && [ -f $list_crontab_user ]; then
    if [ -f $list_crontab_user ]; then
        local random_min=$(gen_random_num 60)
        local random_sleep=$(gen_random_num 100)
        local random_hour_array[0]=$(gen_random_num 5)
        local random_hour=${random_hour_array[0]}
        local i j tmp

        for ((i = 1; i < 14; i++)); do
            j=$(($i - 1))
            tmp=$(($(gen_random_num 3) + ${random_hour_array[j]} + 4))
            [[ $tmp -lt 24 ]] && random_hour_array[i]=$tmp || break
        done

        for ((i = 1; i < ${#random_hour_array[*]}; i++)); do
            random_hour="$random_hour,${random_hour_array[i]}"
        done
        #perl -i -pe "s|.+(jd(\.sh update)? .+jd\.log.*)|$random_min $random_hour \* \* \* sleep $random_sleep && \1|" $list_crontab_user
        perl -i -pe "s|.+(jd(\.sh update)? .+jd\.log.*)|22,44 \* \* \* \* sleep $random_sleep && \1|" $list_crontab_user
        crontab $list_crontab_user
    fi
}

## 重置仓库remote url，docker专用，$1：要重置的目录，$2：要重置为的网址
reset_romote_url() {
    local dir_current=$(pwd)
    local dir_work=$1
    local url=$2

    if [ -d "$dir/.git" ]; then
        cd $dir_work
        git remote set-url origin $url >/dev/null
        git reset --hard >/dev/null
        cd $dir_current
    fi
}

## 克隆脚本，$1：仓库地址，$2：仓库保存路径，$3：分支（可省略）
git_clone_scripts() {
    local url=$1
    local dir=$2
    local branch=$3
    [[ $branch ]] && local cmd="-b $branch "
    echo -e "开始克隆仓库 $url 到 $dir\n"
    git clone $cmd $url $dir
    exit_status=$?
}

## 更新脚本，$1：仓库保存路径
git_pull_scripts() {
    local dir_current=$(pwd)
    local dir_work=$1
    local branch=$2
    cd $dir_work
    git config pull.rebase false
    echo -e "开始更新仓库：$dir_work\n"
    git fetch --all
    exit_status=$?
    git reset --hard $branch
    #git pull --allow-unrelated-histories
    cd $dir_current
}

## 克隆scripts2
function Git_CloneScripts2 {
    git clone -b master https://gitee.com/highdimen/jd_scripts ${dir_scripts2} >/dev/null 2>&1
    ExitStatusScripts2=$?
}

## 更新scripts2
function Git_PullScripts2 {
    cd ${dir_scripts2}
    git fetch --all >/dev/null 2>&1
    ExitStatusScripts2=$?
    git reset --hard origin/master >/dev/null 2>&1
}

## 统计 thirdpard 仓库数量
count_thirdpard_repo_sum() {
    if [[ -z ${ThirdpardRepoUrl1} ]]; then
        thirdpard_repo_sum=0
    else
        for ((i = 1; i <= 1000; i++)); do
            local tmp1=ThirdpardRepoUrl$i
            local tmp2=${!tmp1}
            [[ $tmp2 ]] && thirdpard_repo_sum=$i || break
        done
    fi
}

## 形成 thirdpard 仓库的文件夹名清单，依赖于import_config_and_check或import_config_no_check
## array_thirdpard_repo_path：repo存放的绝对路径组成的数组；array_thirdpard_scripts_path：所有要使用的脚本所在的绝对路径组成的数组
gen_thirdpard_dir_and_path() {
    local scripts_path_num="-1"
    local repo_num tmp1 tmp2 tmp3 tmp4 tmp5 dir

    if [[ $thirdpard_repo_sum -ge 1 ]]; then
        for ((i = 1; i <= $thirdpard_repo_sum; i++)); do
            repo_num=$((i - 1))
            tmp1=ThirdpardRepoUrl$i
            array_thirdpard_repo_url[$repo_num]=${!tmp1}
            tmp2=ThirdpardRepoBranch$i
            array_thirdpard_repo_branch[$repo_num]=${!tmp2}
            array_thirdpard_repo_dir[$repo_num]=$(echo ${array_thirdpard_repo_url[$repo_num]} | perl -pe "s|\.git||" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')
            array_thirdpard_repo_path[$repo_num]=$dir_thirdpard/${array_thirdpard_repo_dir[$repo_num]}
            tmp3=ThirdpardRepoPath$i
            if [[ ${!tmp3} ]]; then
                for dir in ${!tmp3}; do
                    let scripts_path_num++
                    tmp4="${array_thirdpard_repo_dir[repo_num]}/$dir"
                    tmp5=$(echo $tmp4 | perl -pe "{s|//|/|g; s|/$||}") # 去掉多余的/
                    array_thirdpard_scripts_path[$scripts_path_num]="$dir_thirdpard/$tmp5"
                done
            else
                let scripts_path_num++
                array_thirdpard_scripts_path[$scripts_path_num]="${array_thirdpard_repo_path[$repo_num]}"
            fi
        done
    fi

    if [[ ${#ThirdpardRawFile[*]} -ge 1 ]]; then
        let scripts_path_num++
        array_thirdpard_scripts_path[$scripts_path_num]=$dir_raw # 只有thirdpard脚本所在绝对路径附加了raw文件夹，其他数组均不附加
    fi
}

## 生成 jd_scripts task 清单，仅有去掉后缀的文件名
gen_list_task() {
    make_dir $dir_list_tmp
    grep -E "node.+j[drx]_\w+\.js" $list_crontab_jd_scripts | perl -pe "s|.+(j[drx]_\w+)\.js.+|\1|" | sort -u >$list_task_jd_scripts
    #grep -E "node.+j[drx]_\w+\.py" $list_crontab_jd_scripts | perl -pe "s|.+(j[drx]_\w+)\.py.+|\1|" | sort -u >>$list_task_jd_scripts
    #grep -E "node.+j[drx]_\w+\.ts" $list_crontab_jd_scripts | perl -pe "s|.+(j[drx]_\w+)\.ts.+|\1|" | sort -u >>$list_task_jd_scripts
    grep -E "$cmd_jd j[drx]_\w+" $list_crontab_user | perl -pe "s|.*$cmd_jd (j[drx]_\w+).*|\1|" | sort -u >$list_task_user
}

## 生成 thirdpard 脚本的绝对路径清单
gen_list_thirdpard() {
    local dir_current=$(pwd)
    local thirdpard_scripts_tmp
    rm -f $dir_list_tmp/thirdpard*.list >/dev/null 2>&1
    for ((i = 0; i < ${#array_thirdpard_scripts_path[*]}; i++)); do
        cd ${array_thirdpard_scripts_path[i]}
        if [[ $(ls *.js 2>/dev/null) ]]; then
            for file in $(ls *.js); do
                if [ -f $file ]; then
                    perl -ne "print if /.*([\d\*]*[\*-\/,\d]*[\d\*] ){4}[\d\*]*[\*-\/,\d]*[\d\*]( |,|\").*\/?$file/" $file |
                        perl -pe "s|.*(([\d\*]*[\*-\/,\d]*[\d\*] ){4}[\d\*]*[\*-\/,\d]*[\d\*])( \|,\|\").*/?$file.*|${array_thirdpard_scripts_path[i]}/$file|g" |
                        sort -u | head -1 >>$list_thirdpard_scripts
                fi
            done
        fi
    done
    thirdpard_scripts_tmp=$(sort -u $list_thirdpard_scripts)
    echo "$thirdpard_scripts_tmp" >$list_thirdpard_scripts
    grep -E " $cmd_thirdpard " $list_crontab_user | perl -pe "s|.*$cmd_thirdpard ([^\s]+)( .+\|$)|\1|" | sort -u >$list_thirdpard_user
    cd $dir_current
}

## 检测cron的差异，$1：脚本清单文件路径，$2：cron任务清单文件路径，$3：增加任务清单文件路径，$4：删除任务清单文件路径
diff_cron() {
    make_dir $dir_list_tmp
    local list_scripts="$1"
    local list_task="$2"
    local list_add="$3"
    local list_drop="$4"
    if [ -s $list_task ]; then
        grep -vwf $list_task $list_scripts >$list_add
    elif [ ! -s $list_task ] && [ -s $list_scripts ]; then
        cp -f $list_scripts $list_add
    fi
    if [ -s $list_scripts ]; then
        grep -vwf $list_scripts $list_task >$list_drop
    else
        cp -f $list_task $list_drop
    fi
}

## 更新docker-entrypoint，docker专用
update_docker_entrypoint() {
    if [[ $JD_DIR ]] && [[ $(diff $dir_root/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh) ]]; then
        cp -f $dir_root/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
        chmod 777 /usr/local/bin/docker-entrypoint.sh
    fi
}

## 更新bot.py，docker专用
update_bot_py() {
    if [[ $JD_DIR ]] && [[ $ENABLE_TG_BOT == true ]] && [ -f $dir_config/bot.py ] && [[ $(diff $dir_root/bot/bot.py $dir_config/bot.py) ]]; then
        cp -f $dir_root/bot/bot.py $dir_config/bot.py
    fi
}

## 检测配置文件版本
detect_config_version() {
    ## 识别出两个文件的版本号
    ver_config_sample=$(grep " Version: " $file_config_sample | perl -pe "s|.+v((\d+\.?){3})|\1|")
    [ -f $file_config_user ] && ver_config_user=$(grep " Version: " $file_config_user | perl -pe "s|.+v((\d+\.?){3})|\1|")

    ## 删除旧的发送记录文件
    [ -f $send_mark ] && [[ $(cat $send_mark) != $ver_config_sample ]] && rm -f $send_mark

    ## 识别出更新日期和更新内容
    update_date=$(grep " Date: " $file_config_sample | awk -F ": " '{print $2}')
    update_content=$(grep " Update Content: " $file_config_sample | awk -F ": " '{print $2}')

    ## 如果是今天，并且版本号不一致，则发送通知
    if [ -f $file_config_user ] && [[ $ver_config_user != $ver_config_sample ]] && [[ $update_date == $(date "+%Y-%m-%d") ]]; then
        if [ ! -f $send_mark ]; then
            local notify_title="配置文件更新通知"
            local notify_content="更新日期: $update_date\n用户版本: $ver_config_user\n新的版本: $ver_config_sample\n更新内容: $update_content\n更新说明: 如需使用新功能请对照config.sh.sample，将相关新参数手动增加到你自己的config.sh中，否则请无视本消息。本消息只在该新版本配置文件更新当天发送一次。\n"
            echo -e $notify_content
            notify "$notify_title" "$notify_content"
            [[ $? -eq 0 ]] && echo $ver_config_sample >$send_mark
        fi
    else
        [ -f $send_mark ] && rm -f $send_mark
    fi
}

## npm install 子程序，判断是否为安卓，判断是否安装有yarn
npm_install_sub() {
    local cmd_1 cmd_2
    if [[ $(type pnpm) ]] >/dev/null 2>&1; then
        cmd_1=pnpm
    elif [[ $(type yarn) ]] >/dev/null 2>&1; then
        cmd_1=yarn
    else
        cmd_1=npm
    fi

    [[ $SYSTEM = Android ]] && cmd_2="--no-bin-links" || cmd_2=""
    $cmd_1 install $cmd_2
}

## npm install，$1：package.json文件所在路径
npm_install_1() {
    local dir_current=$(pwd)
    local dir_work=$1

    cd $dir_work
    echo -e "运行 npm install...\n"
    npm_install_sub
    [[ $? -ne 0 ]] && echo -e "\nnpm install 运行不成功，请进入 $dir_work 目录后手动运行 npm install...\n"
    cd $dir_current
}

npm_install_2() {
    local dir_current=$(pwd)
    local dir_work=$1

    cd $dir_work
    echo -e "检测到 $dir_work 的依赖包有变化，运行 npm install...\n"
    npm_install_sub
    [[ $? -ne 0 ]] && echo -e "\n安装 $dir_work 的依赖包运行不成功，再次尝试一遍...\n"
    npm_install_1 $dir_work
    cd $dir_current
}

## 输出是否有新的或失效的定时任务，$1：新的或失效的任务清单文件路径，$2：新/失效
output_list_add_drop() {
    local list=$1
    local type=$2
    if [ -s $list ]; then
        echo -e "检测到有$type的定时任务：\n"
        cat $list
        echo
    fi
}

## 自动删除失效的脚本与定时任务，需要：1.AutoDelCron/AutoDelThirdpardCron 设置为 true；2.正常更新js脚本，没有报错；3.存在失效任务；4.crontab.list存在并且不为空
## $1：失效任务清单文件路径，$2：jd/jd
del_cron() {
    local list_drop=$1
    local type=$2
    local detail type2 detail2
    if [ -s $list_drop ] && [ -s $list_crontab_user ]; then
        detail=$(cat $list_drop)
        [[ $type == jd ]] && type2="jd_scipts脚本"
        [[ $type == thirdpard ]] && type2="thirdpard脚本"

        echo -e "开始尝试自动删除$type2的定时任务...\n"
        for cron in $detail; do
            local tmp=$(echo $cron | perl -pe "s|/|\.|g")
            perl -i -ne "{print unless / $type $tmp( |$)/}" $list_crontab_user
        done
        crontab $list_crontab_user
        detail2=$(echo $detail | perl -pe "s| |\\\n|g")
        echo -e "成功删除失效的$type2的定时任务...\n"
        notify "删除失效任务通知" "成功删除以下失效的定时任务（$type2）：\n$detail2"
    fi
}

## 自动增加jd_scripts新的定时任务，需要：1.AutoAddCron 设置为 true；2.正常更新js脚本，没有报错；3.存在新任务；4.crontab.list存在并且不为空
## $1：新任务清单文件路径
add_cron_jd_scripts() {
    local list_add=$1
    if [[ ${AutoAddCron} == true ]] && [ -s $list_add ] && [ -s $list_crontab_user ]; then
        echo -e "开始尝试自动添加 jd_scipts 的定时任务...\n"
        local detail=$(cat $list_add)
        for cron in $detail; do
            if [[ $cron == jd_bean_sign ]]; then
                echo "4 0,9 * * * $cmd_jd $cron" >>$list_crontab_user
            else
                cat $list_crontab_jd_scripts | grep -E "\/$cron\." | perl -pe "s|(^.+)node */scripts/(j[drx]_\w+)\.js.+|\1$cmd_jd \2|" >>$list_crontab_user
                #cat $list_crontab_jd_scripts | grep -E "\/$cron\." | perl -pe "s|(^.+)node */scripts/(j[drx]_\w+)\.ts.+|\1$cmd_jd \2|" >>$list_crontab_user
            fi
        done
        exit_status=$?
    fi
}

## 自动增加自己额外的脚本的定时任务，需要：1.AutoAddThirdpardCron 设置为 true；2.正常更新js脚本，没有报错；3.存在新任务；4.crontab.list存在并且不为空
## $1：新任务清单文件路径
add_cron_thirdpard() {
    local list_add=$1
    local list_crontab_thirdpard_tmp=$dir_list_tmp/crontab_thirdpard.list

    [ -f $list_crontab_thirdpard_tmp ] && rm -f $list_crontab_thirdpard_tmp

    if [[ ${AutoAddThirdpardCron} == true ]] && [ -s $list_add ] && [ -s $list_crontab_user ]; then
        echo -e "开始尝试自动添加 thirdpard 脚本的定时任务...\n"
        local detail=$(cat $list_add)
        for file_full_path in $detail; do
            local file_name=$(echo $file_full_path | awk -F "/" '{print $NF}')
            if [ -f $file_full_path ]; then
                perl -ne "print if /.*([\d\*]*[\*-\/,\d]*[\d\*] ){4}[\d\*]*[\*-\/,\d]*[\d\*]( |,|\").*$file_name/" $file_full_path |
                    perl -pe "{
                    s|[^\d\*]*(([\d\*]*[\*-\/,\d]*[\d\*] ){4,5}[\d\*]*[\*-\/,\d]*[\d\*])( \|,\|\").*/?$file_name.*|\1 $cmd_thirdpard $file_full_path|g;
                    s|  | |g;
                    s|^[^ ]+ (([^ ]+ ){5}$cmd_thirdpard $file_full_path)|\1|;
                }" |
                    sort -u | head -1 >>$list_crontab_thirdpard_tmp
            fi
        done
        [ ! -f $list_crontab_thirdpard_tmp ] && echo "没检测到定时设置，请自行添加"
        [ -f $list_crontab_thirdpard_tmp ] && crontab_tmp="$(cat $list_crontab_thirdpard_tmp)"
        perl -i -pe "s|(# 定时区域thirdpard结束.+)|$crontab_tmp\n\1|" $list_crontab_user
        exit_status=$?
    fi

    [ -f $list_crontab_thirdpard_tmp ] && rm -f $list_crontab_thirdpard_tmp
}

## 向系统添加定时任务以及通知，$1：写入crontab.list时的exit状态，$2：新增清单文件路径，$3：jd_scripts脚本/thirdpard脚本
add_cron_notify() {
    local status_code=$1
    local list_add=$2
    local tmp=$(echo $(cat $list_add))
    local detail=$(echo $tmp | perl -pe "s| |\\\n|g")
    local type=$3
    if [[ $status_code -eq 0 ]]; then
        crontab $list_crontab_user
        echo -e "成功添加新的定时任务...\n"
        notify "新增任务通知" "成功添加新的定时任务（$type）：\n$detail"
    else
        echo -e "添加新的定时任务出错，请手动添加...\n"
        notify "新任务添加失败通知" "尝试自动添加以下新的定时任务出错，请手动添加（$type）：\n$detail"
    fi
}

## 更新 thirdpard 所有仓库
update_thirdpard_repo() {
    [[ ${#array_thirdpard_repo_url[*]} -gt 0 ]] && echo -e "--------------------------------------------------------------\n"
    for ((i = 0; i < ${#array_thirdpard_repo_url[*]}; i++)); do
        if [ -d ${array_thirdpard_repo_path[i]}/.git ]; then
            reset_romote_url ${array_thirdpard_repo_path[i]} ${array_thirdpard_repo_url[i]}
            git_pull_scripts ${array_thirdpard_repo_path[i]}
        else
            git_clone_scripts ${array_thirdpard_repo_url[i]} ${array_thirdpard_repo_path[i]} ${array_thirdpard_repo_branch[i]}
        fi
        [[ $exit_status -eq 0 ]] && echo -e "\n更新${array_thirdpard_repo_path[i]}成功...\n" || echo -e "\n更新${array_thirdpard_repo_path[i]}失败，请检查原因...\n"
    done
}

## 更新 thirdpard 所有 raw 文件
update_thirdpard_raw() {
    local rm_mark
    [[ ${#ThirdpardRawFile[*]} -gt 0 ]] && echo -e "--------------------------------------------------------------\n"
    for ((i = 0; i < ${#ThirdpardRawFile[*]}; i++)); do
        raw_file_name[$i]=$(echo ${ThirdpardRawFile[i]} | awk -F "/" '{print $NF}')
        echo -e "开始下载：${ThirdpardRawFile[i]} \n\n保存路径：$dir_raw/${raw_file_name[$i]}\n"
        wget -q --no-check-certificate -O "$dir_raw/${raw_file_name[$i]}.new" ${ThirdpardRawFile[i]}
        if [[ $? -eq 0 ]]; then
            mv "$dir_raw/${raw_file_name[$i]}.new" "$dir_raw/${raw_file_name[$i]}"
            echo -e "下载 ${raw_file_name[$i]} 成功...\n"
        else
            echo -e "下载 ${raw_file_name[$i]} 失败，保留之前正常下载的版本...\n"
            [ -f "$dir_raw/${raw_file_name[$i]}.new" ] && rm -f "$dir_raw/${raw_file_name[$i]}.new"
        fi
    done

    for file in $(ls $dir_raw); do
        rm_mark="yes"
        for ((i = 0; i < ${#raw_file_name[*]}; i++)); do
            if [[ $file == ${raw_file_name[$i]} ]]; then
                rm_mark="no"
                break
            fi
        done
        [[ $rm_mark == yes ]] && rm -f $dir_raw/$file 2>/dev/null
    done
}

#################################################################################################################################

UpdateTool() {
    fix_files

    git config --global pull.rebase false
    git config --global --unset http.proxy
    ## 导入配置文件，清除缓存
    import_config_no_check
    #IsPinValid
    ## 在日志中记录时间与路径
    echo "
--------------------------------------------------------------

系统时间：$(date "+%Y-%m-%d %H:%M:%S")

脚本根目录：$dir_root

jd_scripts目录：$dir_scripts

thirdpard脚本目录：$dir_thirdpard

--------------------------------------------------------------
"
    ## 重置仓库romote url
    #if [[ $JD_DIR ]] && [[ $ENABLE_RESET_REPO_URL == true ]]; then
    #    reset_romote_url $dir_shell $url_shell >/dev/null
    #    reset_romote_url $dir_scripts $url_scripts >/dev/null
    #fi
    
    ## 更新shell
    if [[ ! $ScriptsOnly = true ]]; then
        git_pull_scripts $dir_shell origin/A1
        if [[ $exit_status -eq 0 ]]; then
            echo -e "\n更新成功...\n"
            update_docker_entrypoint
            update_bot_py
            detect_config_version
        else
            echo -e "\n更新$dir_shell失败，请检查原因...\n"
        fi
    fi
    ## 更新scripts2
    [ -d ${dir_scripts2}/.git ] && Git_PullScripts2 || Git_CloneScripts2

    ## 更新scripts
    ## 更新前先存储package.json和githubAction.md的内容
    [ -f $dir_scripts/package.json ] && scripts_depend_old=$(cat $dir_scripts/package.json)
    [ -f $dir_scripts/githubAction.md ] && cp -f $dir_scripts/githubAction.md $list_task_action_scripts

    if [ -d ${dir_scripts}/.git ]; then
        [ -z $JD_SCRIPTS_URL ] && [[ -z $(grep $url_scripts $dir_scripts/.git/config) ]] && rm -rf $dir_scripts
        if [[ ! -z $JD_SCRIPTS_URL ]]; then
            if [[ -z $(grep $JD_SCRIPTS_URL $dir_scripts/.git/config) ]]; then
                rm -rf $dir_scripts
            fi
        fi
    else
        rm -rf $dir_scripts
    fi

    url_scripts=${JD_SCRIPTS_URL:-https://gitee.com/highdimen/clone_scripts.git}
    branch_scripts=${JD_SCRIPTS_BRANCH:-master}
    ## 更新或克隆scripts
    if [ -d $dir_scripts/.git ]; then
        git_pull_scripts $dir_scripts origin/$branch_scripts
    else
        git_clone_scripts $url_scripts $dir_scripts $branch_scripts
    fi

    if [[ $exit_status -eq 0 ]]; then
        echo -e "\n更新$dir_scripts成功...\n"

        ## npm install
        [ ! -d $dir_scripts/node_modules ] && npm_install_1 $dir_scripts
        [ -f $dir_scripts/package.json ] && scripts_depend_new=$(cat $dir_scripts/package.json)
        [[ "$scripts_depend_old" != "$scripts_depend_new" ]] && npm_install_2 $dir_scripts

        ## diff cron
        gen_list_task
        diff_cron $list_task_jd_scripts $list_task_user $list_task_add $list_task_drop

        ## 失效任务通知
        if [ -s $list_task_drop ]; then
            output_list_add_drop $list_task_drop "失效"
            [[ ${AutoDelCron} == true ]] && del_cron $list_task_drop jd
        fi

        ## 新增任务通知
        if [ -s $list_task_add ]; then
            output_list_add_drop $list_task_add "新"
            add_cron_jd_scripts $list_task_add
            [[ ${AutoAddCron} == true ]] && add_cron_notify $exit_status $list_task_add "jd_scripts脚本"
        fi

        ## 环境变量变化通知
        ## echo -e "检测环境变量清单文件 $dir_scripts/githubAction.md 是否有变化...\n"
        [ -s $dir_list_tmp/githubAction.md ] && diff $dir_list_tmp/githubAction.md $dir_scripts/githubAction.md | tee $dir_list_tmp/env.diff
        if [ -s $dir_list_tmp/env.diff ] && [[ ${EnvChangeNotify} == true ]]; then
            notify_title="检测到环境变量清单文件有变化"
            notify_content="减少的内容：\n$(grep -E '^-[^-]' $dir_list_tmp/env.diff)\n\n增加的内容：\n$(grep -E '^\+[^\+]' $dir_list_tmp/env.diff)"
            notify "$notify_title" "$notify_content"
        fi
    else
        echo -e "\n更新$dir_scripts失败，请检查原因...\n"
    fi

    ## 更新thirdpard脚本
    count_thirdpard_repo_sum
    gen_thirdpard_dir_and_path
    if [[ ${#array_thirdpard_scripts_path[*]} -gt 0 ]]; then
        make_dir $dir_raw
        update_thirdpard_repo
        update_thirdpard_raw
        gen_list_thirdpard
        diff_cron $list_thirdpard_scripts $list_thirdpard_user $list_thirdpard_add $list_thirdpard_drop

        if [ -s $list_thirdpard_drop ]; then
            output_list_add_drop $list_thirdpard_drop "失效"
            [[ ${AutoDelThirdpardCron} == true ]] && del_cron $list_thirdpard_drop thirdpard
        fi
        if [ -s $list_thirdpard_add ]; then
            output_list_add_drop $list_thirdpard_add "新"
            add_cron_thirdpard $list_thirdpard_add
            [[ ${AutoAddThirdpardCron} == true ]] && add_cron_notify $exit_status $list_thirdpard_add "thirdpard脚本"
        fi
    else
        perl -i -ne "{print unless / $cmd_thirdpard /}" $list_crontab_user
    fi

    ##使scripts2生效
    cp -f ${dir_scripts2}/jd_*.js ${dir_scripts}
    [ -f ${dir_scripts2}/ZooFaker.js ] && cp -f ${dir_scripts2}/ZooFaker.js ${dir_scripts}
    cp -f ${dir_scripts2}/sendNotify.js ${dir_scripts}

    ## 调用用户自定义的diy.sh
    if [[ ${EnableExtraShell} == true ]]; then
        if [ -f $file_diy_shell ]; then
            echo -e "--------------------------------------------------------------\n"
            . $file_diy_shell
        else
            echo -e "$file_diy_shell文件不存在，跳过执行DIY脚本...\n"
        fi
    fi

    [ -f $file_key ] && rm -rf $file_key
    [ -f $file_key_cry ] && rm -rf $file_key_cry
    [ -f $dir_root/README.md ] && rm -rf $dir_root/README.md
    [ -f $dir_root/LICENSE ] && rm -rf $dir_root/LICENSE

    AutoConfig
    fix_config
    random_update_cron
    BeanChange
    #    [ ! $ConfigCover = false ] && cp -rf $file_config_sample $file_config_user
}

## =================================================7. 执行区 =================================================

## 组合Cookie和互助码子程序，$1：要组合的内容
combine_sub() {
    local what_combine=$1
    local combined_all=""
    local tmp1 tmp2
    for ((i = 1; i <= $user_sum; i++)); do
        for num in $TempBlockCookie; do
            [[ $i -eq $num ]] && continue 2
        done
        local tmp1=$what_combine$i
        local tmp2=${!tmp1}
        case $# in
        1)
            combined_all="$combined_all&$tmp2"
            ;;
        2)
            combined_all="$combined_all&$tmp2@$2"
            ;;
        3)
            if [ $(($i % 2)) -eq 1 ]; then
                combined_all="$combined_all&$tmp2@$2"
            else
                combined_all="$combined_all&$tmp2@$3"
            fi
            ;;
        4)
            case $(($i % 3)) in
            1)
                combined_all="$combined_all&$tmp2@$2"
                ;;
            2)
                combined_all="$combined_all&$tmp2@$3"
                ;;
            0)
                combined_all="$combined_all&$tmp2@$4"
                ;;
            esac
            ;;
        esac
        #combined_all="$combined_all&$tmp2" #最新的
    done
    echo $combined_all | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||}"
}

## 正常依次运行时，组合所有账号的Cookie与互助码
combine_all() {
    #for ((i = 0; i < ${#env_name[*]}; i++)); do
    #    export ${env_name[i]}=$(combine_sub ${var_name[i]})
    #done

    export JD_COOKIE=$(combine_sub Cookie)
    ## 东东农场(jd_fruit.js)
    export FRUITSHARECODES=$(combine_sub ForOtherFruit "588e4dd7ba134ad5aa255d9b9e1a38e3@520b92a9f0c34b34a0833f6c3bb41cac@e124f1c465554bf485983257743233d3" "7363f89a9d7248ae91a439794f854614@07b3cd1495524fa2b0f768e7639eab9f")
    ## 东东萌宠(jd_pet.js)
    export PETSHARECODES=$(combine_sub ForOtherPet "MTE1NDAxNzgwMDAwMDAwMzk3NDIzODc=@MTAxODEyMjkyMDAwMDAwMDQwMTEzNzA3@MTE1NDUyMjEwMDAwMDAwNDM3NDQzMzU=@MTEzMzI0OTE0NTAwMDAwMDA0Mzc0NjgzOQ==")
    ## 种豆得豆(jd_plantBean.js)
    export PLANT_BEAN_SHARECODES=$(combine_sub ForOtherBean "olmijoxgmjutzeajdig5vec453deq25pz7msb7i@okj5ibnh3onz6mkpbt6natnj7xdxeqeg53kjbsi@7oivz2mjbmnx4cbdwoeomdbqrr6bwbgsrhybhxa" "yvppbgio53ya5quolmjz6hiwlhu6yge7i7six5y@ebxm5lgxoknqdfx75eycfx6vy5n2tuflqhuhfia")
    ## 东东工厂(jd_jdfactory.js)
    export DDFACTORY_SHARECODES=$(combine_sub ForOtherJdFactory "T0225KkcRhwZp1HXJk70k_8CfQCjVWnYaS5kRrbA@T0205KkcAVhorA6EfG6dwb9ACjVWnYaS5kRrbA@T0205KkcG1tgqh22f1-s54tXCjVWnYaS5kRrbA" "T019__l2QBYe_UneIRj9lv8CjVWnYaS5kRrbA@T0205KkcNFd5nz6dXnCV4r9gCjVWnYaS5kRrbA")
    ## 京喜工厂(jd_dreamFactory.js)
    export DREAM_FACTORY_SHARE_CODES=$(combine_sub ForOtherDreamFactory "piDVq-y7O_2SyEzi5ZxxYw==@IzYimRViEUHMiUDFhPPLOg==@ieXM8XzpopOaevcW0f1OwA==@y0k9IDhCNqQvEov0x2ugNQ==")
    ## 京东赚赚(jd_jdzz.js)
    export JDZZ_SHARECODES=$(combine_sub ForOtherJdzz "S5KkcRhwZp1HXJk70k_8CfQ@S5KkcAVhorA6EfG6dwb9A@S5KkcG1tgqh22f1-s54tX")
    ## 疯狂的Joy(jd_crazy_joy.js)
    export JDJOY_SHARECODES=$(combine_sub ForOtherJoy "N1ihLmXRx9ahdnutDzc1Vqt9zd5YaBeE@o8k-j4vfLXWhsdA5HoPq-w==@zw2aNaUUBen1acOglloXVw==")
    ## 口袋书店(jd_bookshop.js)
    export BOOKSHOP_SHARECODES=$(combine_sub ForOtherBookShop)
    ## 签到领现金(jd_cash.js)
    export JD_CASH_SHARECODES=$(combine_sub ForOtherCash "eU9Yau6yNPkm9zrVzHsb3w@eU9YLarDP6Z1rRq8njtZ@eU9YN6nLObVHriuNuA9O")
    ## 京喜农场(jd_jxnc.js)
    export JXNC_SHARECODES=$(combine_sub ForOtherJxnc)
    ## 闪购盲盒(jd_sgmh.js)
    export JDSGMH_SHARECODES=$(combine_sub ForOtherSgmh)
    ## 京喜财富岛(jd_cfd.js)
    export JDCFD_SHARECODES=$(combine_sub ForOtherCfd)
    ## 环球挑战赛(jd_global.js)
    export JDGLOBAL_SHARECODES=$(combine_sub ForOtherGlobal "MjNtTnVxbXJvMGlWTHc5Sm9kUXZ3VUM4R241aDFjblhybHhTWFYvQmZUOD0")
    ## 京东手机狂欢城(jd_carnivalcity.js)
    export JD818_SHARECODES=$(combine_sub ForOtherCarnivalcity "5443fec1-7dbc-4d92-a09b-b7eb0a01199f@8c2a0d3a-b4d7-4bbf-bccc-4e7efc18f849")

    export JDHEALTH_SHARECODES=$(combine_sub ForOtherHealth)
}

## 并发运行时，直接申明每个账号的Cookie与互助码，$1：用户Cookie编号
combine_one() {
    local user_num=$1
    local pushcontent1
    local pushcontent2
    for ((i = 0; i < ${#env_name[*]}; i++)); do
        local tmp=${var_name[i]}$user_num
        export ${env_name[i]}=${!tmp}
    done
}

## 转换JD_BEAN_SIGN_STOP_NOTIFY或JD_BEAN_SIGN_NOTIFY_SIMPLE
trans_JD_BEAN_SIGN_NOTIFY() {
    case ${NotifyBeanSign} in
    0)
        export JD_BEAN_SIGN_STOP_NOTIFY="true"
        ;;
    1)
        export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
        ;;
    2)
        export JD_BEAN_SIGN_NOTIFY_SIMPLE="false"
        ;;
    esac
}

## 转换UN_SUBSCRIBES
trans_UN_SUBSCRIBES() {
    export UN_SUBSCRIBES="${goodPageSize}\n${shopPageSize}\n${jdUnsubscribeStopGoods}\n${jdUnsubscribeStopShop}"
}

## 申明全部变量，$1：all/Cookie编号
export_all_env() {
    local type=$1
    local latest_log
    if [[ $AutoHelpOther == true ]] && [[ -d $dir_code ]]; then
        #latest_log=$(ls -r $dir_code | head -1)
        #. $dir_code/$latest_log
        latest_log=$dir_code/helpcode
        . $latest_log
    fi
    [ -f $file_config_user ] && . $file_config_user
    [[ $type == all ]] && combine_all || combine_one $type
    trans_JD_BEAN_SIGN_NOTIFY
    trans_UN_SUBSCRIBES
}

random_delay() {
    local random_delay_max=$RandomDelay
    if [[ $random_delay_max ]] && [[ $random_delay_max -gt 0 ]]; then
        local current_min=$(date "+%-M")
        if [[ $current_min -gt 2 && $current_min -lt 30 ]] || [[ $current_min -gt 31 && $current_min -lt 59 ]]; then
            delay_second=$(($(gen_random_num $random_delay_max) + 1))
            echo -e "\n命令未添加 \"now\"，随机延迟 $delay_second 秒后再执行任务，如需立即终止，请按 CTRL+C...\n"
            sleep $delay_second
        fi
    fi
}

## scripts目录下所有可运行脚本数组
gen_array_scripts() {
    local dir_current=$(pwd)
    local i=0
    cd $dir_scripts
    for file in $(ls); do
        if [ -f $file ] && [[ $(grep "new Env" $file) ]] && [[ $file == *.js && $file != sendNotify.js && $file != JD_extra_cookie.js ]]; then
            array_scripts[i]=$file
            array_scripts_name[i]=$(grep "new Env" $file | awk -F "'|\"" '{print $2}' | head -1)
            [[ -z ${array_scripts_name[i]} ]] && array_scripts_name[i]="<未识别出活动名称>"
            let i++
        fi
    done
    cd $dir_current
}

## 使用说明
usage() {
    define_cmd
    gen_array_scripts
    echo
    echo -e "$cmd_jd jd_xxx          # 正常运行jd_xxx脚本"
    echo -e "$cmd_jd jd_xxx now      # 立即运行jd_xxx脚本"
    echo -e "$cmd_jd jd_xxx fast     # 急速运行jd_xxx脚本"
    echo -e "$cmd_jd jd_xxx 数字     # 第几账号单独运行jd_xxx脚本"
    echo -e "$cmd_jd runall1         # 运行运行所有脚本，耗时1小时"
    echo -e "$cmd_jd runall2         # 较快运行所有脚本，耗时10分钟"
    echo -e "$cmd_jd runall3         # 急速运行所有脚本，耗时3分钟，新手勿试"
    echo -e "$cmd_jd panelon         # 开启控制面板"
    echo -e "$cmd_jd paneloff        # 关闭控制面板以及挂机程序"
    echo -e "$cmd_jd myhelp          # 手动更新互助码，在log/helpcode下"
    echo -e "$cmd_jd clean           # 手动清理日记"
    echo -e "$cmd_jd hangup          # 重启挂机程序"
    echo -e "$cmd_jd update          # 更新最新版本"
    echo
    echo -e "\n当前scripts目录下有以下脚本可以运行："
    for ((i = 0; i < ${#array_scripts[*]}; i++)); do
        echo -e "$(($i + 1)).${array_scripts_name[i]}：${array_scripts[i]}"
    done
}

## run nohup，$1：文件名，不含路径，带后缀
run_nohup() {
    local file_name=$1
    nohup node $file_name &>$log_path &
}

## 查找脚本路径与准确的文件名，$1：脚本传入的参数，输出的file_name不带后缀.js
find_file_and_path() {
    local para=$1
    local file_name_tmp1=$(echo $para | perl -pe "s|\.js||")
    local file_name_tmp2=$(echo $para | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
    local file_name_tmp3=$(echo $para | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
    local file_name_tmp4=$(echo $para | perl -pe "s|\.py||")
    local file_name_tmp5=$(echo $para | perl -pe "s|\.ts||")
    local seek_path="$dir_scripts $dir_scripts/backUp $dir_raw"
    file_name=""
    which_path=""

    for path in $seek_path; do
        if [ -f $path/$file_name_tmp1.js ]; then
            file_name=$file_name_tmp1
            file_name_all=$file_name_tmp1.$file_last
            which_path=$path
            break
        elif [ -f $path/$file_name_tmp2.js ]; then
            file_name=$file_name_tmp2
            file_name_all=$file_name_tmp2.$file_last
            which_path=$path
            break
        elif [ -f $path/$file_name_tmp4.py ]; then
            file_name=$file_name_tmp4
            file_name_all=$file_name_tmp4.$file_last
            which_path=$path
            change_py_path
            break
        elif [ -f $path/$file_name_tmp5.ts ]; then
            file_name=$file_name_tmp5
            file_name_all=$file_name_tmp5.$file_last
            which_path=$path
            break
        fi
    done

    if [[ -z $file_name ]] && [ -f $para ]; then
        local file_name_tmp3=$(echo $para | awk -F "/" '{print $NF}' | perl -pe "s|\.js||")
        if [[ $(grep -E "^$file_name_tmp3$" $list_task_jd_scripts) ]] && [[ $AutoCpThirdpardCron = false ]]; then
            echo -e "\njd_scripts项目存在同名文件$file_name_tmp3.js，不复制$para，直接执行$dir_scripts/$file_name_tmp3.js ...\n"
        else
            echo -e "\n复制或覆盖 $para 到 $dir_scripts 下.....开始运行...\n"
            cp -f $para $dir_scripts
        fi
        file_name=$file_name_tmp3
        file_name_all=$file_name_tmp3.$file_last
        which_path=$dir_scripts
    fi
}

## 运行自定义脚本
run_task_finish() {
    if [[ $EnableTaskFinishShell == true ]]; then
        echo -e "\n--------------------------------------------------------------\n"
        if [ -f $file_task_finish_shell ]; then
            echo -e "开始执行$file_task_finish_shell...\n"
            . $file_task_finish_shell
            echo -e "$file_task_finish_shell执行完毕...\n"
        else
            echo -e "$file_task_finish_shell文件不存在，跳过执行...\n"
        fi
    fi
}

## 运行挂机脚本
run_hungup() {
    local hangup_file="jd_crazy_joy_coin"
    cd $dir_scripts
    for file in $hangup_file; do
        import_config_and_check $file
        count_user_sum
        export_all_env all
        if [ ! $NodeType = nohup ] >/dev/null 2>&1; then
            pm2 stop $file.js 2>/dev/null
            pm2 flush
            pm2 start -a $file.js --watch "$dir_scripts/$file.js" --name=$file
        else
            if [[ $(ps -ef | grep "$file" | grep -v "grep") != "" ]]; then
                ps -ef | grep "$file" | grep -v "grep" | awk '{print $1}' | xargs kill -9
            fi
            make_dir $dir_log/$file
            log_time=$(date "+%Y-%m-%d-%H-%M-%S")
            log_path="$dir_log/$file/$log_time.log"
            run_nohup $file.js >/dev/null 2>&1
        fi
        echo "运行成功"
    done
}

## 运行守护脚本
run_hungup_file() {
    local hangup_file=$1
    cd $dir_scripts
    for file in $hangup_file; do
        import_config_and_check $file
        count_user_sum
        export_all_env all
        if [ ! $NodeType = nohup ] >/dev/null 2>&1; then
            pm2 stop $file.js 2>/dev/null
            pm2 flush
            pm2 start -a $file.js --watch "$dir_scripts/$file.js" --name=$file
        else
            if [[ $(ps -ef | grep "$file" | grep -v "grep") != "" ]]; then
                ps -ef | grep "$file" | grep -v "grep" | awk '{print $1}' | xargs kill -9
            fi
            make_dir $dir_log/$file
            log_time=$(date "+%Y-%m-%d-%H-%M-%S")
            log_path="$dir_log/$file/$log_time.log"
            run_nohup $file.js >/dev/null 2>&1
        fi
        echo "运行成功"
    done
}

## 一次性运行所有jd_scripts脚本
run_all_jd_scripts_1() {
    define_cmd
    if [ ! -f $list_task_jd_scripts ]; then
        cat $list_crontab_jd_scripts | grep -E "j[drx]_\w+\.js" | perl -pe "s|.+(j[drx]_\w+)\.js.+|\1|" | sort -u >$list_task_jd_scripts
    fi
    echo -e "\n==================== 开始运行所有非挂机脚本 ====================\n"
    echo -e "耗时数小时\n"
    for ((sec = 5; sec > 0; sec--)); do
        echo -e "倒计时$sec秒...\n"
        sleep 1
    done
    for file in $(cat $list_task_jd_scripts); do
        if [ $file = jd_crazy_joy_coin ]; then
            continue
        fi
        if [ $file = jd_exit ]; then
            continue
        fi
        echo -e "==================== 运行 $file.js 脚本 ====================\n"
        run_normal $file now
    done
}

## 一次性运行所有jd_scripts脚本
run_all_jd_scripts_2() {
    define_cmd
    if [ ! -f $list_task_jd_scripts ]; then
        cat $list_crontab_jd_scripts | grep -E "j[drx]_\w+\.js" | perl -pe "s|.+(j[drx]_\w+)\.js.+|\1|" | sort -u >$list_task_jd_scripts
    fi
    echo -e "\n==================== 开始运行所有非挂机脚本 ====================\n"
    echo -e "耗时20分钟\n"
    for ((sec = 5; sec > 0; sec--)); do
        echo -e "倒计时$sec秒...\n"
        sleep 1
    done
    for file in $(cat $list_task_jd_scripts); do
        if [ $file = jd_crazy_joy_coin ]; then
            continue
        fi
        if [ $file = jd_exit ]; then
            continue
        fi
        echo -e "==================== 运行 $file.js 脚本 ====================\n"
        run_concurrent $file fast
        wait
    done
}

## 一次性运行所有jd_scripts脚本
run_all_jd_scripts_3() {
    define_cmd
    if [ ! -f $list_task_jd_scripts ]; then
        cat $list_crontab_jd_scripts | grep -E "j[drx]_\w+\.js" | perl -pe "s|.+(j[drx]_\w+)\.js.+|\1|" | sort -u >$list_task_jd_scripts
    fi
    echo -e "\n==================== 开始运行所有非挂机脚本 ====================\n"
    echo -e "耗时5分钟\n"
    for ((sec = 5; sec > 0; sec--)); do
        echo -e "倒计时$sec秒...\n"
        sleep 1
    done
    for file in $(cat $list_task_jd_scripts); do
        if [ $file = jd_crazy_joy_coin ]; then
            continue
        fi
        if [ $file = jd_exit ]; then
            continue
        fi
        echo -e "==================== 运行 $file.js 脚本 ====================\n"
        run_concurrent $file fast
    done
}
## 选择python3还是node
define_program() {
    local p1=$1
    if [[ $p1 == *.js ]]; then
        which_program=node
        file_last=js
    elif [[ $p1 == *.py ]]; then
        which_program=python3
        file_last=py
    elif [[ $p1 == *.sh ]]; then
        which_program=bash
        file_last=sh
    elif [[ $p1 == *.ts ]]; then
        which_program="ts-node-transpile-only"
        file_last=ts
    else
        which_program=node
        file_last=js
    fi
}
## 正常运行单个脚本，$1：传入参数
run_normal() {
    local p=$1
    define_program "$p"
    find_file_and_path $p
    #ps -ef | grep $file_name | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
    if [[ $file_name ]] && [[ $which_path ]]; then
        import_config_and_check "$file_name"
        count_user_sum
        export_all_env all
        [[ $# -eq 1 ]] && random_delay
        log_time=$(date "+%Y-%m-%d-%H-%M-%S")
        log_path="$dir_log/$file_name/$log_time.log"
        make_dir "$dir_log/$file_name"
        cd $which_path
        echo "执行${which_program}，路径$which_path/$file_name_all"
        [[ $which_program = node ]] && [[ $IsSecure = true ]] && echo "Secure Js" #&& SecureJs $file_name_all
        [ ${TasksTerminateTime} = 0 ] && $which_program $file_name_all 2>&1 | tee $log_path
        [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} $which_program $file_name_all 2>&1 | tee $log_path
        run_task_finish "$file_name" 2>&1 | tee -a $log_path
    else
        echo -e "\n $p 脚本不存在，请确认...\n"
        usage
    fi
}

## 并发执行，因为是并发，所以日志只能直接记录在日志文件中（日志文件以Cookie编号结尾），前台执行并发跑时不会输出日志
## 并发执行时，设定的 RandomDelay 不会生效，即所有任务立即执行
run_concurrent() {
    local p=$1
    local SameTimeUser=$3
    local SameTimeBegin=1
    local RunNum
    local SameTimeContinul
    local SameTimeLeft
    local workdir
    define_program "$p"
    find_file_and_path $p

    if [[ $file_name ]] && [[ $which_path ]]; then
        import_config_and_check "$file_name"
        count_user_sum
        make_dir $dir_log/$file_name
        log_time=$(date "+%Y-%m-%d-%H-%M-%S.%N")
        [[ $2 == oc ]] && sleep $((60 - $OverTime))

        if [[ -z $SameTimeUser ]]; then
            echo -e "\n开始并发执行，日志直接写入文件中。\n"
            for ((user_num = 1; user_num <= $user_sum; user_num++)); do
                for num in ${TempBlockCookie}; do
                    [[ $user_num -eq $num ]] && continue 2
                done
                export_all_env $user_num
                log_path="$dir_log/$file_name/${log_time}_${user_num}.log"
                cd $which_path
                [ ${TasksTerminateTime} = 0 ] && $which_program $file_name_all &>$log_path &
                [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} $which_program $file_name_all &>$log_path &
            done
        else
            RunNum=$((1 + $user_sum / $SameTimeUser))
            SameTimeContinul=$SameTimeUser
            SameTimeLeft=$(($user_sum % $SameTimeUser))
            workdir=$(pwd)
            echo -e "\n步进并发模式，每次并发数为$SameTimeUser\n"
            echo -e "用户数为$user_sum，所以大循环为$RunNum次，最后一次内循环$SameTimeLeft次\n"
            for ((i = 1; i <= $RunNum; i++)); do
                if [[ $i -eq $RunNum ]]; then
                    echo -e "这是最后$SameTimeBegin到第$SameTimeContinul\n"
                    SameTimeContinul=$((SameTimeBegin + SameTimeLeft - 1))
                    for ((user_num = SameTimeBegin; user_num <= SameTimeContinul; user_num++)); do
                        echo -e "$user_num\n"
                        #for num in ${TempBlockCookie}; do
                        #    [[ $user_num -eq $num ]] && continue 2
                        #done
                        cd $workdir
                        export_all_env $user_num
                        log_path="$dir_log/$file_name/${log_time}_${user_num}.log"
                        cd $which_path
                        [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} $which_program $file_name_all &>$log_path &
                        [ ${TasksTerminateTime} = 0 ] && $which_program $file_name_all &>$log_path &
                    done
                    echo "完成"
                else
                    echo -e "$i这是第$SameTimeBegin到第$SameTimeContinul\n"
                    for ((user_num = SameTimeBegin; user_num <= SameTimeContinul; user_num++)); do
                        echo -e "$user_num\n"
                        #for num in ${TempBlockCookie}; do
                        #    [[ $user_num -eq $num ]] && continue 2
                        #done
                        cd $workdir
                        export_all_env $user_num
                        log_path="$dir_log/$file_name/${log_time}_${user_num}.log"
                        cd $which_path
                        [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} $which_program $file_name_all &>$log_path &
                        [ ${TasksTerminateTime} = 0 ] && $which_program $file_name_all &>$log_path &
                    done
                    wait
                    echo "完成"
                    SameTimeBegin=$((SameTimeUser + SameTimeBegin))
                    SameTimeContinul=$((SameTimeUser + SameTimeBegin - 1))
                fi
            done
        fi
    else
        echo -e "\n $p 脚本不存在，请确认...\n"
        usage
    fi
}
## 并发执行，因为是并发，所以日志只能直接记录在日志文件中（日志文件以Cookie编号结尾），前台执行并发跑时不会输出日志
## 并发执行时，设定的 RandomDelay 不会生效，即所有任务立即执行
run_concurrent2() {
    local p=$1
    local BeginNum=$3
    local EndNum=$4

    define_program "$p"
    find_file_and_path $p

    if [[ $file_name ]] && [[ $which_path ]]; then
        import_config_and_check "$file_name"
        count_user_sum
        make_dir $dir_log/$file_name
        log_time=$(date "+%Y-%m-%d-%H-%M-%S.%N")
        [[ $2 == oc ]] && sleep $((60 - $OverTime))

        echo -e "\n开始并发执行，日志直接写入文件中。\n"
        for ((user_num = BeginNum; user_num <= EndNum; user_num++)); do
            for num in ${TempBlockCookie}; do
                [[ $user_num -eq $num ]] && continue 2
            done
            export_all_env $user_num
            log_path="$dir_log/$file_name/${log_time}_${user_num}.log"
            cd $which_path
            [ ${TasksTerminateTime} = 0 ] && $which_program $file_name.js &>$log_path &
            [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} node $file_name.js &>$log_path &
        done
    else
        echo -e "\n $p 脚本不存在，请确认...\n"
        usage
    fi
}
## 指定只运行某一个Cookie
run_specify() {
    local p=$1
    local ck_num=$2
    define_program "$p"
    find_file_and_path $p
    if [[ $file_name ]] && [[ $which_path ]]; then
        import_config_and_check "$file_name"
        count_user_sum
        export_all_env $ck_num
        make_dir $dir_log/$file_name
        log_time=$(date "+%Y-%m-%d-%H-%M-%S")
        log_path="$dir_log/$file_name/${log_time}_${ck_num}.log"
        cd $which_path
        node $file_name.js 2>&1 | tee $log_path
        run_task_finish "$file_name" 2>&1 | tee -a $log_path
    else
        echo -e "\n $p 脚本不存在，请确认...\n"
        usage
    fi
}

detect_system
link_shell
define_cmd
#detect_software

#[ -f $file_cookie ] && IsPinValid
## 命令检测
case $# in
0)
    echo
    usage
    ;;
1)
    case $1 in
    hangup)
        run_hungup
        ;;
    runall1)
        run_all_jd_scripts_1
        ;;
    runall2)
        run_all_jd_scripts_2
        ;;
    runall3)
        run_all_jd_scripts_3
        ;;
    clean)
        CleanLog
        ;;
    mybean)
        BeanChange
        ;;
    myhelp)
        GenHelp
        ;;
    update)
        UpdateTool
        ;;
    panelon)
        PanelOn
        ;;
    paneloff)
        PanelOff &
        ;;
    resetpwd)
        Reset_Pwd
        ;;
    *)
        run_normal $1
        ;;
    esac
    ;;
2)
    case $2 in
    now)
        run_normal $1 $2
        ;;
    fast)
        run_concurrent $1 $2
        ;;
    oc)
        run_concurrent $1 $2
        ;;
    [1-9] | [1-9][0-9] | [1-9][0-9][0-9])
        run_specify $1 $2
        ;;
    test715)
        run_normaltest $1 $2
        ;;
    *)
        echo -e "\n命令输入错误...\n"
        usage
        ;;
    esac
    ;;
3)
    case $2 in
    test)
        run_concurrent $1 $2 $3
        ;;
    esac
    ;;
4)
    case $2 in
    sec)
        run_concurrent2 $1 $2 $3 $4
        ;;
    esac
    ;;
*)
    echo -e "\n命令输入错误...\n"
    usage
    ;;
esac

echo "您的操作系统为：$SYSTEM 架构：$SYSTEMTYPE"
