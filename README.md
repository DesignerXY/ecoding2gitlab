# 1. 用途：
用于将代码仓库从 e-coding 迁移至 GitLab。

# 2. 用法
## 2.1. 替换脚本中一下内容： 
- ecoding_username=ecoding用户名
- ecoding_passwd=ecoding密码
- git_username=gitlab用户名
- git_passwd=gitlab密码
- git_private_token=gitlab授权码

## 2.2. 特别说明
由于时间关系，e-coding 采用的是从网页拿接口的方式，还需自行获取后替换

## 2.3. 执行脚本
上方修改后，执行一下命令
sh -x start.sh > start.log

# 3. 可优化说明
## 3.1. e-coding 相关接口替换为官方 openAPI
## 3.2. 执行命令可传参，指定迁移组或项目
## 3.3. ...
