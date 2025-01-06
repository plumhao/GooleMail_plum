package com.googlemail.dao;

import com.googlemail.pojo.Email;

import java.sql.SQLException;
import java.util.List;

public interface EmailDao {

    /**
     * 获取与用户邮箱地址相关的收件箱中的邮件（分页）
     *
     * @param userEmail
     * @param currentPage
     * @param itemsPerPage
     * @return
     */
    List<Email> getInboxEmails(String userEmail, int currentPage, int itemsPerPage);

    /**
     * 获取与用户邮箱地址相关的草稿箱中的草稿（分页）
     *
     * @param userEmail
     * @param currentPage
     * @param itemsPerPage
     * @return
     */
    List<Email> getDrafts(String userEmail, int currentPage, int itemsPerPage);

    /**
     * 获取与用户邮箱地址相关的发信箱中的邮件（分页）
     *
     * @param userEmail
     * @param currentPage
     * @param itemsPerPage
     * @return
     */
    List<Email> getSentEmails(String userEmail, int currentPage, int itemsPerPage);

    /**
     * 从数据库中获取与用户邮箱地址相关的邮件数据的通用方法（分页）
     *
     * @param query
     * @param userEmail
     * @param offset
     * @param limit
     * @return
     */
    List<Email> getEmailsFromDatabase(String query, String userEmail, int offset, int limit) throws SQLException;

    /**
     * 获取与用户邮箱地址相关的收件箱中的邮件数量
     *
     * @param userEmail
     * @return
     */
    int getInboxEmailsCount(String userEmail);

    /**
     * 获取与用户邮箱地址相关的草稿箱中的草稿数量
     *
     * @param userEmail
     * @return
     */
    int getDraftsCount(String userEmail);

    /**
     * 获取与用户邮箱地址相关的发信箱中的邮件数量
     *
     * @param userEmail
     * @return
     */
    int getSentEmailsCount(String userEmail);

    /**
     * 获取与用户邮箱地址相关的邮件数量的通用方法
     *
     * @param query
     * @param userEmail
     * @return
     */
    int getEmailCount(String query, String userEmail);

    /**
     * 保存邮件为发送邮件
     *
     * @param email
     */
    void saveEmailAsSent(Email email);

    /**
     * 保存邮件为草稿
     *
     * @param email
     */
    void saveEmailAsDraft(Email email);

    /**
     * 将邮件保存到数据库的通用方法
     *
     * @param email
     * @param isDraft
     * @param isSent
     */
    void saveEmailToDatabase(Email email, boolean isDraft, boolean isSent);

    /**
     * 根据邮件ID删除邮件
     *
     * @param emailId
     * @return
     */
    int deleteEmailById(int emailId);

    boolean deleteEmailsByUserEmail(String email);
}
