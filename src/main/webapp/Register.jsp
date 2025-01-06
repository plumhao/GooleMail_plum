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
    <title>Register</title>
    <link rel="stylesheet" href="./bootstrap-5.3.0-alpha1-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="./css/Register.css">
    <script src="./js/jquery-3.7.0.js"></script>
    <script src="./bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>

    <script>
        $(function () {
            // 处理 "Sign up" 按钮的点击事件
            $('#registrationForm').submit(function (e) {
                e.preventDefault();

                var email = $('#email').val().trim();
                var password = $('#password').val().trim();
                var confirmPassword = $('#confirmPassword').val().trim();
                var username = $('#username').val().trim();


                // 显示错误信息并在5秒后隐藏
                function showError(message) {
                    $('#error').text(message).show();
                    setTimeout(function () {
                        $('#error').text('');
                    }, 5000);
                }

                // 表单验证
                if (email === '' || password === '' || confirmPassword === '' || username === '') {
                    showError('Please fill in all the fields.');
                    return;
                }

                if (password !== confirmPassword) {
                    showError('Passwords do not match.');
                    return;
                }

                if (password.length < 5 || password.length > 15) {
                    showError('Password length must be between 5 and 15 characters.');
                    return;
                }

                // 使用 AJAX 发送注册信息到后台
                $.ajax({
                    url: 'http://localhost:8080/GoogleMail/user?model=RegisterServlet', // 后台处理注册信息的接口URL
                    type: 'POST',
                    data: {
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword,
                        username: username,
                    },

                    success: function (response) {
                        // 注册成功，显示成功消息并跳转到登录页面
                        $('#error').text('');
                        $('#success').text(response);

                        setTimeout(function () {
                            window.location.href = 'Login.jsp';
                        }, 1500);

                    },
                    error: function (xhr, status, error) {
                        // 注册失败，显示错误消息
                        $('#success').text('');
                        $('#error').text(xhr.responseText);
                    }
                });

            });
        });
    </script>
</head>
<body style="background: url(img/02.jpg);background-size: 100%">
<div class="modal modal-signin position-static d-block py-5" tabindex="-1" role="dialog" id="modalSignin">
    <div class="modal-dialog" id="login_body" role="document">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header p-5 pb-4 border-bottom-0">
                <img class="mb-4" src="./img/google_logo3.png" alt="" width="149" height="50"/>
                <h1 class="h3 mb-3 fw-normal">Please sign up</h1>
            </div>

            <div class="modal-body p-5 pt-0">

                <!--              form表单-->
                <form id="registrationForm" action="" method="post">
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control rounded-3" id="email" placeholder="Email" required/>
                        <label>Email</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control rounded-3" id="password" placeholder="Password"
                               required/>
                        <label>Password</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control rounded-3" id="confirmPassword"
                               placeholder="Confirm Password" required/>
                        <label>Confirm Password</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control rounded-3" id="username" placeholder="Username"
                               required/>
                        <label>Username</label>
                    </div>

                    <!-- 添加错误提示和成功消息 -->
                    <div id="error" class="text-danger"></div>
                    <div id="success" class="text-success"></div>

                    <button class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" type="submit">Sign up</button>

                    <small class="text-muted">By clicking Sign up, you agree to the terms of use.</small>

                    <hr class="my-4"/>

                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
