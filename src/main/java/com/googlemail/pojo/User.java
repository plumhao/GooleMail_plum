package com.googlemail.pojo;

import lombok.Data;

@Data
public class User {
    private String email; // 邮箱
    private String password; // 密码
    private String username; // 用户名
    private String birthday; // 生日
    private String gender; // 性别
    private String avatarPath; // 头像路径


    // 无参构造函数
    public User() {
    }

    public User(String email, String password, String username, String avatarPath) {
        this.email = email;
        this.password = password;
        this.username = username;
        this.avatarPath = avatarPath;
    }

    public User(String email, String password) {
        this.email = email;
        this.password = password;
    }


    // 带参构造函数
    public User(String email, String password, String username) {
        this.email = email;
        this.password = password;
        this.username = username;
    }


}

