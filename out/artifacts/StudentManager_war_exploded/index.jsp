<%--
  Created by IntelliJ IDEA.
  User: Tnze
  Date: 2020/6/5
  Time: 上午 01:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>学生信息管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <style>
        html, body, #app, .el-row {
            height: 100%;
            margin: 0;
        }

        .el-header, .el-footer {
            color: #333;
            line-height: 60px;
            border-bottom: 1px solid #dcdfe6;
            font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
        }

        .student-item-expand {
            font-size: 0;
        }

        .student-item-expand label {
            width: 90px;
            color: #99a9bf;
        }

        .student-item-expand .el-form-item {
            margin-right: 0;
            margin-bottom: 0;
            width: 50%;
        }
    </style>
</head>
<body>
<div id="app">
    <el-dialog
            title="修改密码"
            :visible.sync="change_password_visible">
        <el-form ref="change_password_form" :model="change_password_form" :rules="change_password_form_rules">
            <el-form-item prop="password">
                <el-input v-model="change_password_form.password" placeholder="旧密码" show-password></el-input>
            </el-form-item>
            <el-form-item prop="new_password">
                <el-input v-model="change_password_form.new_password" placeholder="新密码" show-password></el-input>
            </el-form-item>
            <el-form-item prop="check_new_password">
                <el-input v-model="change_password_form.check_new_password" placeholder="再次输入新密码"
                          show-password></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
    		<el-button @click="change_password_visible = false">取 消</el-button>
    		<el-button type="primary" @click="change_password">确 定</el-button>
  		</span>
    </el-dialog>
    <el-dialog :title="edit_info_form.title" :visible.sync="edit_info_form.visible">
        <el-form ref="editor" :model="edit_info_form.student" label-width="80px">
            <el-form-item label="学号">
                <el-input v-model="edit_info_form.student.id"></el-input>
            </el-form-item>
        </el-form>
    </el-dialog>
    <el-container>
        <el-header style="text-align: right">
            <span style="float: left; font-size: 20px;">学生信息管理系统</span>

            <el-dropdown @command="account_profile">
                <span><%= session.getAttribute("Username") %>
                <i class="el-icon-caret-bottom" style="margin-right: 15px"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item command="change-password">修改密码</el-dropdown-item>
                    <el-dropdown-item command="sign-out">注销</el-dropdown-item>
                </el-dropdown-menu>
            </el-dropdown>

        </el-header>
        <el-main>
            <el-row :gutter="10">
                <el-col>
                    <el-table :data="tableData" :default-sort="{prop: 'id', order: 'ascending'}" style="width: 100%">
                        <el-table-column type="expand">
                            <template slot-scope="props">
                                <el-form label-position="left" inline class="student-item-expand">
                                    <el-form-item label="学号">
                                        <span>{{ props.row.id }}</span>
                                    </el-form-item>
                                    <el-form-item label="姓名">
                                        <span>{{ props.row.name }}</span>
                                    </el-form-item>
                                    <el-form-item label="性别">
                                        <span>{{ props.row.gender }}</span>
                                    </el-form-item>
                                    <el-form-item label="出生日期">
                                        <span>{{ props.row.birthday }}</span>
                                    </el-form-item>
                                    <el-form-item label="住址">
                                        <span>{{ props.row.address }}</span>
                                    </el-form-item>
                                    <el-form-item label="QQ">
                                        <span>{{ props.row.qq }}</span>
                                    </el-form-item>
                                    <el-form-item label="手机">
                                        <span>{{ props.row.phone }}</span>
                                    </el-form-item>
                                    <el-form-item label="照片">
                                        <el-image :src="'photo/?id='+props.row.id"></el-image>
                                    </el-form-item>
                                </el-form>
                                <el-button size="mini" @click="edit_student(props.row)">Edit
                                </el-button>
                                <el-button size="mini" type="danger" @click="delete_student(props.row)">Delete
                                </el-button>
                            </template>
                        </el-table-column>
                        <el-table-column
                                sortable
                                prop="id"
                                label="学号">
                        </el-table-column>
                        <el-table-column
                                sortable
                                prop="name"
                                label="姓名">
                        </el-table-column>
                        <el-table-column
                                sortable
                                prop="gender"
                                label="性别">
                        </el-table-column>
                    </el-table>
                </el-col>
            </el-row>
        </el-main>
    </el-container>
</div>
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script>
    function obj_to_urlsp(data) {
        let form = new URLSearchParams();
        for (let it in data)
            if (data.hasOwnProperty(it))
                form.append(it, data[it])
        return form
    }

    let vm = new Vue({
        el: '#app',
        data() {
            let validPswd2 = (rule, value, callback) => {
                if (this.change_password_form.new_password !== value)
                    callback(new Error('两次输入密码不一致！'));
                else callback();
            };
            return {
                tableData: [],
                change_password_form: {
                    password: '',
                    new_password: '',
                    check_new_password: ''
                },
                edit_info_form: {
                    student: {id:'',name:'',gender:''},
                    title: '编辑学生信息',
                    visible: false,
                },
                change_password_form_rules: {
                    password: [{required: true, message: '请输入旧密码'}],
                    new_password: [{required: true, message: '请输入新密码'}],
                    check_new_password: [
                        {required: true, message: '请再次输入新密码'},
                        {validator: validPswd2, trigger: 'blur'}
                    ]
                },
                change_password_visible: false
            }
        },
        methods: {
            account_profile: function (cmd) {
                switch (cmd) {
                    case 'change-password':
                        this.change_password_visible = true;
                        break;
                    case 'sign-out':
                        window.location = "logout";
                        break;
                }
            },
            change_password: function () {
                this.$refs.change_password_form.validate((ok, faild) => {
                    if (!ok) return;
                    let change_pswd_form = new URLSearchParams();
                    change_pswd_form.append('pswd', this.change_password_form.password)
                    change_pswd_form.append('pswd_new', this.change_password_form.new_password)
                    axios({
                        url: 'change_pswd',
                        method: 'post',
                        data: change_pswd_form
                    }).then(() => {
                        vm.$notify({type: 'success', title: '密码修改成功'});
                        this.change_password_visible = false// 关闭对话框
                    }).catch((error) =>
                        vm.$notify.error({
                            title: '修改密码失败',
                            message: error.response ? error.response.data : '登录失败',
                            duration: 0
                        })
                    );
                })
            },
            delete_student: function (stu) {
                this.$confirm('此操作将删除学生' + stu.name + ', 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    axios({
                        url: 'manager',
                        method: 'post',
                        transformRequest: [obj_to_urlsp],
                        transformResponse: [(data) => JSON.parse(data)],
                        data: {action: 'delete', student: stu.id}
                    }).then((resp) => {
                        if (resp.data.err)
                            vm.$notify.error({title: '错误', message: resp.data.err, duration: 0});
                        else this.update_list();
                        this.$message({type: 'success', message: '删除成功!'})
                    }).catch((error) => {
                        vm.$notify.error({
                            title: '错误', duration: 0,
                            message: error.response.err ? error.response.err : '查询失败'
                        });
                    });
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '删除操作已被用户取消'
                    });
                });
            },
            edit_student: function (stu) {
                this.edit_info_form.student = stu;
                this.edit_info_form.visible = true;
            },
            update_list: function () {
                axios({
                    url: 'manager',
                    method: 'post',
                    transformRequest: [obj_to_urlsp],
                    transformResponse: [(data) => JSON.parse(data)],
                    data: {action: 'list'}
                }).then((resp) => {
                    if (resp.data.err)
                        vm.$notify.error({title: '错误', message: resp.data.err, duration: 0});
                    else this.tableData = resp.data.list;
                }).catch((error) => {
                    vm.$notify.error({
                        title: '错误', duration: 0,
                        message: error.response.err ? error.response.err : '查询失败'
                    });
                });
            }
        },
        mounted() {
            this.update_list();
        }
    })
</script>
</body>
</html>