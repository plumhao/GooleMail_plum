package com.googlemail.service.impl;

import com.googlemail.dao.EmailDao;
import com.googlemail.dao.impl.EmailDaoImpl;
import com.googlemail.pojo.Email;
import com.googlemail.service.EmailService;

import java.util.List;

public class EmailServiceImpl implements EmailService {
    EmailDao emailDao = new EmailDaoImpl();

    @Override
    public List<Email> getInboxEmails(String userEmail, int currentPage, int itemsPerPage) {
        return emailDao.getInboxEmails(userEmail, currentPage, itemsPerPage);
    }

    @Override
    public List<Email> getDrafts(String userEmail, int currentPage, int itemsPerPage) {
        return emailDao.getDrafts(userEmail, currentPage, itemsPerPage);
    }

    @Override
    public List<Email> getSentEmails(String userEmail, int currentPage, int itemsPerPage) {
        return emailDao.getSentEmails(userEmail, currentPage, itemsPerPage);
    }

    @Override
    public List<Email> getEmailsFromDatabase(String query, String userEmail, int offset, int limit) {
        return getEmailsFromDatabase(query, userEmail, offset, limit);
    }

    @Override
    public int getInboxEmailsCount(String userEmail) {
        return emailDao.getInboxEmailsCount(userEmail);
    }

    @Override
    public int getDraftsCount(String userEmail) {
        return emailDao.getDraftsCount(userEmail);
    }

    @Override
    public int getSentEmailsCount(String userEmail) {
        return emailDao.getSentEmailsCount(userEmail);
    }

    @Override
    public int getEmailCount(String query, String userEmail) {
        return emailDao.getEmailCount(query, userEmail);
    }

    @Override
    public void saveEmailAsSent(Email email) {
        emailDao.saveEmailAsSent(email);
    }

    @Override
    public void saveEmailAsDraft(Email email) {
        emailDao.saveEmailAsDraft(email);
    }

    @Override
    public void saveEmailToDatabase(Email email, boolean isDraft, boolean isSent) {
        emailDao.saveEmailToDatabase(email, isDraft, isSent);
    }

    @Override
    public void deleteEmailById(int emailId) {
        emailDao.deleteEmailById(emailId);
    }
}
