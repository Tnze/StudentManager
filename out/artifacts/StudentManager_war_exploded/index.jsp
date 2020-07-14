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

        .avatar-uploader .el-upload {
            border: 1px dashed #d9d9d9;
            border-radius: 6px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .avatar-uploader .el-upload:hover {
            border-color: #409EFF;
        }

        .avatar-uploader-icon {
            font-size: 28px;
            color: #8c939d;
            width: 178px;
            height: 178px;
            line-height: 178px;
            text-align: center;
        }

        .avatar {
            width: 178px;
            height: 178px;
            display: block;
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
        <el-form ref="editor" :model="edit_info_form.student" :rules="edit_info_form_rules" label-width="80px">
            <el-form-item label="学号">
                <el-input v-model="edit_info_form.student.id"></el-input>
            </el-form-item>
            <el-form-item label="姓名">
                <el-input v-model="edit_info_form.student.name"></el-input>
            </el-form-item>
            <el-form-item label="性别">
                <el-radio v-model="edit_info_form.student.gender" :label="0">未知</el-radio>
                <el-radio v-model="edit_info_form.student.gender" :label="1">男</el-radio>
                <el-radio v-model="edit_info_form.student.gender" :label="2">女</el-radio>
            </el-form-item>
            <el-form-item label="生日">
                <el-date-picker
                        v-model="edit_info_form.student.birthday"
                        type="date" format="yyyy 年 MM 月 dd 日"
                        value-format="timestamp"
                        placeholder="选择日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="地址">
                <el-input
                        type="textarea"
                        autosize
                        v-model="edit_info_form.student.address">
                </el-input>
            </el-form-item>
            <el-form-item label="QQ" prop="qq">
                <el-input v-model="edit_info_form.student.qq"></el-input>
            </el-form-item>
            <el-form-item label="手机">
                <el-input v-model="edit_info_form.student.phone"></el-input>
            </el-form-item>
        </el-form>
        <el-button @click="edit_info_form.visible = false">取 消</el-button>
        <el-button type="primary" @click="edit_student_confirmed">确 定</el-button>
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
                    <el-table
                            :data="filter_formData"
                            :default-sort="{prop: 'id', order: 'ascending'}" style="width: 100%">
                        <el-table-column type="expand" width="80">
                            <template slot="header" slot-scope="scope">
                                <el-button slot="append" type="primary" size="mini" icon="el-icon-plus"
                                           @click="add_student"></el-button>
                            </template>
                            <template slot-scope="props">
                                <el-form label-position="left" inline class="student-item-expand">
                                    <el-form-item label="学号">
                                        <span>{{ props.row.id }}</span>
                                    </el-form-item>
                                    <el-form-item label="姓名">
                                        <span>{{ props.row.name }}</span>
                                    </el-form-item>
                                    <el-form-item label="性别">
                                        <span>{{ ['未知','男','女'][props.row.gender] }}</span>
                                    </el-form-item>
                                    <el-form-item label="出生日期">
                                        <span>{{ new Date(props.row.birthday).toLocaleDateString() }}</span>
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
                                        <el-upload
                                                class="avatar-uploader"
                                                action="photo"
                                                :data="{id:props.row.id}"
                                                :show-file-list="false">
                                            <el-image class="avatar" :src="'photo/?id='+props.row.id"></el-image>
                                        </el-upload>
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
                                prop="phone"
                                label="手机">
                        </el-table-column>
                        <el-table-column align="right">
                            <template slot="header" slot-scope="scope">
                                <el-button size="mini" @click="update_list" class="el-icon-refresh"></el-button>
                            </template>
                        </el-table-column>
                        <el-table-column
                                align="right">
                            <template slot="header" slot-scope="scope">
                                <el-input
                                        v-model="search_tableData"
                                        size="mini"
                                        placeholder="输入关键字搜索"></el-input>
                            </template>
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
    axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8';

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
                search_tableData: '',
                tableData: [],
                change_password_form: {
                    password: '',
                    new_password: '',
                    check_new_password: ''
                },
                edit_info_form: {
                    student: {},
                    method: '',
                    id: undefined,
                    title: '',
                    visible: false,
                },
                edit_info_form_rules: {

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
        computed: {
            // 计算属性的 getter
            filter_formData: function () {
                let search = this.search_tableData;
                return this.tableData.filter(data =>
                    !this.search_tableData ||
                    data.id.includes(search) ||                               // 学号
                    data.name.toLowerCase().includes(search.toLowerCase()) || // 姓名
                    data.phone.includes(search)                               // 手机
                );
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
                    axios({
                        url: 'change_pswd',
                        method: 'post',
                        transformRequest: [obj_to_urlsp],
                        data: {
                            pswd: this.change_password_form.password,
                            pswd_new: this.change_password_form.new_password
                        }
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
            add_student: function () {
                this.edit_info_form.title = '添加学生信息';
                this.edit_info_form.method = 'add';
                this.edit_info_form.student = {};
                this.edit_info_form.id = '';
                this.edit_info_form.visible = true;
            },
            edit_student: function (stu) {
                this.edit_info_form.title = '编辑学生信息';
                this.edit_info_form.method = 'update';
                this.edit_info_form.student = {
                    id: stu.id, name: stu.name, gender: stu.gender,
                    birthday: stu.birthday, address: stu.address,
                    qq: stu.qq, phone: stu.phone,
                };
                this.edit_info_form.id = stu.id;
                this.edit_info_form.visible = true;
            },
            edit_student_confirmed: function () {
                this.$refs.editor.validate((ok, faild) => {
                    if (!ok) return;
                    axios({
                        url: 'manager',
                        method: 'post',
                        transformRequest: [obj_to_urlsp],
                        transformResponse: [(data) => JSON.parse(data)],
                        data: {
                            action: this.edit_info_form.method,
                            id: this.edit_info_form.id,
                            data: JSON.stringify(this.edit_info_form.student)
                        }
                    }).then(() => {
                        this.update_list();
                        vm.$notify({type: 'success', title: '更新成功'});
                        this.edit_info_form.visible = false;
                    }).catch((error) =>
                        vm.$notify.error({
                            title: '失败',
                            message: error.response ? error.response.data.err : '更新失败',
                            duration: 0
                        })
                    );
                })
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