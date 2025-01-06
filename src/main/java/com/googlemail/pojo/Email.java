package com.googlemail.pojo;

import lombok.Data;

import java.sql.Timestamp;


@Data

public class Email {

    private int id;
    private String sender_email;
    private String recipient_email;
    private String subject;
    private String content;
    private Timestamp date_time;
    private boolean is_draft;
    private boolean is_sent;

    public Email() {
    }

    public Email(String sender_email, String recipient_email, String subject, String content) {
        this.sender_email = sender_email;
        this.recipient_email = recipient_email;
        this.subject = subject;
        this.content = content;
    }

    public Email(int id, String sender_email, String recipient_email, String subject, String content, Timestamp date_time, boolean is_draft, boolean is_sent) {
        this.id = id;
        this.sender_email = sender_email;
        this.recipient_email = recipient_email;
        this.subject = subject;
        this.content = content;
        this.date_time = date_time;
        this.is_draft = is_draft;
        this.is_sent = is_sent;
    }
}

