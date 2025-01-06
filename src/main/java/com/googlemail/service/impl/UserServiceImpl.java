package com.googlemail.service.impl;

import com.googlemail.dao.EmailDao;
import com.googlemail.dao.UserDao;
import com.googlemail.dao.impl.EmailDaoImpl;
import com.googlemail.dao.impl.UserDaoImpl;
import com.googlemail.pojo.User;
import com.googlemail.service.UserService;

import java.sql.SQLException;

public class UserServiceImpl implements UserService {

    UserDao userDao = new UserDaoImpl();
    EmailDao emailDao = new EmailDaoImpl();

    @Override
    public int addUser(User user) throws SQLException {
        return userDao.addUser(user);
    }

    @Override
    public boolean checkUserExists(String email) throws SQLException {
        return userDao.checkUserExists(email);
    }

    @Override
    public boolean login(User user) throws SQLException {
        return userDao.login(user);
    }

    @Override
    public boolean checkEmailAndUsername(String email, String username) throws SQLException {
        return userDao.checkEmailAndUsername(email, username);
    }

    @Override
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        return userDao.updatePassword(email, newPassword);
    }

    @Override
    public User getUserByEmail(String email) throws SQLException {
        return userDao.getUserByEmail(email);
    }

    @Override
    public boolean deleteUserAccount(String email) {
        return userDao.deleteUserByEmail(email);
    }

    @Override
    public boolean deleteUserEmails(String email) {
        return emailDao.deleteEmailsByUserEmail(email);
    }

    @Override
    public boolean updateUserProfile(String email, String username, String birthday, String gender) {
        return userDao.updateUserProfile(email, username, birthday, gender);
    }

    @Override
    public boolean updateUserAvatar(String email, String avatarPath) {
        return userDao.updateUserAvatar(email, avatarPath);
    }


}
