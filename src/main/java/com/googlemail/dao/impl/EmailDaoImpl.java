package com.googlemail.dao.impl;

import com.googlemail.dao.EmailDao;
import com.googlemail.pojo.Email;
import com.googlemail.utils.JdbcUtil;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmailDaoImpl implements EmailDao {
    private Connection connection;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;


    // 获取与用户邮箱地址相关的收件箱中的邮件（分页）
    public List<Email> getInboxEmails(String userEmail, int currentPage, int itemsPerPage) {
        return getEmailsFromDatabase("SELECT * FROM emails WHERE recipient_email = ? ORDER BY id DESC LIMIT ?, ?", userEmail, (currentPage - 1) * itemsPerPage, itemsPerPage);
    }

    // 获取与用户邮箱地址相关的草稿箱中的草稿（分页）
    public List<Email> getDrafts(String userEmail, int currentPage, int itemsPerPage) {
        return getEmailsFromDatabase("SELECT * FROM emails WHERE is_draft = 1 AND sender_email = ? ORDER BY id DESC LIMIT ?, ?", userEmail, (currentPage - 1) * itemsPerPage, itemsPerPage);
    }

    // 获取与用户邮箱地址相关的发信箱中的邮件（分页）
    public List<Email> getSentEmails(String userEmail, int currentPage, int itemsPerPage) {
        return getEmailsFromDatabase("SELECT * FROM emails WHERE is_sent = 1 AND sender_email = ? ORDER BY id DESC LIMIT ?, ?", userEmail, (currentPage - 1) * itemsPerPage, itemsPerPage);
    }

    // 从数据库中获取与用户邮箱地址相关的邮件数据的通用方法（分页）
    public List<Email> getEmailsFromDatabase(String query, String userEmail, int offset, int limit) {
        List<Email> emails = new ArrayList<>();

        QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
        Object[] objects = {userEmail, offset, limit};
        try {
            emails = queryRunner.query(query, new BeanListHandler<>(Email.class), objects);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emails;

    }

    // 获取与用户邮箱地址相关的收件箱中的邮件数量
    public int getInboxEmailsCount(String userEmail) {
        return getEmailCount("SELECT COUNT(*) AS count FROM emails WHERE recipient_email = ?", userEmail);
    }

    // 获取与用户邮箱地址相关的草稿箱中的草稿数量
    public int getDraftsCount(String userEmail) {
        return getEmailCount("SELECT COUNT(*) AS count FROM emails WHERE is_draft = 1 AND sender_email = ?", userEmail);
    }

    // 获取与用户邮箱地址相关的发信箱中的邮件数量
    public int getSentEmailsCount(String userEmail) {
        return getEmailCount("SELECT COUNT(*) AS count FROM emails WHERE is_sent = 1 AND sender_email = ?", userEmail);
    }

    // 获取与用户邮箱地址相关的邮件数量的通用方法
    public int getEmailCount(String query, String userEmail) {
        Long count = 0L;
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            Object[] objects = {userEmail};
            count = queryRunner.query(query, new ScalarHandler<Long>(), objects);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count != null ? count.intValue() : 0;
    }


    // 保存邮件为发送邮件
    public void saveEmailAsSent(Email email) {
        saveEmailToDatabase(email, false, true); // 将邮件保存到数据库，并设置为"发送邮件"
    }

    // 保存邮件为草稿
    public void saveEmailAsDraft(Email email) {
        saveEmailToDatabase(email, true, false); // 将邮件保存到数据库，并设置为"草稿"
    }

    // 将邮件保存到数据库的通用方法
    public void saveEmailToDatabase(Email email, boolean isDraft, boolean isSent) {
        String query = "INSERT INTO emails (sender_email, recipient_email, subject, content, date_time, is_draft, is_sent) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            Object[] objects = {
                    email.getSender_email(),
                    email.getRecipient_email(),
                    email.getSubject(),
                    email.getContent(),
                    new Timestamp(System.currentTimeMillis()),
                    isDraft,
                    isSent
            };
            queryRunner.update(query, objects);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 根据邮件ID删除邮件
    public int deleteEmailById(int emailId) {
        String query = "DELETE FROM emails WHERE id = ?";
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            Object[] objects = {emailId};
            queryRunner.update(query, objects);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emailId;
    }

    // 用户注销
    @Override
    public boolean deleteEmailsByUserEmail(String email) {
        String query = "DELETE FROM emails WHERE sender_email = ?";
        Object[] params = {email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            int rowsDeleted = queryRunner.update(query, params);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
