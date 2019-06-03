package com.eduportal.repository;

import com.eduportal.model.Settings;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SettingsRepository extends JpaRepository<Settings, String>{
}
