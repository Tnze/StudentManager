<%--
  Created by IntelliJ IDEA.
  User: Tnze
  Date: 2020/6/5
  Time: 上午 12:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (request.getMethod().equals("POST")) {
        String user = request.getParameter("user");
        String pswd = request.getParameter("pswd");
        response.setContentType("application/json");
    } else {
%>
<html>
<head>
    <title>登录-学生信息管理系统</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <style>
        html, body, #app, .el-row {
            height: 100%;
            margin: 0;
        }
    </style>
</head>
<body>
<div id="app">
    <el-row type="flex" justify="center" align="middle">
        <el-col :xs="22" :sm="8" :md="6">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>登录系统</span>
                </div>
                <el-form ref="form" :rules="rules" :model="login_data">
                    <el-form-item prop="username">
                        <el-input v-model="login_data.username" placeholder="用户名"></el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input v-model="login_data.password" placeholder="密码" show-password></el-input>
                    </el-form-item>
                    <el-button type="primary" @click="login">登入</el-button>
                    <transition name="el-fade-in">
                        <el-alert v-show="login_fail" :title="login_fail" type="error"
                                  @close="close_alert" center show-icon></el-alert>
                    </transition>
                </el-form>
            </el-card>
        </el-col>
    </el-row>
</div>
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script>
    let vm = new Vue({
        el: '#app',
        data: {
            login_data: {
                username: '',
                password: '',
            },
            login_fail: '',
            rules: {
                username: [{required: true, message: '请输入用户名'}],
                password: [{required: true, message: '请输入密码'}]
            }
        },
        methods: {
            login: function () {
                let login_form = new FormData();
                login_form.append('user', this.login_data.username)
                login_form.append('pswd', this.login_data.password)
                axios.post('', login_form
                ).then(function (resp) {
                    if (resp.status === 200) window.location = '/';
                    else vm.login_fail = '登录失败';
                }).catch(function (error) {
                    vm.login_fail = '登录失败';
                })
            },

            close_alert: function () {
                this.login_fail = '';
            }
        }
    })
</script>
</body>
</html>
<% } %>