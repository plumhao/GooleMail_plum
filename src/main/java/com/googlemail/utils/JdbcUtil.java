package com.googlemail.utils;

import com.alibaba.druid.pool.DruidDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.util.Properties;

public class JdbcUtil {
    private static DataSource dataSource; // 数据源

    static {
        // 1.读取mysql.properties文件
        InputStream ips = JdbcUtil.class.getResourceAsStream("/mysql.properties");

        try {
            // 2.把读取到的输入流加载到properties对象中
            Properties pro = new Properties();
            pro.load(ips);

            // 3.通过druid数据库连接池得到DataSource对象，这个对象中有所有的连接配置数据
            dataSource = DruidDataSourceFactory.createDataSource(pro);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 把Datasource返回
     *
     * @return
     */
    public static DataSource getDataSource() {
        return dataSource;
    }

}
