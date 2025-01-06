package com.googlemail.utils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
    响应的结果
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResponseData<T> {
    private boolean success; //响应是否成功
    private String message; //信息
    private T  data; //响应的数据结果

    public ResponseData(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

}
