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

    @Query("SELECT u FROM User u join fetch u.groups g  join fetch g.roles rg join fetch u.roles r where ?1 in (r) or ?1 in (rg)")
    List<User> findAllByRoles(Role role);
}
