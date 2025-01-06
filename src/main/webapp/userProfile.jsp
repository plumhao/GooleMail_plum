<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="en_US"/>
<html lang="en">
<style>
    /* 头像样式 */
    #avatar {
        width: 130px;
        height: 130px;
        margin: 0 auto;
        position: relative;
        margin-bottom: 20px;
    }

    #avatar img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        box-shadow: 0 0 10px #555;
        cursor: pointer;
    }

    #avatar #file {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        position: absolute;
        opacity: 0;
    }
</style>
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Profile</title>
    <link rel="stylesheet" href="./bootstrap-5.3.0-alpha1-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="./css/Login.css"/>
    <script src="./js/jquery-3.7.0.js"></script>
    <script src="./bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
</head>
<body style="background: url(img/02.jpg) ">
<div class="modal modal-signin position-static d-block py-5" tabindex="-1" role="dialog" id="modalUserProfile">
    <div class="modal-dialog" id="user_profile_body" role="document">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header p-5 pb-4 border-bottom-0">
                <h3 class="h3 mb-3 fw-normal">Your profile info in Google services</h3>
            </div>

            <div class="modal-body p-5 pt-0">
                <!-- form表单 -->
                <form id="userProfileForm" action="" method="post" enctype="multipart/form-data">
                    <div id="avatar" class="mb-3">
                        <input type="file" id="file">
                        <img src="http://localhost:8080/GoogleMail/${user.avatarPath}" title="请上传头像">

                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control rounded-3" id="username" name="username"
                               placeholder="Username" value="${user.username}"/>
                        <label for="username">Enter your username</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="hidden" class="form-control rounded-3" id="email" name="email"
                               placeholder="Email" value="${user.email}" readonly/>
                        <label for="email">Email</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="date" class="form-control rounded-3" id="birthday" name="birthday"
                               placeholder="Birthday" value="${user.birthday}"/>
                        <label for="birthday">Enter your birthday</label>
                    </div>
                    <div class="form-floating mb-3">
                        <select class="form-control rounded-3" id="gender" name="gender">
                            <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                            <option value="Rather not say" ${user.gender == 'Rather not say' ? 'selected' : ''}>Rather
                                not say
                            </option>
                        </select>
                        <label for="gender">Enter your gender</label>
                    </div>

                    <div id="success" class="text-success"></div>
                    <div id="error" class="text-danger"></div>

                    <button class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" type="submit">Save Changes</button>
                </form>
                <button class="w-100 mb-2 btn btn-lg rounded-3 btn-secondary" id="cancelBtn">Cancel</button>
            </div>
        </div>
    </div>
</div>


<script>
    // 检查用户登录状态
    function checkUserLoggedIn() {
        $.ajax({
            url: 'http://localhost:8080/GoogleMail/user?model=CheckLoginServlet', // 后端处理检查登录状态的接口URL
            type: 'GET',
            dataType: 'json',

            success: function (response) {
                if (response.loggedIn) {
                    // 用户已登录，继续加载home.html页面内容
                } else {
                    // 用户未登录，重定向到登录页面
                    window.location.href = 'Login.jsp';
                }
            },
            error: function (error) {
                // 发生错误
                console.log('An error occurred while checking login status.');
            },
        });
    }

    $(document).ready(function () {
        checkUserLoggedIn();


        // 取消按钮点击事件处理程序
        $('#cancelBtn').click(function () {
            window.location.href = 'home.jsp';
        });

        // 显示头像时触发文件选择框
        $('#avatarDisplay').click(function () {
            $('#avatar').click();
        });


        // 图片上传的功能
        //点击图片文件触发事件-图片被更改时
        $("#file").change(function () {

            var files = $("#file")[0].files;//得到上传图片文件
            if (files.length <= 0) {
                alert("请选择图片")
                return;
            }
            var fd = new FormData();
            fd.append("avater", files[0]);//把选择的第一张图片封装在formData对象中，用于请求时传输这个对象数据到服务器
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/user?model=UploadAvatarServlet',
                data: fd, //传输给服务器的数据
                method: "POST", //请求方式为post
                dataType: "json",
                processData: false,
                contentType: false,
                success: function (data) {
                    console.log(data);
                    if (data.success) {
                        //为img的src属性重新赋值为新图片地址
                        $("#avatar img").attr("src", "http://localhost:8080/GoogleMail/" + data.data);
                        $("#hidden-avatar").val(data.data)//修改头像隐藏域的值
                    } else {
                        alert(data.message);
                    }

                }
            })
        });


        // 更新用户信息
        $('#userProfileForm').submit(function (e) {
            e.preventDefault();
            var email = $('#email').val().trim();
            var username = $('#username').val().trim();
            var birthday = $('#birthday').val().trim();
            var gender = $('#gender').val();

            // 使用 AJAX 发送请求到后端
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/user?model=UpdateProfileServlet',
                type: 'POST',
                data: {
                    email: email,
                    username: username,
                    birthday: birthday,
                    gender: gender,
                },
                success: function (response) {
                    if (response.success) {
                        $('#error').text('');
                        $('#success').text('个人资料更新成功。');
                        setTimeout(function () {
                            window.location.href = 'home.jsp';
                        }, 1500);
                    } else {
                        $('#success').text('');
                        $('#error').text(response.message);
                    }
                },
                error: function (error) {
                    $('#error').text('更新个人资料时发生错误。');
                    console.log(error);
                }
            });
        });
    });
</script>
</body>
</html>
