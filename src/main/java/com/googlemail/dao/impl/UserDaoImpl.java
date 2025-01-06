package com.googlemail.dao.impl;

import com.googlemail.dao.UserDao;
import com.googlemail.pojo.User;
import com.googlemail.utils.JdbcUtil;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDaoImpl implements UserDao {
    private Connection connection;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;

    // 注册用户
    public int addUser(User user) {
        String sql = "INSERT INTO users (email, password, username,avatarPath) VALUES (?, ?, ?, ?)";
        Object[] params = {user.getEmail(), user.getPassword(), user.getUsername(), user.getAvatarPath()};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            return queryRunner.update(sql, params);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //检查用户名是否已经存在 （是否已经注册过）
    public boolean checkUserExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Object[] params = {email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            Long count = queryRunner.query(sql, new ScalarHandler<>(), params);
            return count != null && count > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //    登录
    public boolean login(User user) {
        String sql = "SELECT email,password FROM users WHERE email = ? AND password = ?";
        Object[] params = {user.getEmail(), user.getPassword()};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            User result = queryRunner.query(sql, new BeanHandler<>(User.class), params);
            return result != null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    // 检查邮箱和用户名是否匹配
    public boolean checkEmailAndUsername(String email, String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND username = ?";
        Object[] params = {email, username};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            Long count = queryRunner.query(sql, new ScalarHandler<Long>(), params);
            return count != null && count > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 更新密码
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        Object[] params = {newPassword, email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            int rowsUpdated = queryRunner.update(sql, params);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    // 根据邮箱地址获取用户信息
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Object[] params = {email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            return queryRunner.query(sql, new BeanHandler<>(User.class), params);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 用户注销
    @Override
    public boolean deleteUserByEmail(String email) {
        String sql = "DELETE FROM users WHERE email = ?";
        Object[] params = {email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            int rowsDeleted = queryRunner.update(sql, params);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 更新用户个人资料
    public boolean updateUserProfile(String email, String username, String birthday, String gender) {
        // 检查生日参数并设置为空字符串
        if (birthday == null || birthday.trim().isEmpty()) {
            birthday = null; // 将空字符串替换为 null
        }
        String sql = "UPDATE users SET username = ?, birthday = ?, gender = ? WHERE email = ?";
        Object[] params = {username, birthday, gender, email};
        try {
            QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
            int rowsUpdated = queryRunner.update(sql, params);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 更新头像
    @Override
    public boolean updateUserAvatar(String email, String avatarPath) {
        QueryRunner queryRunner = new QueryRunner(JdbcUtil.getDataSource());
        String sql = "UPDATE users SET avatarPath=? WHERE email=?";
        Object[] params = {avatarPath, email};

        try {
            int rowsUpdated = queryRunner.update(sql, params);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


}
