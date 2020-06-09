<%--
  Created by IntelliJ IDEA.
  User: Tnze
  Date: 2020/6/5
  Time: 上午 12:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<% if (session.getAttribute("ID") != null) response.sendRedirect("index.jsp"); %>
<html>
<head>
    <title>登录-学生信息管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <style>
        html, body, #app, .el-row {
            height: 100%;
            margin: 0;
        }
    </style>
</head>
<body>
<script type="text/x-template" id="sign-in-template">
    <el-card class="box-card">
        <div slot="header" class="clearfix">
            <span>登录系统</span>
            <el-button
                    style="float: right; padding: 3px 0" type="text"
                    v-on:click="$emit('click_switch')">注册
            </el-button>
        </div>
        <transition name="el-fade-in">
            <el-alert v-show="fail_msg" :title="fail_msg" type="error"
                      @close="close_alert" center show-icon></el-alert>
        </transition>
        <el-form ref="form" :rules="rules" :model="login_data">
            <el-form-item prop="username">
                <el-input v-model="login_data.username" placeholder="用户名" autofocus></el-input>
            </el-form-item>
            <el-form-item prop="password">
                <el-input v-model="login_data.password"
                          placeholder="密码" @keyup.enter.native="sign_in" show-password></el-input>
            </el-form-item>
            <el-button type="primary" @click="sign_in">登入</el-button>
        </el-form>
    </el-card>
</script>
<script type="text/x-template" id="sign-up-template">
    <el-card class="box-card">
        <div slot="header" class="clearfix">
            <span>注册账号</span>
            <el-button
                    style="float: right; padding: 3px 0" type="text"
                    v-on:click="$emit('click_switch')">登录
            </el-button>
        </div>
        <transition name="el-fade-in">
            <el-alert v-show="fail_msg" :title="fail_msg" type="error"
                      @close="close_alert" center show-icon></el-alert>
        </transition>
        <el-form ref="form" :rules="rules" :model="signup_data">
            <el-form-item prop="username">
                <el-input v-model="signup_data.username" placeholder="用户名"></el-input>
            </el-form-item>
            <el-form-item prop="password">
                <el-input v-model="signup_data.password" placeholder="密码" show-password></el-input>
            </el-form-item>
            <el-form-item prop="re_password">
                <el-input v-model="signup_data.re_password" placeholder="再次输入密码" show-password></el-input>
            </el-form-item>
            <el-button type="primary" @click="sign_up">注册</el-button>
        </el-form>
    </el-card>
</script>
<div id="app">
    <el-row type="flex" justify="center" align="middle">
        <el-col :xs="22" :sm="12" :md="6">
            <el-collapse-transition>
                <keep-alive>
                    <component v-bind:is="current_tab" @click_switch="click_switch"></component>
                </keep-alive>
            </el-collapse-transition>
        </el-col>
    </el-row>
</div>
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script>
    Vue.component('sign-in-card', {
        template: '#sign-in-template',
        data: function () {
            return {
                fail_msg: '',
                login_data: {
                    username: '',
                    password: '',
                },
                rules: {
                    username: [{required: true, message: '请输入用户名'}],
                    password: [{required: true, message: '请输入密码'}]
                }
            }
        },
        methods: {
            sign_in: function () {
                this.$refs.form.validate((ok, faild) => {
                    if (!ok) return;
                    let login_form = new URLSearchParams();
                    login_form.append('user', this.login_data.username)
                    login_form.append('pswd', this.login_data.password)
                    axios.post('login', login_form).then((resp) => {
                        if (resp.status === 204) window.location = 'index.jsp';
                        else this.fail_msg = '登录失败';
                    }).catch((error) => {
                        this.fail_msg = error.response ? error.response.data : '登录失败';
                    })
                });
            },
            close_alert: function () {
                this.fail_msg = '';
            }
        }
    })
    Vue.component('sign-up-card', {
        template: '#sign-up-template',
        data: function () {
            let validPswd2 = (rule, value, callback) => {
                if (this.signup_data.password !== value)
                    callback(new Error('两次输入密码不一致！'));
                else callback();
            };
            return {
                fail_msg: '',
                signup_data: {
                    username: '',
                    password: '',
                    re_password: ''
                },
                rules: {
                    username: [{required: true, message: '请输入用户名'}],
                    password: [{required: true, message: '请输入密码'}],
                    re_password: [
                        {required: true, message: '请再次输入密码'},
                        {validator: validPswd2, trigger: 'blur'}
                    ]
                }
            }
        },
        methods: {
            sign_up: function () {
                this.$refs.form.validate((ok, faild) => {
                    if (!ok) return;
                    let login_form = new URLSearchParams();
                    login_form.append('user', this.signup_data.username)
                    login_form.append('pswd', this.signup_data.password)
                    axios.post('signup', login_form).then((resp) => {
                        if (resp.status === 204) window.location = 'index.jsp';
                        else this.fail_msg = '登录失败';
                    }).catch((error) => {
                        this.fail_msg = error.response ? error.response.data : '登录失败';
                    })
                });
            },
            close_alert: function () {
                this.fail_msg = '';
            }
        }
    })
    let vm = new Vue({
        el: '#app',
        data: {
            current_tab: "sign-in-card"
        },
        methods: {
            click_switch: function () {
                this.current_tab = this.current_tab === 'sign-in-card' ? 'sign-up-card' : 'sign-in-card'
            }
        }
    })
</script>
</body>
</html>