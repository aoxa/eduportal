package com.eduportal.auth.repository;

import com.eduportal.auth.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Role findByName(String name);

    List<Role> findAllByType(Role.Type type);

    @Query("SELECT role FROM Role role WHERE role.type = 'builtin'")
    List<Role> findAllBuiltins();

    @Query("SELECT role FROM Role role WHERE role.type = 'group'")
    List<Role> findAllGroupRoles();
}
