insert into rol (name, type) values ('admin', 'builtin')
insert into rol (name, type) values ('teacher', 'builtin')
insert into rol (name, type) values ('pupil', 'builtin')
insert into rol (name, type) values ('parent', 'builtin')

--- insert into usuario (username, password) values ('siteadmin', MD5('pass'))
insert into usuario (username, password, active) values ('siteadmin', '$2a$10$fcCdrQtnjEdX89nf25Rp5.plcjOJOK8nq1Qpr3..8x.xYFOPXGAPG', true)
insert into usuario_roles (user_id, roles_id) values (1, 1)