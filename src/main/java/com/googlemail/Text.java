package com.googlemail;

import com.googlemail.dao.impl.EmailDaoImpl;
import com.googlemail.dao.impl.UserDaoImpl;


public class Text {

    public static void main(String[] args) {
        // 创建EmailDao实例
        UserDaoImpl userDao = new UserDaoImpl();
        boolean row = userDao.updateUserAvatar("2731626567@qq.com", "upload_images/zb.jpg");
        System.out.println(row);
    }
}
