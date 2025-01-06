package com.googlemail.controller;

import com.google.gson.Gson;
import com.googlemail.pojo.Email;
import com.googlemail.service.EmailService;
import com.googlemail.service.impl.EmailServiceImpl;
import com.googlemail.utils.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/email")
public class EmailController extends BaseServlet {
    private EmailService emailService = new EmailServiceImpl();

    public void ShowEmailsServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 获取数据类型参数，例如：inbox, drafts, sent
        String dataType = request.getParameter("dataType");
        // 获取当前用户的邮箱地址
        HttpSession session = request.getSession();
        String currentUserEmail = (String) session.getAttribute("email");
        // 获取分页参数：当前页码和每页显示的邮件数量
        int currentPage = Integer.parseInt(request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "1");
        int itemsPerPage = Integer.parseInt(request.getParameter("itemsPerPage") != null ? request.getParameter("itemsPerPage") : "10");

        List<Email> emails = null;
        int totalItems = 0; // 总邮件数
        if ("inbox".equals(dataType)) {
            emails = emailService.getInboxEmails(currentUserEmail, currentPage, itemsPerPage);
            totalItems = emailService.getInboxEmailsCount(currentUserEmail); // 获取收件箱总邮件数
        } else if ("drafts".equals(dataType)) {
            emails = emailService.getDrafts(currentUserEmail, currentPage, itemsPerPage);
            totalItems = emailService.getDraftsCount(currentUserEmail); // 获取草稿箱总邮件数
        } else if ("sent".equals(dataType)) {
            emails = emailService.getSentEmails(currentUserEmail, currentPage, itemsPerPage);
            totalItems = emailService.getSentEmailsCount(currentUserEmail); // 获取发件箱总邮件数
        }

        // 计算总页数
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

        // 创建一个 Map 存放邮件数据和分页信息
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("totalItems", totalItems);
        responseData.put("totalPages", totalPages);
        responseData.put("currentPage", currentPage);
        responseData.put("emails", emails);

        // 将 Map 转换为 JSON 格式的数据
        Gson gson = new Gson();
        String jsonData = gson.toJson(responseData);
        response.setContentType("application/json");
        response.getWriter().write(jsonData);
    }

    public void DeleteEmailsServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String selectedEmailIdsJson = request.getParameter("selectedEmailIds");
        Gson gson = new Gson();
        String[] selectedEmailIds = gson.fromJson(selectedEmailIdsJson, String[].class);
        if (selectedEmailIds == null || selectedEmailIds.length == 0) return;
        // 调用数据库操作的方法，实现删除选中的邮件
        for (String emailIdStr : selectedEmailIds) {
            int id = Integer.parseInt(emailIdStr); // 将邮件ID字符串转换为整数类型
            emailService.deleteEmailById(id); // 调用EmailDao的实例方法来删除邮件
        }
    }

    public void SaveSendServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String senderEmail = request.getParameter("senderEmail");
        String recipientEmail = request.getParameter("recipientEmail");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        emailService.saveEmailAsSent(new Email(senderEmail, recipientEmail, subject, content));
    }

    public void SaveDraftServlet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String senderEmail = request.getParameter("senderEmail");
        String recipientEmail = request.getParameter("recipientEmail");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        emailService.saveEmailAsDraft(new Email(senderEmail, recipientEmail, subject, content));
    }

}
