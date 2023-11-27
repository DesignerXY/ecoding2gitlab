# 执行方法：sh -x start.sh all > start.log

current_path=$(cd "$(dirname $0)";pwd)
cd $current_path

ecoding_username=ecoding用户名
ecoding_passwd=ecoding密码
git_username=gitlab用户名
git_passwd=gitlab密码
git_private_token=gitlab授权码
param=$1

start() {
  # 获取 ecoding 中所有分组，可以通过浏览器F12，复制接口 curl bash 格式
  curl 'https://xy.coding.net/api/platform/project/projects/search?page=1&pageSize=1000&groupId=990468&type=JOINED&archived=false&sort=VISIT&order=DESC' \
  -H 'authority: xy.coding.net' \
  -H 'accept: application/json' \
  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'cookie:cookie' \
  -H 'referer: https://xy.coding.net/user/projects' \
  -H 'sec-ch-ua: "Not_A Brand";v="8", "Chromium";v="120", "Microsoft Edge";v="120"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0' \
  -H 'x-xsrf-token: aa2d8857-2826-4c70-a208-44522ac6f9f0' \
  --compressed | python -m json.tool >e-groups.json

  # JSON 文件路径
  json_file="e-groups.json"

  # 使用 jq 循环遍历 list 数组的每个对象并提取所有字段
  jq -c '.data.list[]' "$json_file" | while read -r item; do
    # 提取数组对象中的字段并输出
    archived=$(echo "$item" | jq -r '.archived')
    created_at=$(echo "$item" | jq -r '.created_at')
    deleted_at=$(echo "$item" | jq -r '.deleted_at')
    description=$(echo "$item" | jq -r '.description')
    display_name=$(echo "$item" | jq -r '.display_name')
    icon=$(echo "$item" | jq -r '.icon')
    id=$(echo "$item" | jq -r '.id')
    invisible=$(echo "$item" | jq -r '.invisible')
    isDemo=$(echo "$item" | jq -r '.isDemo')
    is_member=$(echo "$item" | jq -r '.is_member')
    group_name=$(echo "$item" | jq -r '.name')
    name_pinyin=$(echo "$item" | jq -r '.name_pinyin')
    owner_user_name=$(echo "$item" | jq -r '.owner_user_name')
    pin=$(echo "$item" | jq -r '.pin')
    pmType=$(echo "$item" | jq -r '.pmType')
    project_path=$(echo "$item" | jq -r '.project_path')
    un_read_activities_count=$(echo "$item" | jq -r '.un_read_activities_count')
    updated_at=$(echo "$item" | jq -r '.updated_at')

  # gitlab 中删除对应分组。由于 restAPI 调用需要组id，懒得弄，就通过浏览器F12，复制接口 curl bash 格式
  #curl 'http://192.168.8.90/'$group_name \
  #  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  #  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  #  -H 'Cache-Control: max-age=0' \
  #  -H 'Connection: keep-alive' \
  #  -H 'Content-Type: application/x-www-form-urlencoded' \
  #  -H 'Cookie: cookie' \
  #  -H 'Origin: http://192.168.8.90' \
  #  -H 'Referer: http://192.168.8.90/groups/'$group_name'/-/edit' \
  #  -H 'Upgrade-Insecure-Requests: 1' \
  #  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0' \
  #  --data-raw '_method=delete&authenticity_token=token' \
  #  --compressed \
  #  --insecure

  # gitlab 中添加对应分组
  curl --request POST --header "PRIVATE-TOKEN: $git_private_token" \
     --header "Content-Type: application/json" \
     --data '{"path": "'$group_name'", "name": "'$display_name'", "description": "'$description'" }' \
     "http://192.168.8.90/api/v4/groups/"

    # 清空旧分组目录
    rm -rf $current_path/groups/$group_name
    mkdir -p $current_path/groups/$group_name
    cd $current_path/groups/$group_name

  # 获取 ecoding 中对应分组下所有项目，可以通过浏览器F12，复制接口 curl bash 格式
  curl 'https://xy.coding.net/api/user/xy/project/'${group_name}'/depot-group/depots?type=ALL&sort=DEFAULT&sortDirection=DESC' \
    -H 'authority: xy.coding.net' \
    -H 'accept: application/json' \
    -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
    -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
    -H 'cookie: cookie' \
    -H 'referer: https://xy.coding.net/p/'${group_name}'/repos' \
    -H 'sec-ch-ua: "Not_A Brand";v="8", "Chromium";v="120", "Microsoft Edge";v="120"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Windows"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0' \
    --compressed | python -m json.tool > e-project.json

  #获取ecoding项目中url
  ecoding_url=`cat e-project.json |jq -r '.data[].gitHttpsUrl'`
  for url in $ecoding_url
    do
expect <<EOF
  set timeout -1
  spawn git clone --mirror $url
  expect "*sername*:"
  send "$ecoding_username\r"
  expect "*assword*:"
  send "$ecoding_passwd\r"

expect off
EOF
    #将group1的项目推到gitlab中
    project=`echo $url|awk -F/ '{print $6}'`
    cd $project
    expect <<EOF
      set timeout -1
      spawn git push --mirror http://192.168.8.95/$group_name/$project
      expect "*sername*:"
      send "$git_username\r"
      expect "*assword*:"
      send "$git_passwd\r"

    expect off
EOF
    done

  done
}


delete_gitPro_protect() {
  cd $current_path

  #删除所有项目的master分支为受保护的标签,查询分页 每页200条
  curl --header "PRIVATE-TOKEN: $git_private_token" "http://192.168.8.90/api/v4/projects" |python -m json.tool > git_project.json
  project_Id=`cat git_project.json |jq -r '.[].id'`
  for id in $project_Id
  do
    echo $id
    curl --request DELETE --header "PRIVATE-TOKEN: $git_private_token" "http://192.168.8.90/api/v4/projects/$id/protected_branches/master"
  done
}

# 可进一步完善，如：可传入组名，只迁移对应组名项目仓库
#if [ $# == 0 ]; then
#  echo "退出!传入的参数不能为空:"
#fi
start
delete_gitPro_protect