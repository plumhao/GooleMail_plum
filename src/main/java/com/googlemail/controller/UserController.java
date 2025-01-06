package com.googlemail.controller;

import com.google.gson.Gson;
import com.googlemail.pojo.User;
import com.googlemail.service.UserService;
import com.googlemail.service.impl.UserServiceImpl;
import com.googlemail.utils.BaseServlet;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import com.googlemail.utils.ResponseData;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@WebServlet("/user")
public class UserController extends BaseServlet {
    private UserService userService = new UserServiceImpl();

    public void LoginServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean loginSuccess = userService.login(new User(email, password));
        // 用户登录验证成功后的处理代码
        if (loginSuccess) {
            HttpSession session = request.getSession();
            // 将用户的邮箱地址存储为会话属性
            session.setAttribute("email", email);

            User user = userService.getUserByEmail(email);
            // 将用户名存储为会话属性
            session.setAttribute("user", user);
        }
        String jsonResponse = "{\"success\": " + loginSuccess + "}";
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse);
    }

    public void RegisterServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String username = request.getParameter("username");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (userService.checkUserExists(email)) {   // 检查邮箱是否已存在
            response.setStatus(HttpServletResponse.SC_CONFLICT); // 409 状态码表示冲突
            response.getWriter().write("Email already exists. Please use a different email.");
        } else {   // 将用户信息插入数据库
            String defaultAvatarPath = "upload_images/637716e9-4925-4eec-8a92-0a8b7736393e.png";  // 默认头像路径
            userService.addUser(new User(email, password, username, defaultAvatarPath));
            response.setStatus(HttpServletResponse.SC_OK); // 200 状态码表示成功
            response.getWriter().write("Registration successful. Please log in.");
        }
    }

    public void ForgotPasswordServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");
        // 验证邮箱和用户名是否匹配
        if (userService.checkEmailAndUsername(email, username)) {
            // 更新密码
            boolean passwordUpdated = userService.updatePassword(email, newPassword);
            String jsonResponse = "{\"success\": " + passwordUpdated + "}";
            response.setContentType("application/json");
            // 将 JSON 响应写入 HttpServletResponse 对象中
            response.getWriter().write(jsonResponse);
        }
    }

    public void CheckLoginServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false); // 获取会话对象，如果没有会话则返回null
        if (session != null && session.getAttribute("email") != null) {    // 用户已登录
            response.setContentType("application/json");
            response.getWriter().write("{\"loggedIn\": true}");
        } else {   // 用户未登录
            response.setContentType("application/json");
            response.getWriter().write("{\"loggedIn\": false}");
        }
    }

    public void LogoutServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 禁用页面缓存
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        // 清除用户Session
        request.getSession().invalidate();
        response.sendRedirect("Login.jsp");
    }

    public void DeleteAccountServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String jsonResponse = "Invalid email or password.";

        // 验证用户信息
        if (userService.login(new User(email, password))) {
            boolean accountDeleted = userService.deleteUserAccount(email);
            userService.deleteUserEmails(email);

            if (accountDeleted) {
                // 清除用户Session
                request.getSession().invalidate();
                jsonResponse = "Account and emails deleted successfully.";
                response.setContentType("application/json");
                jsonResponse = "{\"success\": true, \"message\": \"" + jsonResponse + "\"}";
                response.getWriter().write(jsonResponse);
            } else {
                jsonResponse = "Failed to delete account or emails.";
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse = "{\"success\": false, \"message\": \"" + jsonResponse + "\"}";
                response.getWriter().write(jsonResponse);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse = "{\"success\": false, \"message\": \"" + jsonResponse + "\"}";
            response.getWriter().write(jsonResponse);
        }
    }

    public void UpdateProfileServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 从请求中获取用户新资料
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String birthday = request.getParameter("birthday");
        String gender = request.getParameter("gender");

        boolean updated = userService.updateUserProfile(email, username, birthday, gender);

        if (updated) {
            HttpSession session = request.getSession();
            User user = userService.getUserByEmail(email);
            // 将用户名存储为会话属性
            session.setAttribute("user", user);
        }

        String jsonResponse = "{\"success\": " + updated + "}";
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse);
    }

    public void UploadAvatarServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uploadPath = getServletContext().getRealPath("/upload_images");
        File uploadFile = new File(uploadPath);
        if (!uploadFile.exists()) {
            uploadFile.mkdir();
        }
        //1.创建工厂
        DiskFileItemFactory factory = new DiskFileItemFactory();
        //2.创建对象
        ServletFileUpload upload = new ServletFileUpload();
        upload.setFileSizeMax(1024 * 1024 * 10);
        upload.setFileItemFactory(factory);
        //3.处理上传文件
        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                String fileName = item.getFieldName();
                String value = item.getString("UTF-8");
            } else {
                String uploadFileName = item.getName();//上传的路径+文件名
                //得到文件名
                String fileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
                //获取文件的后缀
                String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
                ResponseData responseDate;
                if (!fileExt.equalsIgnoreCase("png") && !fileExt.equalsIgnoreCase("jpg") && !fileExt.equalsIgnoreCase("gif") && !fileExt.equalsIgnoreCase("jpeg")) {
                    responseDate = new ResponseData(false, "上传的格式有误,只支持png、jpg、gif、jpeg格式的图片");
                } else {
                    String UUIDPath = UUID.randomUUID().toString();
                    InputStream ips = item.getInputStream();
                    String nameStr = uploadPath + "/" + UUIDPath + "." + fileExt;
                    FileOutputStream ops = new FileOutputStream(nameStr);
                    byte[] buffer = new byte[1024];
                    int len = 0;
                    while ((len = ips.read(buffer)) > 0) {
                        ops.write(buffer, 0, len);
                    }
                    ops.close();
                    ips.close();
                    String avatarPath = "upload_images/" + UUIDPath + "." + fileExt;

                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("user");
                    userService.updateUserAvatar(user.getEmail(), avatarPath);
                    user.setAvatarPath(avatarPath);
                    session.setAttribute("avatarPath", avatarPath);
                    responseDate = new ResponseData(true, "图片上传成功", avatarPath);
                    Gson gson = new Gson();
                    String str = gson.toJson(responseDate);
                    response.getWriter().print(str);
                }
            }
        }
    }


}
