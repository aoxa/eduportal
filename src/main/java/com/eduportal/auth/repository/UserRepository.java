package com.eduportal.auth.repository;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {
    @Query("SELECT u FROM User u where lower(u.username) = lower(?1) AND u.active = true")
    User findByUsername(String username);

    User findByEmail(String email);

    List<User> findAllByUsernameIsLikeIgnoreCase(String username);

    List<User> findAllByRoles(Role role);
}
