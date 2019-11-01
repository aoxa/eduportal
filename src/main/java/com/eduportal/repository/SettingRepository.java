package com.eduportal.repository;

import com.eduportal.model.Setting;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SettingRepository extends JpaRepository<Setting, String>{
}
