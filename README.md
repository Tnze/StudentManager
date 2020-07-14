# StudentManager
学生信息管理系统，是Web课的作业……

功能：

- 账号注册、登录、注销（密码加密保存）
- 支持重置密码
- 学生信息管理（添加、修改、删除）
- 照片上传、保存、显示

代码我是放出来了，能不能配置出来运行就随缘吧2333  
大概只是要修改META-INF/context.xml里的数据库配置

然后数据库里的表要手动建立（执行以下SQL语句即可）：

```sql
create table students
(
    Name     varchar(64) null,
    Gender   int         null comment '0:未知;1:男;2:女',
    QQ       text        null,
    Phone    text        null,
    Address  text        null,
    Photo    longblob    null,
    ID       varchar(64) not null
        primary key,
    Birthday mediumtext  null
);

create table users
(
    ID      int auto_increment
        primary key,
    User    varchar(50) null,
    Pswd    blob        null,
    PswdKey blob        null,
    constraint users_User_uindex
        unique (User)
);
```
