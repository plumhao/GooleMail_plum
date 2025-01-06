<%--
  Created by IntelliJ IDEA.
  User: plum
  Date: 2023/7/23
  Time: 13:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="en_US"/>

<html>
<head>
    <title>Google Mail</title>
    <link rel="stylesheet" href="./bootstrap-5.3.0-alpha1-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="css/home.css"/>
    <script src="./js/jquery-3.7.0.js"></script>
    <script src="./bootstrap-5.3.0-alpha1-dist/js/bootstrap.bundle.js"></script>

</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <!-- Logo部分 -->
        <a class="navbar-brand" href="#">
            <img src="./img/google_logo.png" alt="Logo" width="109" height="38" style="margin-left: 20px;"
                 class="d-inline-block align-text-top"/>
        </a>

        <!-- 响应式的按钮 -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0" style="margin:0px 0px;padding: 0px 0px;align-items: center">
                <li class="nav-item"><a class="nav-link active" aria-current="page" href="#">Home</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Compose</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">Mail Box</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Inbox</a></li>
                        <li><a class="dropdown-item" href="#">Sent</a></li>
                        <li>
                            <hr class="dropdown-divider"/>
                        </li>
                        <li><a class="dropdown-item" href="#">Drafts</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled"></a>
                </li>

                <!-- 搜索栏 -->
                <li class="nav-item">
                    <form class="d-flex" role="search" id="searchForm" style="margin: 11px 0px">
                        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search"/>
                        <button class="btn btn-outline-success" type="submit" id="searchButton">
                            <img src="./img/search (1).svg" alt=""/>
                        </button>
                    </form>
                </li>
            </ul>

            <!-- 导航栏右边区域 -->
            <div class="flex-shrink-0 dropdown" id="profileDropdown">
                <a href="#" class="d-block link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown"
                   aria-expanded="false">
                    <img src="http://localhost:8080/GoogleMail/${user.avatarPath}" alt="mdo" width="35" height="35"
                         class="rounded-circle"/>
                    <span style="font-size: 14px;font-weight: bold">&nbsp; ${user.username}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-lg-end" id="profileMenu">
                    <li><a class="dropdown-item" href="userProfile.jsp">Profile</a></li>
                    <li><a class="dropdown-item" href="ForgotPassword.jsp">Change Password</a></li>
                    <li>
                        <hr class="dropdown-divider"/>
                    </li>
                    <li><a class="dropdown-item" href="Register.jsp">Add other account</a></li> <!-- 跳转到注册页面 -->
                    <li>
                        <button class="dropdown-item" id="deleteAccountButton">Delete Account</button>
                    </li>
                    <li><a class="dropdown-item" href="http://localhost:8080/GoogleMail/user?model=LogoutServlet">Sign
                        out</a></li>
                    <!-- 这里使用LogoutServlet来处理退出登录逻辑 -->
                </ul>
            </div>
        </div>
    </div>
</nav>


<!-- deleteAccountModal -->
<div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteAccountModalLabel">Confirm Account Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="deleteEmail" class="form-label">Email</label>
                    <input type="email" class="form-control" id="deleteEmail" required>
                </div>
                <div class="mb-3">
                    <label for="deletePassword" class="form-label">Password</label>
                    <input type="password" class="form-control" id="deletePassword" required>
                </div>
                <p class="text-danger" style="font-size: 15px">This action cannot be undone. All your emails will be
                    deleted.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" id="confirmDeleteAccountButton" class="btn btn-danger">Delete Account</button>
            </div>
        </div>
    </div>
</div>


<!-- 主体 -->
<div id="content">
    <div class="d-flex align-items-start">
        <!-- Tab导航栏 -->
        <div class="nav flex-column nav-pills me-3" id="tabNavigation" role="tablist" aria-orientation="vertical">
            <button class="nav-link disabled" id="disabledButton" data-bs-toggle="pill"
                    data-bs-target="#v-pills-disabled" type="button" role="tab" aria-controls="v-pills-disabled"
                    aria-selected="false">
                <img src="./img/google.svg" style="width: 20px; height: 20px" alt=""/>
            </button>
            <button class="nav-link active" id="homeTab" data-bs-toggle="pill" data-bs-target="#v-pills-home"
                    type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">Home
            </button>
            <button class="nav-link" id="composeTab" data-bs-toggle="pill" data-bs-target="#v-pills-profile"
                    type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">Compose
            </button>
            <button class="nav-link" id="inboxTab" data-bs-toggle="pill" data-bs-target="#v-pills-messages"
                    type="button" role="tab" aria-controls="v-pills-messages" aria-selected="false" data-type="inbox">
                Inbox
            </button>
            <button class="nav-link" id="draftsTab" data-bs-toggle="pill" data-bs-target="#v-pills-settings"
                    type="button" role="tab" aria-controls="v-pills-settings" aria-selected="false" data-type="drafts">
                Drafts
            </button>
            <button class="nav-link" id="sentTab" data-bs-toggle="pill" data-bs-target="#v-pills-send" type="button"
                    role="tab" aria-controls="v-pills-send" aria-selected="false" data-type="sent">Sent
            </button>
        </div>

        <!-- 表格界面 -->
        <div class="tab-content" id="tableContent">
            <!-- Table 1 - 欢迎界面 -->
            <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab"
                 tabindex="0">
                <div class="text-center"
                     style="margin-top: 15px; font-family:Brush Script MT ;font-size: 25px; text-align: center;">
                    <!-- 使用JSP的EL表达式显示用户名 -->
                    <p style="font-size: 40px;   text-shadow:0px 1px 0px #c0c0c0, 0px 2px 0px #b0b0b0, 0px 3px 0px #a0a0a0, 0px 4px 0px #909090, 0px 5px 8px rgba(0, 0, 0, .9);">
                        Hello~ ${user.username}!</p>
                    <p>Welcome to my email platform! I'm delighted to have you on board.</p>
                    <p>With this platform, I've aimed to create an email experience that is efficient, enjoyable,
                        and user-friendly.</p>
                    <p>Feel free to explore your emails and get organized effortlessly.</p>
                    <p>If you have any questions, suggestions, or feedback, I'd love to hear from you!</p>
                    <p>Thank you for choosing my email service. I hope you find it useful and enjoyable.</p>
                    <p>Wishing you a wonderful day!</p>
                    <p>Best regards,</p>
                    <p>Plum</p>
                </div>
            </div>

            <!-- Table 2 - 写信 -->
            <div class=" tab-pane fade
                " id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab"
                 tabindex="0">
                <form>
                    <div class="mb-3">
                        <label for="emailTo" class="form-label"><strong>To:</strong></label>
                        <input type="email" class="form-control" id="emailTo" placeholder="Enter recipient email"
                               autocomplete="off"/>
                    </div>
                    <div class="mb-3">
                        <label for="emailSubject" class="form-label"><strong>Subject:</strong></label>
                        <input type="text" class="form-control" id="emailSubject" placeholder="Enter email subject"
                               autocomplete="off"/>
                    </div>
                    <div class="mb-3">
                        <label for="emailContent" class="form-label"><strong>Content:</strong></label>
                        <!-- 添加错误提示和成功消息 -->
                        <div id="error" class="text-danger"></div>
                        <div id="success" class="text-success"></div>

                        <textarea class="form-control" style="resize: none; height: 300px" id="emailContent" rows="10"
                                  placeholder="Enter email content" autocomplete="off"></textarea>
                    </div>
                    <div class="mb-3" id="Compose_btns">
                        <div class="d-flex justify-content-between">
                            <button type="button" class="btn btn-secondary mr-2" id="saveDraftButton">Save Draft
                            </button>
                            <button type="submit" class="btn btn-primary" id="sendEmailButton">Send Email</button>
                            <button type="button" class="btn btn-danger" id="clearButton" data-bs-toggle="modal"
                                    data-bs-target="#clearConfirmationModal">Clear
                            </button>
                        </div>
                    </div>
                </form>
                <!-- 动画 -->
                <div id="dh">
                    <div class="spinner-grow text-secondary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="spinner-grow text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="spinner-grow text-danger" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>

            <!-- Table 3 - 收信箱 -->
            <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab"
                 tabindex="0">
                <div id="inboxButtons">
                    <button type="button" class="btn btn-outline-primary" id="selectAllInboxButton">All</button>
                    <button type="button" class="btn btn-outline-danger delete-button">Delete</button>
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <table class="table" id="inboxTable">
                    <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">From</th>
                        <th scope="col">Subject</th>
                        <th scope="col">Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- 添加一个占位符标签 -->
                    <tr class="table-placeholder">
                        <td colspan="4">Loading...</td>
                    </tr>
                    </tbody>
                </table>

                <!-- 分页栏 -->
                <div class="Pager d-flex justify-content-between align-items-center mt-3 mt-auto">
                    <!-- 显示信息数量 -->
                    <div id="inboxPaginationInfo">Total&nbsp;<span id="inboxTotalItems">0</span>&nbsp;items</div>

                    <!-- 显示页码信息 -->
                    <div id="inboxPageInfo">Page&nbsp;<span id="inboxCurrentPage">1</span>&nbsp;/&nbsp;<span
                            id="inboxTotalPages">1</span>
                    </div>

                    <!-- 分页按钮 -->
                    <div class="btn-group" role="group" aria-label="Pagination">
                        <button type="button" class="btn btn-outline-primary" id="inboxFirstPageButton">First</button>
                        <button type="button" class="btn btn-outline-primary" id="inboxPrevPageButton">Prev</button>
                        <button type="button" class="btn btn-outline-primary" id="inboxNextPageButton">Next</button>
                        <button type="button" class="btn btn-outline-primary" id="inboxLastPageButton">Last</button>
                    </div>
                </div>

            </div>

            <!-- Table 4 - 草稿 -->
            <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab"
                 tabindex="0">
                <div id="draftButtons">
                    <button type="button" class="btn btn-outline-primary" id="selectAllDraftButton">All</button>
                    <button type="button" class="btn btn-outline-danger delete-button">Delete</button>
                    <div class="spinner-border text-warning" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <table class="table" id="draftTable">
                    <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">Draft Subject</th>
                        <th scope="col">Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- 添加一个占位符标签 -->
                    <tr class="table-placeholder">
                        <td colspan="3">Loading...</td>
                    </tr>
                    </tbody>
                </table>
                <!-- 分页栏 -->
                <div class="Pager d-flex justify-content-between align-items-center mt-3">
                    <!-- 显示信息数量 -->
                    <div id="draftPaginationInfo">Total&nbsp;<span id="draftsTotalItems">0</span>&nbsp;items</div>
                    <!-- 显示页码信息 -->
                    <div id="draftPageInfo">Page&nbsp;<span id="draftCurrentPage">1</span>&nbsp;/&nbsp;<span
                            id="draftTotalPages">1</span>
                    </div>
                    <!-- 分页按钮 -->
                    <div class="btn-group" role="group" aria-label="Pagination">
                        <button type="button" class="btn btn-outline-primary" id="draftFirstPageButton">First</button>
                        <button type="button" class="btn btn-outline-primary" id="draftPrevPageButton">Prev</button>
                        <button type="button" class="btn btn-outline-primary" id="draftNextPageButton">Next</button>
                        <button type="button" class="btn btn-outline-primary" id="draftLastPageButton">Last</button>
                    </div>
                </div>
            </div>

            <!-- Table 5 - 发信箱 -->
            <div class="tab-pane fade" id="v-pills-send" role="tabpanel" aria-labelledby="v-pills-send-tab"
                 tabindex="0">
                <div id="sendButtons">
                    <button type="button" class="btn btn-outline-primary" id="selectAllSentButton">All</button>
                    <button type="button" class="btn btn-outline-danger delete-button">Delete</button>
                    <div class="spinner-border text-success" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>

                <table class="table" id="sentTable">
                    <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">To</th>
                        <th scope="col">Subject</th>
                        <th scope="col">Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- 添加一个占位符标签 -->
                    <tr class="table-placeholder">
                        <td colspan="4">Loading...</td>
                    </tr>
                    </tbody>
                </table>

                <!-- 分页栏 -->
                <div class="Pager d-flex justify-content-between align-items-center mt-3">
                    <!-- 显示信息数量 -->
                    <div id="sentPaginationInfo">Total&nbsp;<span id="sentTotalItems">0</span>&nbsp;items</div>
                    <!-- 显示页码信息 -->
                    <div id="sentPageInfo">Page&nbsp;<span id="sentCurrentPage">1</span>&nbsp;/&nbsp;<span
                            id="sentTotalPages">1</span>
                    </div>
                    <!-- 分页按钮 -->
                    <div class="btn-group" role="group" aria-label="Pagination">
                        <button type="button" class="btn btn-outline-primary" id="sentFirstPageButton">First</button>
                        <button type="button" class="btn btn-outline-primary" id="sentPrevPageButton">Prev
                        </button>
                        <button type="button" class="btn btn-outline-primary" id="sentNextPageButton">Next
                        </button>
                        <button type="button" class="btn btn-outline-primary" id="sentLastPageButton">Last</button>
                    </div>
                </div>
            </div>


            <!-- 清空确认模态框 -->
            <div class="modal fade" id="clearConfirmationModal" tabindex="-1"
                 aria-labelledby="clearConfirmationModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="clearConfirmationModalLabel">Clear Text Area</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">Are you sure you want to clear the text area?</div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-primary" id="confirmClearButton">Clear</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 详细信息模态框 -->
<div class="modal fade" id="emailDetailsModal" tabindex="-1" aria-labelledby="emailDetailsModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="emailDetailsModalLabel">Email Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="replyForm"> <!-- 添加form元素 -->
                <div class="modal-body" style="padding-bottom: 5px">
                    <div class="mb-3">
                        <label for="detailsFrom" class="form-label"><strong>From:</strong></label>
                        <input type="email" class="form-control" id="detailsFrom" readonly/>
                    </div>
                    <div class="mb-3">
                        <label for="detailsTo" class="form-label"><strong>To:</strong></label>
                        <input type="email" class="form-control" id="detailsTo" readonly/>
                    </div>
                    <div class="mb-3">
                        <label for="detailsSubject" class="form-label"><strong>Subject:</strong></label>
                        <input type="text" class="form-control" id="detailsSubject" autocomplete="off" readonly/>
                    </div>
                    <div class="mb-3">
                        <label for="detailsDate" class="form-label"><strong>Date:</strong></label>
                        <input type="text" class="form-control" id="detailsDate" readonly/>
                    </div>
                    <div class="mb-3">
                        <label for="detailsContent" class="form-label"><strong>Content:</strong></label>
                        <textarea class="form-control" style="resize: none; height: 200px; overflow-y: auto"
                                  id="detailsContent" rows="10" readonly></textarea>
                    </div>
                </div>
                <div class="modal-footer" style="padding: 10px 10px;">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button class="btn btn-primary reply-btn" id="editButton" type="button">Edit</button>
                    <button class="btn btn-primary reply-btn" id="sendReplyButton" type="submit" disabled>Reply</button>
                </div>
            </form>
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

    // 在页面加载完成时调用checkUserLoggedIn()函数
    $(document).ready(function () {
        checkUserLoggedIn();
        // 默认加载第一页的收信箱、草稿和发信箱数据
        loadTableContent('#v-pills-messages', 'inbox', 1, itemsPerPage);
        loadTableContent('#v-pills-settings', 'drafts', 1, itemsPerPage);
        loadTableContent('#v-pills-send', 'sent', 1, itemsPerPage);
    });

    // 添加分页栏代码
    // 分页相关的全局变量
    var inboxCurrentPage = 1;
    var draftCurrentPage = 1;
    var sentCurrentPage = 1;
    var itemsPerPage = 13; // 每页显示的邮件数量

    // 更新分页栏显示信息
    function updatePaginationInfo(dataType, currentPage, totalPages, totalItems) {
        $('#' + dataType + 'CurrentPage').text(currentPage);
        $('#' + dataType + 'TotalPages').text(totalPages);
        $('#' + dataType + 'TotalItems').text(totalItems);
    }

    // 处理点击分页按钮的事件
    function handlePaginationButtonClick(dataType, targetPage) {
        var type_target;
        // 更新当前页码
        if (dataType === 'inbox') {
            inboxCurrentPage = targetPage;
            type_target = '#v-pills-messages'
        } else if (dataType === 'drafts') {
            draftCurrentPage = targetPage;
            type_target = '#v-pills-settings'
        } else if (dataType === 'sent') {
            sentCurrentPage = targetPage;
            type_target = '#v-pills-send'
        }
        // 加载相应页码的邮件
        loadTableContent(type_target, dataType, targetPage, itemsPerPage);
    }


    // Ajax加载邮件列表数据
    function loadTableContent(target, dataType, currentPage, itemsPerPage) {
        $.ajax({
            url: 'http://localhost:8080/GoogleMail/email?model=ShowEmailsServlet',
            type: 'GET',
            data: {
                dataType: dataType,
                currentPage: currentPage,
                itemsPerPage: itemsPerPage
            },
            dataType: 'json',
            success: function (data) {
                // 计算总页数
                var totalPages = Math.ceil(data.totalItems / itemsPerPage);
                // 更新分页栏信息
                updatePaginationInfo(dataType, currentPage, totalPages, data.totalItems);

                // 填充表格
                var tableBody = $(target).find('tbody');
                tableBody.empty(); // 清空表格内容
                $.each(data.emails, function (index, email) {
                    var tr = $('<tr class="message-row"></tr>');
                    tr.attr({
                        'data-type': dataType,
                        'data-id': email.id,
                        'data-sender': email.sender_email,
                        'data-subject': email.subject,
                        'data-dateTime': email.date_time,
                        'data-recipient': email.recipient_email,
                        'data-content': email.content
                    });

                    var formattedDate = formatDate(email.date_time); // 转换为指定格式的日期字符串

                    if (dataType === 'inbox') {
                        tr.append('<td><input class="form-check-input message-checkbox" type="checkbox" value=""/></td>');
                        tr.append('<td>' + email.sender_email + '</td>');
                        tr.append('<td>' + email.subject + '</td>');
                        tr.append('<td class="time">' + formattedDate + '</td>');
                    } else if (dataType === 'drafts') {
                        tr.append('<td><input class="form-check-input draft-checkbox" type="checkbox" value=""/></td>');
                        tr.append('<td>' + email.subject + '</td>');
                        tr.append('<td class="time">' + formattedDate + '</td>');
                    } else if (dataType === 'sent') {
                        tr.append('<td><input class="form-check-input sent-checkbox" type="checkbox" value=""/></td>');
                        tr.append('<td>' + email.recipient_email + '</td>');
                        tr.append('<td>' + email.subject + '</td>');
                        tr.append('<td class="time">' + formattedDate + '</td>');
                    }
                    tableBody.append(tr);
                });
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log('Error loading table data: ' + errorThrown);
            }
        });
    }


    // 格式化日期为年-月-日时分格式（YYYY-MM-DD HH:mm）
    function formatDate(dateString) {
        var date = new Date(dateString);
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    }

    // 点击收信箱分页按钮的事件处理
    $('#inboxFirstPageButton').click(function () {
        handlePaginationButtonClick('inbox', 1);
    });

    $('#inboxPrevPageButton').click(function () {
        if (inboxCurrentPage > 1) {
            handlePaginationButtonClick('inbox', inboxCurrentPage - 1);
        }
    });

    $('#inboxNextPageButton').click(function () {
        if (inboxCurrentPage < parseInt($('#inboxTotalPages').text())) {
            handlePaginationButtonClick('inbox', inboxCurrentPage + 1);
        }
    });

    $('#inboxLastPageButton').click(function () {
        handlePaginationButtonClick('inbox', parseInt($('#inboxTotalPages').text()));
    });

    // 点击草稿分页按钮的事件处理
    $('#draftFirstPageButton').click(function () {
        handlePaginationButtonClick('drafts', 1);
    });

    $('#draftPrevPageButton').click(function () {
        if (draftCurrentPage > 1) {
            handlePaginationButtonClick('drafts', draftCurrentPage - 1);
        }
    });

    $('#draftNextPageButton').click(function () {
        if (draftCurrentPage < parseInt($('#draftTotalPages').text())) {
            handlePaginationButtonClick('drafts', draftCurrentPage + 1);
        }
    });

    $('#draftLastPageButton').click(function () {
        handlePaginationButtonClick('drafts', parseInt($('#draftTotalPages').text()));
    });

    // 点击发信箱分页按钮的事件处理
    $('#sentFirstPageButton').click(function () {
        handlePaginationButtonClick('sent', 1);
    });

    $('#sentPrevPageButton').click(function () {
        if (sentCurrentPage > 1) {
            handlePaginationButtonClick('sent', sentCurrentPage - 1);
        }
    });

    $('#sentNextPageButton').click(function () {
        if (sentCurrentPage < parseInt($('#sentTotalPages').text())) {
            handlePaginationButtonClick('sent', sentCurrentPage + 1);
        }
    });

    $('#sentLastPageButton').click(function () {
        handlePaginationButtonClick('sent', parseInt($('#sentTotalPages').text()));
    });


    $(document).ready(function () {
        var itemsPerPage = 13; // 每页显示的邮件数量
        var currentTab;
        // Ajax点击tabNavigation中的按钮
        $('#tabNavigation .nav-link').click(function () {
            var target = $(this).attr('data-bs-target');
            // 判断当前点击的是不是"Inbox"、"Drafts"或"Sent"按钮
            var isInboxOrDraftsOrSent = $(this).is('#inboxTab, #draftsTab, #sentTab');
            currentTab = target;
            // 移除所有按钮的active类
            $('#tabNavigation .nav-link').removeClass('active');
            // 给被点击的按钮添加active类
            $(this).addClass('active');

            // 判断目标tab-pane是否包含占位符
            if (isInboxOrDraftsOrSent && $(target).find('.table-placeholder').length > 0) {
                // 使用Ajax加载表格内容
                var dataType = $(this).attr('data-type');
                loadTableContent(target, dataType, 1, itemsPerPage);
            }
            // 显示或隐藏目标tab-pane
            if (!isInboxOrDraftsOrSent) {
                // 隐藏所有的tab-pane，排除"Inbox"、"Drafts"和"Sent"
                $('#tableContent .tab-pane:not(#v-pills-messages, #v-pills-settings, #v-pills-send)').hide();
                // 显示目标tab-pane
                $(target).show();
            }
        });

        // All按钮的事件
        // 全选/取消全选按钮点击事件
        $('#selectAllInboxButton').click(function () {
            toggleSelectAll('.message-checkbox', this)
        })

        $('#selectAllDraftButton').click(function () {
            toggleSelectAll('.draft-checkbox', this)
        })

        $('#selectAllSentButton').click(function () {
            toggleSelectAll('.sent-checkbox', this)
        })

        // 全选/取消全选
        function toggleSelectAll(checkboxClass, button) {
            var isChecked = $(button).hasClass('active')
            $(button).toggleClass('active', !isChecked)
            $(checkboxClass).prop('checked', !isChecked)
            updateRowBackgrounds($(checkboxClass))
        }

        // 复选框改变事件
        $('.message-checkbox, .draft-checkbox, .sent-checkbox').change(function () {
            event.stopPropagation(); // 阻止事件冒泡
            updateRowBackgrounds($(this))
        })

        // 更新行的背景色
        function updateRowBackgrounds(checkbox) {
            var isChecked = checkbox.is(':checked')
            checkbox.closest('.message-row').toggleClass('selected-row', isChecked)
        }

// 点击删除按钮的事件处理程序
        $('.delete-button').click(function () {
            var selectedEmailIds = [];
            // 遍历所有选中的复选框，并获取对应的邮件ID
            $('#inboxTable .message-checkbox:checked, #draftTable .draft-checkbox:checked, #sentTable .sent-checkbox:checked').each(function () {
                var messageId = $(this).closest('.message-row').data('id');
                selectedEmailIds.push(messageId);
            });
            // 发送选中的邮件ID数组到后端的Servlet进行删除操作
            deleteEmails(selectedEmailIds);
        });

// 删除选中的邮件
        function deleteEmails(selectedEmailIds) {
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/email?model=DeleteEmailsServlet', // 后端处理删除邮件的Servlet的URL
                type: 'POST',
                data: {selectedEmailIds: JSON.stringify(selectedEmailIds)}, // 将数组转换为JSON字符串
                success: function (response) {
                    // 删除成功后，调用函数来局部刷新对应的邮件列表
                    console.log('success delete')
                    loadTableContent('#v-pills-send', 'sent', inboxCurrentPage, itemsPerPage);
                    loadTableContent('#v-pills-settings', 'drafts', draftCurrentPage, itemsPerPage);
                    loadTableContent('#v-pills-messages', 'inbox', sentCurrentPage, itemsPerPage);
                },
                error: function (error) {
                    console.log('An error occurred while deleting the selected emails.');
                },
            });
        }

        // Clear按钮的点击事件
        $('#clearButton').click(function () {
            $('#clearConfirmationModal').modal('show') // 显示清空确认模态框
        })

        // 清空确认按钮点击事件
        $('#confirmClearButton').click(function () {
            $('#emailContent').val('') // 清空文本域内容
            $('#clearConfirmationModal').modal('hide') // 关闭清空确认模态框
        })
        // 取消按钮点击事件（无需添加额外代码，使用默认的关闭模态框行为）

        // 发送邮件按钮点击事件
        $('#sendEmailButton').click(function (event) {
            event.preventDefault(); // 阻止表单默认提交行为

            var recipient = $('#emailTo').val();
            var subject = $('#emailSubject').val();
            var content = $('#emailContent').val();

            // 检查收件人、主题和内容是否为空
            if (recipient.trim() === '' || subject.trim() === '' || content.trim() === '') {
                $('#success').text('')
                $('#error').text('请输入收件人、主题和内容。')
                // 超过指定时间后清空文本
                setTimeout(function () {
                    $('#error').text('');
                }, 3000);
                return;
            }

            var email = {
                senderEmail: '${user.email}', // 使用JSP的EL表达式获取登录用户的邮箱
                recipientEmail: recipient,
                subject: subject,
                content: content
            };

            // 使用AJAX发送邮件数据到后端
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/email?model=SaveSendServlet', // 后端处理发送邮件的接口URL
                type: 'POST',
                data: email,

                success: function (response) {
                    $('#error').text('')
                    $('#success').text('邮件发送成功!')

                    $('#emailTo').val(''); // 清空收件人输入框
                    $('#emailSubject').val(''); // 清空主题输入框
                    $('#emailContent').val(''); // 清空内容输入框
                    setTimeout(function () {
                        $('#success').text('');
                    }, 3000);
                    // 发送邮件成功后，更新表格数据
                    loadTableContent('#v-pills-send', 'sent', inboxCurrentPage, itemsPerPage);
                },

                error: function (error) {
                    $('#success').text('')
                    $('#error').text('发送邮件时出错。')
                    setTimeout(function () {
                        $('#error').text('');
                    }, 3000);
                }
            });
        });


        // 存草稿按钮点击事件
        $('#saveDraftButton').click(function () {
            var recipient = $('#emailTo').val();
            var subject = $('#emailSubject').val();
            var content = $('#emailContent').val();

            // 检查收件人和主题是否为空
            if (recipient.trim() === '' || subject.trim() === '') {
                $('#success').text('')
                $('#error').text('请输入收件人和主题。')
                setTimeout(function () {
                    $('#error').text('');
                }, 3000);
                return;
            }

            var email = {
                senderEmail: '${userEmail}', // 使用JSP的EL表达式获取登录用户的邮箱
                recipientEmail: recipient,
                subject: subject,
                content: content
            };

            // 使用AJAX存储草稿数据到后端
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/email?model=SaveDraftServlet', // 后端处理存草稿的接口URL
                type: 'POST',
                data: email,

                success: function (response) {
                    $('#error').text('')
                    $('#success').text('草稿保存成功！')
                    $('#emailTo').val(''); // 清空收件人输入框
                    $('#emailSubject').val(''); // 清空主题输入框
                    $('#emailContent').val(''); // 清空内容输入框
                    setTimeout(function () {
                        $('#success').text('');
                    }, 3000);
                    loadTableContent('#v-pills-settings', 'drafts', draftCurrentPage, itemsPerPage);
                },
                error: function (error) {
                    $('#success').text('')
                    $('#error').text('保存草稿时出错。')
                    setTimeout(function () {
                        $('#error').text('');
                    }, 3000);
                }
            });
        });


        // 事件委托：将点击事件绑定到父元素上
        $('#inboxTable, #draftTable, #sentTable').on('click', '.message-row', function () {
            // 阻止事件冒泡，避免复选框点击事件触发父元素的点击事件
            if ($(event.target).is('input[type="checkbox"]')) {
                event.stopPropagation();
                return;
            }
            // 获取被点击行的数据
            var sender = $(this).data('sender');
            var recipient = $(this).data('recipient');
            var subject = $(this).data('subject');
            var dateTime = $(this).find('.time').text();
            var content = $(this).data('content');
            var type = $(this).data('type');

            // 将数据填充到 emailDetailsModal 中
            $('#detailsFrom').val(sender);
            $('#detailsTo').val(recipient);
            $('#detailsSubject').val(subject);
            $('#detailsDate').val(dateTime);
            $('#detailsContent').val(content);

            // 显示 emailDetailsModal
            $('#emailDetailsModal').modal('show');
            $('#sendReplyButton').prop('disabled', true);

        });

// "Edit" 按钮的点击事件处理函数
        $('#editButton').click(function () {
            // 将邮件内容和主题设置为可编辑
            $('#detailsContent, #detailsSubject').removeAttr('readonly');
            // 启用 "Reply" 按钮
            $('#sendReplyButton').prop('disabled', false);
        });

// 表单提交事件
        $('#replyForm').submit(function (event) {
            event.preventDefault(); // 阻止表单默认提交行为
            // 获取详细信息
            var sender = $('#detailsFrom').val();
            var recipient = $('#detailsTo').val();
            var subject = $('#detailsSubject').val();
            var content = $('#detailsContent').val(); // 获取可编辑的邮件内容

            if (currentTab === '#v-pills-messages') {
                // 如果是收信箱的邮件,回复的发件人要反转一下
                sendEmail(recipient, sender, subject, content);
            } else {
                sendEmail(sender, recipient, subject, content);
            }
            loadTableContent('#v-pills-send', 'sent', inboxCurrentPage, itemsPerPage);
            // 隐藏 "查看详细信息" 模态框
            $('#emailDetailsModal').modal('hide');

        });

// 发送邮件函数
        function sendEmail(sender, recipient, subject, content) {
            // 判断邮件是否符合发送条件（收件人和主题不为空）
            if (recipient.trim() === '' || subject.trim() === '') {
                // 显示错误消息
                $('#error').text('请输入收件人和主题。');
                setTimeout(function () {
                    $('#error').text('');
                }, 3000);
                return;
            }

            var email = {
                senderEmail: sender,
                recipientEmail: recipient,
                subject: subject,
                content: content
            };

            // 使用 AJAX 发送邮件数据到后端
            $.ajax({
                url: 'http://localhost:8080/GoogleMail/email?model=SaveSendServlet', // 后端处理发送邮件的接口 URL
                type: 'POST',
                data: email,
                success: function (response) {
                    loadTableContent('#v-pills-send', 'sent', inboxCurrentPage, itemsPerPage);
                },
                error: function (error) {
                    // 显示发送失败消息
                    $('#error').text('发送邮件时出错。');
                    setTimeout(function () {
                        $('#error').text('');
                    }, 3000);
                    // 添加邮件发送失败后的处理代码
                }
            });
        }
    })

    // 用户注销
    $(document).ready(function () {
        $('#deleteAccountButton').click(function () {
            $('#deleteAccountModal').modal('show');
        });

        $('#confirmDeleteAccountButton').click(function () {
            var email = $('#deleteEmail').val();
            var password = $('#deletePassword').val();

            if (email && password) {
                $.ajax({
                    url: 'http://localhost:8080/GoogleMail/user?model=DeleteAccountServlet',
                    type: 'POST',
                    data: {
                        email: email,
                        password: password,
                    },
                    success: function (response) {
                        $('.text-danger').text(response.message);
                        if (response.success) {
                            alert("Your account has been successfully deleted. We appreciate your time with us. Goodbye!");
                            window.location.reload(); // 刷新当前页面
                        }
                    },
                    error: function (xhr, status, error) {
                        var responseJson = JSON.parse(xhr.responseText);
                        if (responseJson.success === false) {
                            $('.text-danger').text(responseJson.message);
                        }
                    }
                });
            } else {
                $('.text-danger').text("Please enter both email and password.");
            }
        });
    });

</script>
</body>
</html>
