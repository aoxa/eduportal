insert into rol (name) values ('admin')
insert into rol (name) values ('usuario')
insert into rol (name) values ('profesor')
insert into rol (name) values ('alumno')
insert into rol (name) values ('padre')

--- insert into usuario (username, password) values ('siteadmin', MD5('pass'))
insert into usuario (username, password, active) values ('siteadmin', '$2a$10$fcCdrQtnjEdX89nf25Rp5.plcjOJOK8nq1Qpr3..8x.xYFOPXGAPG', true)
insert into usuario_roles (users_id, roles_id) values (1, 1)