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
    <title>Login</title>
    <link rel="stylesheet" href="./bootstrap-5.3.0-alpha1-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="./css/Login.css"/>
    <script src="./js/jquery-3.7.0.js"></script>
    <script src="./bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>
</head>
<body style="background: url(img/02.jpg);background-size: 100%">
<svg xmlns="http://www.w3.org/2000/svg" style="display: none">
    <symbol id="github" viewBox="0 0 16 16">
        <path
                d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z"
        />
    </symbol>

    <symbol id="twitter" viewBox="0 0 16 16">
        <path
                d="M5.026 15c6.038 0 9.341-5.003 9.341-9.334 0-.14 0-.282-.006-.422A6.685 6.685 0 0 0 16 3.542a6.658 6.658 0 0 1-1.889.518 3.301 3.301 0 0 0 1.447-1.817 6.533 6.533 0 0 1-2.087.793A3.286 3.286 0 0 0 7.875 6.03a9.325 9.325 0 0 1-6.767-3.429 3.289 3.289 0 0 0 1.018 4.382A3.323 3.323 0 0 1 .64 6.575v.045a3.288 3.288 0 0 0 2.632 3.218 3.203 3.203 0 0 1-.865.115 3.23 3.23 0 0 1-.614-.057 3.283 3.283 0 0 0 3.067 2.277A6.588 6.588 0 0 1 .78 13.58a6.32 6.32 0 0 1-.78-.045A9.344 9.344 0 0 0 5.026 15z"
        />
    </symbol>

    <symbol id="facebook" viewBox="0 0 16 16">
        <path
                d="M16 8.049c0-4.446-3.582-8.05-8-8.05C3.58 0-.002 3.603-.002 8.05c0 4.017 2.926 7.347 6.75 7.951v-5.625h-2.03V8.05H6.75V6.275c0-2.017 1.195-3.131 3.022-3.131.876 0 1.791.157 1.791.157v1.98h-1.009c-.993 0-1.303.621-1.303 1.258v1.51h2.218l-.354 2.326H9.25V16c3.824-.604 6.75-3.934 6.75-7.951z"
        />
    </symbol>
</svg>

<div class="modal modal-signin position-static d-block py-5" tabindex="-1" role="dialog" id="modalSignin">
    <div class="modal-dialog" id="login_body" role="document">
        <div class="modal-content rounded-4 shadow">
            <div class="modal-header p-5 pb-4 border-bottom-0">
                <img class="mb-4" src="./img/google_logo3.png" alt="" width="149" height="50"/>
                <h1 class="h3 mb-3 fw-normal">Please sign in</h1>
            </div>

            <div class="modal-body p-5 pt-0">
                <!--                form表单-->
                <form id="loginForm" action="" method="post">
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control rounded-3" id="email" autocomplete="off"
                               placeholder="name@example.com"/>
                        <label for="email">Email address</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control rounded-3" id="password" placeholder="Password"/>
                        <label for="password">Password</label>
                    </div>

                    <div class="text-center mt-3">
                        <div class="row align-items-center" id="login-reme">
                            <!-- 左边列：记住我复选框 -->
                            <div class="col">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="rememberMe"
                                           style="margin-left: -15px"/>
                                    <label class="form-check-label" for="rememberMe"
                                           style="margin-left: -58px; color: gray">Remember Me</label>
                                </div>
                            </div>

                            <!-- 右边列：忘记密码链接 -->
                            <div class="col text-end">
                                <a href="ForgotPassword.jsp">Forgot password?</a>
                            </div>
                        </div>
                    </div>

                    <!-- 添加错误提示和成功消息 -->
                    <div id="error" class="text-danger"></div>
                    <div id="success" class="text-success"></div>

                    <button class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" type="submit">Sign in</button>
                    <div class="text-center mt-3">
                        <p>Don't have an account? <a href="Register.jsp">Register here</a></p>
                        <!-- 点击跳转到注册页面 -->
                    </div>

                    <hr class="my-4"/>
                    <h2 class="fs-5 fw-bold mb-3">Or use a third-party</h2>
                    <button class="w-100 py-2 mb-2 btn btn-outline-dark rounded-3" type="submit">
                        <svg class="bi me-1" width="16" height="16">
                            <use xlink:href="#twitter"/>
                        </svg>
                        Sign up with Twitter
                    </button>
                    <button class="w-100 py-2 mb-2 btn btn-outline-primary rounded-3" type="submit">
                        <svg class="bi me-1" width="16" height="16">
                            <use xlink:href="#facebook"/>
                        </svg>
                        Sign up with Facebook
                    </button>
                    <button class="w-100 py-2 mb-2 btn btn-outline-secondary rounded-3" type="submit">
                        <svg class="bi me-1" width="16" height="16">
                            <use xlink:href="#github"/>
                        </svg>
                        Sign up with GitHub
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#loginForm').submit(function (e) {
            e.preventDefault()
            var email = $('#email').val().trim()
            var password = $('#password').val().trim()

            // 表单验证
            if (email === '' || password === '') {
                $('#error').text('Please fill in both email and password fields.')
                return
            }

            // 使用 AJAX 发送登录信息到后端
            $.ajax({
                // url: 'LoginServlet', // 后端处理登录信息的接口URL
                url: 'http://localhost:8080/GoogleMail/user?model=LoginServlet',
                type: 'POST',
                data: {
                    email: email,
                    password: password,
                },

                success: function (response) {
                    // 后端接口返回登录验证结果
                    if (response.success) {
                        // 登录验证成功，显示成功消息并跳转到 "home" 页面
                        $('#error').text('')
                        // 显示成功消息并跳转到首页或其他目标页面
                        $('#success').text('Login successful.')
                        window.location.href = 'home.jsp'
                    } else {
                        $('#success').text('')
                        // 登录验证失败，显示错误提示
                        $('#error').text('Login failed. Please check your email and password.')
                    }
                },

                error: function (error) {
                    // 发生错误
                    $('#error').text('An error occurred while trying to log in.')
                    console.log(error)
                },
            })
        })
    })
</script>
</body>
</html>
