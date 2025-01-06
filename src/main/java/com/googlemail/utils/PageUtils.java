package com.googlemail.utils;

import com.googlemail.pojo.Email;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageUtils {
    //数据的集合
    private List<Email> emails;
    //总记录数
    private int totalSize;
    //当前页数
    private int currentPage;
    //总页数
    private int totalPage;
    //每页的记录数
    private int pageSize;

}

