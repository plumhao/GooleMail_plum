package com.googlemail.dao;

import com.googlemail.pojo.User;

import java.sql.SQLException;

public interface UserDao {

    /**
     * 用户注册
     *
     * @param user
     * @return
     */
    int addUser(User user) throws SQLException;

    /**
     * 检查用户名是否已经存在 （是否已经注册过）
     *
     * @param email
     * @return
     */
    boolean checkUserExists(String email) throws SQLException;

    /**
     * 登录
     *
     * @param user
     * @return
     */
    boolean login(User user) throws SQLException;

    /**
     * // 检查邮箱和用户名是否匹配
     *
     * @param email
     * @param username
     * @return
     * @throws SQLException
     */
    boolean checkEmailAndUsername(String email, String username) throws SQLException;

    /**
     * 更新密码
     *
     * @param email
     * @param newPassword
     * @return
     * @throws SQLException
     */
    boolean updatePassword(String email, String newPassword) throws SQLException;

    /**
     * 根据邮箱地址获取用户信息
     *
     * @param email
     * @return
     * @throws SQLException
     */
    User getUserByEmail(String email) throws SQLException;

    /**
     * 用户注销
     *
     * @param email
     * @return
     */
    boolean deleteUserByEmail(String email);

    boolean updateUserProfile(String email, String username, String birthday, String gender);

    boolean updateUserAvatar(String email, String avatarPath);

}
