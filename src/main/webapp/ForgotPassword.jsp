<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="en_US"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="./bootstrap-5.3.0-alpha1-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="./css/Login.css"/>
    <script src="./js/jquery-3.7.0.js"></script>
    <script src="./bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
</head>
<body style="background: url(img/02.jpg);background-size: 100%">
<div class="modal modal-signin position-static d-block py-5" tabindex="-1" role="dialog" id="modalForgotPassword">
    <div class="modal-dialog" id="forgot_password_body" role="document">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header p-5 pb-4 border-bottom-0">
                <img class="mb-4" src="./img/google_logo3.png" alt="" width="149" height="50"/>
                <h1 class="h3 mb-3 fw-normal">Change Password</h1>
            </div>

            <div class="modal-body p-5 pt-0">
                <!-- form表单 -->
                <form id="forgotPasswordForm" action="" method="post">
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control rounded-3" id="email" name="email"
                               placeholder="name@example.com"/>
                        <label for="email">Enter your email address</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control rounded-3" id="username" name="username"
                               placeholder="Username"/>
                        <label for="username">Enter your username</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control rounded-3" id="newPassword" name="newPassword"
                               placeholder="New Password"/>
                        <label for="newPassword">Enter your new password</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control rounded-3" id="confirmNewPassword"
                               name="confirmNewPassword"
                               placeholder="Confirm New Password"/>
                        <label for="confirmNewPassword">Confirm your new password</label>
                    </div>

                    <div id="success" class="text-success"></div>
                    <div id="error" class="text-danger"></div>

                    <button class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" type="submit">Reset Password</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#forgotPasswordForm').submit(function (e) {
            e.preventDefault()
            var email = $('#email').val().trim()
            var username = $('#username').val().trim()
            var newPassword = $('#newPassword').val().trim()
            var confirmNewPassword = $('#confirmNewPassword').val().trim()

            // 表单验证
            if (email === '' || username === '' || newPassword === '' || confirmNewPassword === '') {
                $('#error').text('Please fill in all fields.')
                return
            }

            // 检查新密码和确认新密码是否一致
            if (newPassword !== confirmNewPassword) {
                $('#error').text('New password and confirm password do not match.')
                return
            }
            if (newPassword.length < 5 || newPassword.length > 15) {
                $('#error').text('Password length must be between 5 and 15 characters.');
                return;
            }

            // 使用 AJAX 发送重置密码请求到后端
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/user?model=ForgotPasswordServlet', // 后端处理重置密码请求的接口URL
                type: 'POST',
                data: {
                    email: email,
                    username: username,
                    newPassword: newPassword,
                },

                success: function (response) {
                    // 后端接口返回重置密码结果
                    if (response.success) {
                        // 重置密码请求成功，显示成功消息
                        $('#error').text('')
                        $('#success').text('Password updated successfully. Click OK to log in again!')

                        setTimeout(function () {
                            window.location.href = 'Login.jsp';
                        }, 1500);

                    } else {
                        // 重置密码请求失败，显示错误提示
                        $('#success').text('')
                        $('#error').text('Failed to send password reset instructions. Please check your email address and username.')
                    }
                },

                error: function (error) {
                    // 发生错误
                    $('#error').text('An error occurred while trying to send password reset instructions.')
                    console.log(error)
                },
            })
        })
    })
</script>
</body>
</html>
