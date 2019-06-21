package com.eduportal.web;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import java.io.Serializable;

@Component
@Scope(value = "session",  proxyMode = ScopedProxyMode.TARGET_CLASS)
public class SessionMessage implements Serializable {
    private Type type;

    private String message;

    private boolean pendingDisplay;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public boolean isPendingDisplay() {
        return pendingDisplay;
    }

    public void setPendingDisplay(boolean pendingDisplay) {
        this.pendingDisplay = pendingDisplay;
    }

    public enum Type {warning, success, danger}
}
